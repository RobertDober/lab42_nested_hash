
# Lab42::NHash QED 

## Fallbacks


### Base Case

In case a fallback is defined, it is triggerd whenever a `get/fetch` access would raise a `KeyError`.

When defining a fallback this is done via a callback block.

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
Of course the `with_*` pattern is implemented too:

```ruby
    nh.with_fallback ->{ 42 } do
      nh.get( 'c' ).assert == 42
    end
    
    KeyError.assert.raised? do
      nh.get 'c'
    end
```

### Full Fallback API

This base case is very close to using a `Hash` with a default but the `NHash` instance, which is also
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
fails too!

```ruby
    # And *not* StackOverflow
    KeyError.assert.raised? do
      nh.get( '3.' )
    end
```


