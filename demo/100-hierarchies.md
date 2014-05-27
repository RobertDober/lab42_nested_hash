
# Lab42::NHash QED

## Hierarchies

Hierarchies are chains of `NHash` instances that are *looked_up* if a `get` fails.

As each instance can have mant hierarchies they hierarchy lookup consists of a Depth First Tree Search.

Here is an example:

```ruby
    root = NHash.new( a: 1 ).with_indifferent_access
     one = NHash.new( b: 2 ).with_indifferent_access
     two = NHash.new( b: :never_found )
      .with_indifferent_access
      .add_hierarchy( 'c' => 3 )
    three = NHash.new( c: :never_found )

    root.add_hierarchies one, two, three
```

This constructed a tree like the following (denoting `:never_found` by a `*`)


```
#                             +------+
#                             | a: 1 |
#                             +------+
#                               /|\
#                              / | \
#              +--------------.  |  .--------------+
#              |                 |                 |
#         +---------+       +---------+       +---------+
#         | b:  2   +       +   b: *  +       +   c: *  +
#         +---------+       +---------+       +---------+
#                                |
#                                |
#                           +---------+
#                           +   c: 3  +
#                           +---------+
```

Therefore the following assertions hold:

```ruby
    root.get( :a ).assert == 1
    root.get( :b ).assert == 2
    root.get( :c ).assert == 3
    KeyError.assert.raised? do
      root.get :d
    end
```


### Hierarchies and Lookup Chains

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
    nh1.with_prefix :fr do
      get( '.1' ).assert == :one
    end
```

However, this does not hold if we do not use prefixes and the hierarchy lookup will kick in instead:

```ruby
    nh1.get( 'fr.1' ).assert == :un
```


The same holds if prefix lookup fails, as in these cases:

```ruby
   nh1.get( 'de.0' ).assert == :null

```

If, however a hiearchy is used for a lookup, it does not inherite the other lookup strategies
from its root, e.g. affix chains or fallbacks.

```ruby
  KeyError.assert.raised? do
     nh1.with_prefix :de do
       get( '.0' ).assert == :null
     end
  end
```


### Interpolation Context
