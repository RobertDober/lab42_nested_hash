
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


