
# Lab42::NHash QED 

## Hierarchies

At first sight these might be easily confused with _Lookup Chains_. However the difference is easy to explain:

While a _lookup_ (or a _fallback_ for that matter) *always* operates on the same NHash hierarchie, meaning
that we will never find anything outside our underling hash, or that of our parent in case of intepolation,
the hierarchies define a lookup chain at an outer level.

They allow us to define different datasets to be searched for the same key combinations. And they operate only
if a key combination was not found.

The concept is very easy to understand when demonstrated on an example, so what are we waiting for?

```ruby
    nh1 = NHash.new(
      en: { '1' => :one, '2' => :two },
      fr: {  '2' => :deux })
      .with_indifferent_access
    
```

Let us at first demonstrate the lookup chain for a reminder.

```ruby
    nh1.push_prefix_lookup :fr, :en
    nh1.with_prefix :de do
      nh1.get( '.1' ).assert == :one
    end 
```

And now we add another `NHash` instance as a hierarchy:

```ruby
    nh1.add_hierarchy NHash.new(
      de: { '0' => :null },
      fr: { '1' => :un })
      .with_indifferent_access
```

First of all let us demonstrate that the lookup chain takes precedence over the hierarchy search

```ruby
    nh1.get( 'fr.1' ).assert == :one
```

However, if everything fails, we are looking into our hierarchies in FIFO order this time:

```ruby
   nh1.get( 'de.0' ).assert == :null
```


