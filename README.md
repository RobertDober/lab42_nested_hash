# lab42_nested_hash

A nested hash view with dotted deep access à la I18n.t of Rails and with optional string interpolation. Typically YML loaded Hashes are used.


## Most Basic Example


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


Please see the [QED](http://rubyworks.github.io/qed/) demos [here](https://github.com/RobertDober/lab42_nested_hash/blob/master/demo) for detailed explainations and specifications of the implemented features:


### Indifferent Access

Symbol and String Keys are treated the same.

### Affixes

Prefixes and Suffixes can be predefined and used when a compound key starts and/or ends with a `.`.

### Lookup Chains

Taking advantage of the Affixes features an affixed access can look in more than one affix. E.g. to fall back
to English as the default translation language.

### Fallbacks

A more general concept of what to do if an access fails (raises a `KeyError`).

### Interpolation

If values have `ERB` syntax templates as values, the special `get!` access can be used to interpolate them
in various contexts, the `NHash` instance's binding being the default.

### Compound Values

Subhashes and subarrays maintain important context information, e.g. for _Interpolation_.

### Hierarchies

If all else fails... 
We can check in other `NHash` instances. They are organised as a _Depth First Search Tree_.

This feature is particularly interesting for complex document composition out of a hierarchical data
source tree (e.g. a set of yaml files, different for each new version/variation of the result).
