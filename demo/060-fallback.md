
# Lab42::NHash QED

## Fallbacks

Fallbacks are registred procedures, on a stack, that are executed in LIFO order.
They are triggered whenever a `get/fetch` invocation would trigger a `KeyError`.

The special `again` method is available inside the fallback procedure (and inside *only*)
to reexecute the `get/fetch` invocation that triggered the callback (it might trigger the next fallback
if applicable)

A simple example would be to define a fallback that searches with a different affix.

```ruby
    numbers = NHash.new( 
      en: { '1' => 'one', '2' => 'two', '3' => 'three' },
      fr: { '1' => 'un',  '2' => 'deux' },
      it: { '1' => 'uno' } )
      .with_indifferent_access
```

It stands to reason that looking for an italian '2' will get us a `KeyError` raised.

```ruby
    KeyError.assert.raised? do
      numbers.with_prefix :it do
        get '.2'
      end
    end
```

We will use _fallbacks_ to implement a lookup strategy. By using `push_fallback` 
we will have to define them in the reverse execution order, we could also use `unshift_fallback` 
if that suits your style better.

```ruby
    # use English as last resort...
    numbers.push_fallback do |n|
      n.with_prefix :en do 
        again
      end
    end
    # But try French first
    numbers.push_fallback do
      with_prefix( :fr ){ again }
    end
```

Please note the two possible styles, a block with arity one ( or negative arity ) will be called
with the `NHash` instance as a parameter, all other blocks will be instance_execed with the same
instance as receiver.

These fallbacks will cause the following assertions to hold

```ruby
    numbers.get( '.1' ).assert == 'un'
    numbers.with_prefix :it do
      get( '.1' ).assert == 'uno'
      get( '.2' ).assert == 'deux'
      get( '.3' ).assert == 'three'
    end
```

### With Pattern

Now if we can limit the validity of a defined fallback stack to a certain scope, we can use
`with_fallbacks`  so that we do not need to call  `clear_fallbacks!` explicitely.


```ruby
    numbers.clear_fallbacks!
    KeyError.assert.raised? do
      numbers.get('.1')
    end

    numbers.with_fallback do
      push_fallback do
        with_prefix( :fr ){ again }
      end
      with_prefix :it do
        get( '.2' ).assert == 'deux'
      end
    end
    KeyError.assert.raised? do
      numbers.get('.1')
    end
```

