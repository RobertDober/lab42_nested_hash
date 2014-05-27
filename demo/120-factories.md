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


