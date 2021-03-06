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
    nh.get!(:result).assert == 'the sum is 42'
```

### Interpolation Context

As could be seen in the example above, the context in which the `<% ... %>` body is evaluated is that
of the `NHash` instance itself. However there is a possibility to provide any binding as a parameter

```ruby
    def get *args; 1 end
    nh.push_binding binding
    nh.get!(:sum).assert == '2'
```

Again this implements the _with_ pattern:

```ruby
    nh.pop_binding
    nh.get!(:sum).assert == '42'
    nh.with_binding binding do
      get!(:sum).assert == '2'
    end
    nh.get!(:sum).assert == '42'
```

But an even more concise form is availaible, a single method called `get_with_binding` 

```ruby
    nh.get_with_binding(:sum, binding).assert = '2'
    nh.get!(:sum).assert == '42'
```

### Block Form For Current Binding

In order to replace the frequent use case:

```ruby
    nh.get_with_binding :sum, binding
```

with a more concise form a method acceting a block parameter, from which it can
get the current binding can be used as follows:

```ruby
    nh.get_with_current{ :sum }.assert == '2'
```

