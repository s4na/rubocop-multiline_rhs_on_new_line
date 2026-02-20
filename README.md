# rubocop-multiline_rhs_on_new_line

A [RuboCop](https://github.com/rubocop/rubocop) extension that enforces the
right-hand side of an assignment to start on a new line when it spans multiple
lines.

## Installation

Add this line to your application's `Gemfile` or `.gemspec`:

```ruby
gem "rubocop-multiline_rhs_on_new_line", require: false
```

Or install it yourself:

```sh
gem install rubocop-multiline_rhs_on_new_line
```

## Usage

Add to your `.rubocop.yml`:

```yaml
require:
  - rubocop-multiline_rhs_on_new_line
```

## Cop: `Layout/MultilineRhsOnNewLine`

When the right-hand side of an assignment spans multiple lines, it must begin
on a new line after `=`.

### Bad

```ruby
hoge = if aaa
           bbb
         else
           ccc
         end

result = case foo
         when :a then 1
         when :b then 2
         end

val = begin
        something
        something_else
      end
```

### Good

```ruby
hoge =
  if aaa
    bbb
  else
    ccc
  end

result =
  case foo
  when :a then 1
  when :b then 2
  end

# Single-line RHS is always fine
hoge = aaa
hoge = foo ? bar : baz
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
