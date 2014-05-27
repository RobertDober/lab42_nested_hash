# Lab42::NHash QED

## Factories

The purpose of factories is to bring in common data sources to create a, potentially hierarchic, `NHash` instance.

Let us see what the generic factory method `from_sources` does with `Hash` or `NHash` instances first.

### Creating Hierarchies from Hash alikes

```ruby
  nh = NHash.new( 'a' => 1, b: 1 )
  h  = { 'a' => 2, 'b' => 2 }

  hier = NHash.from_sources nh, h
    
```

The hierarchy's root node is on the left, and all hierarchies created by `from_sources` are lists, not trees.

Demonstration:

```ruby
    hier.get( 'a' ).assert == 1
    hier.get( 'b' ).assert == 2
```


Maybe you noticed that symbolic keys were not found. That is beacause, this time, we did not specify `with_indifferent_access` 

This can be done too, of course (note again that all keys are transformed to strings as usual:

```ruby
    hier = NHash.from_sources_with_indifferent_access nh, h
    hier.get( :a ).assert == 1
    hier.get( :b ).assert == 1
```


### Creating Hierarchies from YAML Files

The same works if the data is inside a Yaml file

```ruby
    given_a_file named: "one.yml", with: <<-EOF
      a: 1
    EOF
    and_given_a_file named: "two.yml", with: <<-EOF
      a: 2
      b: 2
    EOF
```

Now if we invoke `from_sources` with strings, denoting these files, these strings will be replaced by an `NHash` instance
initialized with the `Hash` resulting from YAML loading the content of the file
Now if we invoke icodefrom_sourceswith strings, denoting these files, these strings will be replaced by an icodeNHashinstance
initialized with the icodeHashresulting from YAML loading the content of the file

Or in short ;) :

```ruby
    yaml_hierarchy = NHash.from_sources 'one.yml', 'two.yml'

    yaml_hierarchy.get( :a ).assert == 1
    yaml_hierarchy.get( :b ).assert == 2
    KeyError.assert.raised? do
      yaml_hierarchy.get :c
    end
```

