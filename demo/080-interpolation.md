# Lab42::NHash QED 

## Interpolation

In order to be able to use string interpolation we can use the alternative
`get!/fetch!` methods which will expand [ERB](http://www.ruby-doc.org/stdlib-2.1.1/libdoc/erb/rdoc/ERB.html) templates inside
string values.


Here is a short demonstration of that feature:

```ruby
    nh = NHash.new( 
      sum: '<%= get("a")+get("b") %>',
      a: 41,
      b: 1,
      result: 'the sum is <%= get! :sum %>'
    )
      .with_indifferent_access
```

`get/fetch` do not do anything 

```ruby
    nh.get(:result).assert == 'the sum is <%= get! :sum %>'
```

However `get!/fetch!` are made from a completely different kind.

```ruby
    nh.get!(:sum).assert == '42'
    nh.fetch!(:result).assert == 'the sum is 42'
```




