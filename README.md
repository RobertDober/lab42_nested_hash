# lab42_nested_hash

A nested hash view with dotted deep access à la I18n.t of Rails and with optional string interpolation. Typically YML loaded Hashes are used.


## Dotted Access

Please see the [QED](http://rubyworks.github.io/qed/) demos for detailed explainations:

```ruby
    h = { "a" => 1,
          "b" => { "c" => 2, "d" => true } }

    nh = NHash.new h

```

Then `get` lets us access elements

```ruby
    nh.get('a').assert == 1
    ng.get('b.c').assert == 2
```

or _subhashes_:

```ruby
    nh.get('b').assert.kind_of? NHash
```


## Indifferent Access

## Prefix and Suffix Stacks

## Fallbacks
