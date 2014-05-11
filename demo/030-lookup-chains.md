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
        cat: { one: 'chat' }, # for demonstration purpose we ommit "chats"
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

However the suffix chain masks the prefix chain, thus we will not find any bovines here:

```ruby
    nh.with_prefix :fr do
      with_suffix :many do
        KeyError.assert.raised? do
          get( '.sheep.' )
        end
      end
    end
```


### Combining Chains

In order to make both work together we need to implement a backtracking mechanism (or a
carthesian product fallback definition). This is done via the `push_affix_lookup` method

First we reset both lookup chains, for the time being there is only one method that accomplishes
this:

```ruby
    nh.clear_fallbacks!
    nh.push_affix_lookup prefixes: %w{fr en}, suffixes: %w{many one}
```

Now our sleep endorsing animals are found again:

```ruby
    nh.with_prefix :fr do
      with_suffix :many do
        get( '.sheep.' ).assert == 'sheep'
      end
    end
```

This searches for an entry by varying the prefixes first, if you want to vary over the suffixes first
the named parameter `suffixes_first` can be set to true. Let us prove the difference by giving yet
another demo.

First we do not set `suffixes_first` and

```ruby
    nh.with_prefix :fr do
      with_suffix :many do
        get( '.cat.' ).assert == 'chat'
      end
    end
```

`'chat'` is found (sorry for the grammatical error).

Now if we inverse the lookup order

```ruby
    nh.clear_fallbacks!
    nh.push_affix_lookup prefixes: %w{fr en}, suffixes: %w{many one}, suffixes_first: true
```

and try again, we will get

```ruby
    nh.with_prefix :fr do
      with_suffix :many do
        get( '.cat.' ).assert == 'cats'
      end
    end
```


