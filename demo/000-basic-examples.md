
# Lab42::NHash QED 

## Basic Example Dotted Access


```ruby
    h = { "a" => 1,
          "b" => { "c" => 2, "d" => true } }

    nh = NHash.new h

```

Then `get` lets us access elements

```ruby
    nh.get('a').assert == 1
    nh.get('b.c').assert == 2
```

or _subhashes_:

```ruby
    nh.get('b').assert.kind_of? NHash
```

## Non existing keys

`get` raises a KeyError if there is no such key

```ruby
    KeyError.assert.raised? do
      nh.get 'c'
    end
```

