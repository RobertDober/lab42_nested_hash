
# Lab42::NHash QED 

## Prefixed Access

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

Now `get` keys that start with a '.' are prefixed with a, let us demonstrate:

```ruby
    nh.get( '.b.c' ).assert == 'abc'
```

but not using the '.' as a prefix I can still access with an _absolute_ key path.

```ruby
    nh.get( 'a.b.c').assert == 'abc'
```

### Suffix and Combination of the two

```ruby
    nh.push_suffix 'c'
    nh.get( 'a.b.' ).assert == 'abc'
    nh.get( 'x.b.' ).assert == 'xbc'

    nh.get( '.b.' ).assert == 'abc'
    nh.get( 'x.b.'  ).assert == 'xbc'
```


### The Stack

As the name suggests we can push and pop suffices and prefices
This is convenient as often the suffix/Prefix correspond to
a given context in the program.

```ruby
    nh.push_prefix 'a.b'
    nh.get('.d').assert == 'abd'
    2.times{ nh.pop_prefix }
    NHash::IllegalStateError.assert.raised? do
      nh.get('.d').assert == 'abd'
    end
```

### Temporary Stack Modifiaction with the With Pattern

An often more convenient way to push values to the stacks is the `with` pattern that will
ensure that the stack is popped again at the end of the provided block.


```ruby
    nh.with_pefix 'a' do |x|
      # self is passed into the block for convenience
      x.assert == nh

      # fetch is an alias to get
      x.fetch( '.b.c' ).assert == 'abc'
    end
```

Outside the block the stack will have been restored

```ruby
    NHash::IllegalStateError.assert.raised? do
      nh.fetch '.b.c'
    end
```

