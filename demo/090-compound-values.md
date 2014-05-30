
# Lab42::NHash QED 

## Compound Values

All Scalar values will be left untouched, however, as shown earlier, subhashes are transformed into
`NHash` instances and instances of `Enumerable` will get an `NHash::Enum` wrapper, that allows to
maintain necessary context information.

This demonstration will, well, demonstrate how that works and what we get from this additional layer
of complexity:

### A case of enumertion


```ruby
    nh = NHash.new(
      a: 42,
      entries: [
        { value: '<%= get :a %>' },
        '<%= get( :a ) * 2 %>',
        21
      ])
      .with_indifferent_access

```

First thing to show is that indeed we get the `NHash::Enum` instance

```ruby
    entries = nh.get :entries
    entries.assert.instance_of?( NHash::Enum )
```

And that we can use the result within the context of the original
`NHash` instance, e.g. with indifferent access in our case:

```ruby
    entries[0].get('value').assert == '<%= get :a %>'
```

And that we can also use interpolation:

```ruby
 #   entries[0].get!(:value).assert == '42'
```

### Enhanced Search

`NHash::Enum` of course implements `Enumerable`. However, when looking for keys we need to rescue from `KeyError` very frequently.

Here is a demonstration of that.

```ruby
    nh = NHash.new(
          entries: [
            {a: 1},
            {b: 2}
          ])
          .with_indifferent_access
    entries = nh.get :entries
```

In order to find `b` the quite obvious code is

```ruby
    entries.find{ |entry|
      begin
        entry.get(:b)
      rescue KeyError
      end
    }.get(:b).assert == 2
```

Now that code is not very readable, is it? Being cluttered by the rescue block and needing to invoke the get again?

Here is how we would like to write (and read) that kind of code:

```ruby
    entries.get{ |entry|
      entry.get :b
    }.assert == 2
```

This can even be shortened to

```ruby
    entries.get{ 2 * get(:b) }
      .assert == 4
```

or

```ruby
    entries.get(:b).assert == 2
```







