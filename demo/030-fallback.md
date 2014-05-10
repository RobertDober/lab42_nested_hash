
# Lab42::NHash QED 

## Fallbacks

Fallbacks are a combination of the block that can be provided to `Hash#fetch` and the block in the
`Hash.new` method.

Fallbacks are triggered whenever a `get/fetch` call would trigger a `KeyError`. The handler is
defined dynamically as it can be pushed to and popped off a fallback stack. Inside the handler
the special method `again` can be called to reexecute the `get/fetch`. If no changes have been
made to the `NHash` instance before `again` is invoked the fallback logic will detect the loop
and raise a `KeyError` instead.

### Base Case

When defining a fallback this is done via a callback block or lambda param.

Here is a trivial example

```ruby
    nh = NHash.new 'a' => 1, 'b' => 2

    nh.push_fallback do
      nh.get 'b'
    end

    nh.get('c').assert == 2

    nh.pop_fallback
 
    KeyError.assert.raised? do
      nh.get 'c'
    end

```

The lambda parameter takes precedence by the way.

```ruby
    nh.push_fallback ->{ 42 } do 43 end
    nh.fetch('c').assert == 42
    nh.pop_fallback
```

You might have spotted the necessity to invoke `pop_fallback` in order to
make the next (actually the after next assertion) hold.

That is why most of the time it is covinient to use the `with_*` pattern


```ruby
    nh.with_fallback ->{ 42 } do
      nh.get( 'c' ).assert == 42
    end
    
    KeyError.assert.raised? do
      nh.get 'c'
    end
```

### Full Fallback API

As mention above, this base case is very close to using a `Hash` with a default but the `NHash` instance, which is also
passed into the callback is offering a much more poweful API.

A common use case would be to change an affix if a contextual key is not found, e.g.

```ruby
    nh = NHash.new(
      '1' => { 'de' => 'eins', 'en' => 'one' },
      '2' => { 'fr' => 'deux', 'en' => 'two' }
    ).push_fallback do |h|
      h.with_suffix 'en' do
        h.again
      end
    end
```

Here we need the API, because in case of a lookup failure we want to repeat the get
with the same parameters but in a different context


```ruby
    nh.push_suffix 'de'
    nh.get( '1.' ).assert == 'eins'
    nh.get( '2.' ).assert == 'two'
```

It is important to notice that again needs to be used to avoid an endless loop when the fallback
fails too, however, the fallback logic can (easily) detect that kind of a loop and when doing so
it just raises a KeyError, because that's what it really is, right!


```ruby
    # And *not* StackOverflow
    KeyError.assert.raised? do
      nh.get( '3.' )
    end
```


### Affix Related Helpers

In order to achieve something useful in our fallback handlers we need either to do something unrelated to
the `get/fetch` call that triggered the fallback (thus emulating Hash's default behavior) or, by changing
the _context_ try again.

It stands to reason that, _changing the context_ will be a synonym to changing the affix stacks. Here is
an example that tries to get the correctly flected noun.

```ruby
    nouns = {
      en: {
        person: {
          many: 'people',
          one: 'person',
          none: 'nobody'
        },
        sheep: {
          one: 'sheep'
        },
        dog: {
          many: 'dogs',
          one: 'dog'
        }
      },
      fr: {
        person: {
          many: 'gens',
          one: 'personne'
        }
      } 
    }
    @nouns = NHash
      .new( nouns )
      .with_indifferent_access
```

As nobody and person is exactly the same word in French, (why are you blaming me?), we will contsruct
fallbacks for none (contrieved, I know). As we also did not implement German yet and the French implementation is
incomplete, we want a fallback mechanisme working like this:

```ruby
    @nouns
      .push_fallback do
        with_prefix :en do
          again 
        end
      end
      .push_fallback do
        with_suffix :one do
          again
        end
      end
      .push_fallback do
        with_suffix :none do
          again
        end
      end
```

This is quite some code, difficult to read, but that comes from the general nature of the fallback
mechanism.

Here we want to fallback to the prefix `en`  and concerning the suffixes we want to fallback to
`none` and `one` in that order, which is not easy to see when reading the code.

It becomes clearer when applied, but yet...

```ruby

    def get_flection noun, unity: :one, lang: :en
      @nouns.with_affixes lang, unity do |n|
        n.get ".#{noun}."
      end
    end
    
```

Now the following assertions hold:

```ruby
    get_flection( :sheep, lang: :de, unity: :many )
      .assert == 'sheep'
```




#### The Affix Fallback Helpers

As fallbacks as implemented here are a little complex their true value comes from the helpers
we can (and have) implemented with them:
