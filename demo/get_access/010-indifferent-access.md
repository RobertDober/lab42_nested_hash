
# Lab42::NHash QED 

## Indifferent Access


```ruby
    h = { "a" => 1,
          b: { "c" => 2, d: true } }

    nh = NHash.new h

```

is not available by default

```ruby
    KeyError.assert.raised? do
      nh.get 'b.c'
    end
```

but it can be enabled

```ruby
    nia = nh.with_indifferent_access
    nia.get( 'b.c' ).assert == 2
```

without affecting the original object

```ruby
    KeyError.assert.raised? do
      nh.get 'b.c'
    end
```

and of course KeyErrors are still raised in case

```ruby
    KeyError.assert.raised? do
      nia.get 'a.b'
    end
    KeyError.assert.raised? do
      nh.get 'a.b'
    end
```

