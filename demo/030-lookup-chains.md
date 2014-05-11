# Lab42::NHash QED

## Lookup Chains

These are convenience methods using the more general, but also much more comlicated
fallback mechanism that is demonstrated [here](https://github.com/RobertDober/lab42_nested_hash/blob/master/demo/060-fallback.md)

### Prefix Chains

This defines a mechanism that will use different prefixes until a prefixed key is found.

```ruby
    nh = NHash.new(
      en: { '1' => 'one', '2' => 'two', '3' => 'three' },
      fr: { '2' => 'deux', '3' => 'trois' },
      it: { '3' => 'tre' })
      .with_indifferent_access
```

Now we can simply define a prefix lookup chain as follows:

```ruby
    nh.push_prefix_lookup :it, :fr, :en
    nh.with_prefix :de do
      get( '.1' ).assert == 'one'
      get( '.2' ).assert == 'deux'
      get( '.3' ).assert == 'tre'
      KeyError.assert.raised? do
        get( '.4' )
      end
    end
```

### Suffix Chains

are not different of course.

```ruby
    nh = NHash.new(
      en: {
        dog: { one: 'dog', many: 'dogs' },
        cat: { one: 'cat', many: 'cats' },
        sheep: { one: 'sheep' }
      },
      fr: {
        dog: { one: 'chien', many: 'chiens' },
        money: { one: 'argent' }
      } ).with_indifferent_access
```

Now we define the suffix chain

```ruby
    nh.push_suffix_lookup :many, :one
```

proof that this works

```ruby
    nh.with_prefix :fr do
      with_suffix :many do
        get( '.money.').assert == 'argent'
      end
    end
```


