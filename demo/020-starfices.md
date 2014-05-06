
# Lab42::NHash QED 

## Pre/Suffixed Access

YAML documents are typically quite nested and often
a common prefix (and less often a common suffix) is
used in a given context.

```ruby
    h = { "a" => { 
            "b" => 
              { "c" => 'abc',
                "d" => 'abd' } },
          "x" => {
            "b" =>
              { "c" => 'xbc' } } }

    nh = NHash.new h
    nh.push_prefix 'a'

```

Now **all** `get` keys are prefixed with a, let us demonstrate:

```ruby
    nh.get( 'b.c' ).assert == 'abc'
```

and of course this means that I cannot reprovide the prefix

```ruby
    nh.get( 'a', :default ).assert == :default
```

However it might be convinient to override this behavior on
a per request base, that is what `get!` is for:

```ruby
    nh.get!( 'a' ).assert.kind_of? NHash
```

### The Stack

As the name suggests we can push and pop suffices and prefices
This is convenient as often the suffix/Prefix correspond to
a given context in the program.

```ruby
    nh.push_prefix 'a.b'
    nh.get('d').assert == 'abd'
    2.times{ nh.pop_prefix }
    nh.get('a.b.d').assert == 'abd'
```




