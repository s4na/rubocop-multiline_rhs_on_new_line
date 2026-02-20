require "spec_helper"

RSpec.describe RuboCop::Cop::Layout::MultilineRhsOnNewLine, :config do
  # 1. multiline if/else on the same line as `=` -> offense
  it "registers an offense when multiline if/else is on the same line as =" do
    expect_offense(<<~RUBY)
      hoge = if aaa
           ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               bbb
             else
               ccc
             end
    RUBY

    # `if` was at column 7, target is column 2 (col_delta = -5)
    expect_correction(<<~RUBY)
      hoge =
        if aaa
          bbb
        else
          ccc
        end
    RUBY
  end

  # 2. multiline unless on the same line as `=` -> offense
  it "registers an offense when multiline unless is on the same line as =" do
    expect_offense(<<~RUBY)
      foo = unless condition
          ^ Put the right-hand side of a multiline assignment on a new line after `=`.
              true_val
            else
              false_val
            end
    RUBY

    # `unless` was at column 6, target is column 2 (col_delta = -4)
    expect_correction(<<~RUBY)
      foo =
        unless condition
          true_val
        else
          false_val
        end
    RUBY
  end

  # 3. multiline case/when on the same line as `=` -> offense
  it "registers an offense when multiline case is on the same line as =" do
    expect_offense(<<~RUBY)
      result = case foo
             ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               when :a then 1
               when :b then 2
               end
    RUBY

    # `case` was at column 9, target is column 2 (col_delta = -7)
    expect_correction(<<~RUBY)
      result =
        case foo
        when :a then 1
        when :b then 2
        end
    RUBY
  end

  # 4. multiline begin/end on the same line as `=` -> offense
  it "registers an offense when multiline begin/end is on the same line as =" do
    expect_offense(<<~RUBY)
      val = begin
          ^ Put the right-hand side of a multiline assignment on a new line after `=`.
              something
              something_else
            end
    RUBY

    # `begin` was at column 6, target is column 2 (col_delta = -4)
    expect_correction(<<~RUBY)
      val =
        begin
          something
          something_else
        end
    RUBY
  end

  # 5. multiline begin/rescue (kwbegin) on the same line as `=` -> offense
  it "registers an offense when multiline begin/rescue (kwbegin) is on the same line as =" do
    expect_offense(<<~RUBY)
      x = begin
        ^ Put the right-hand side of a multiline assignment on a new line after `=`.
            something
          rescue StandardError
            other
          end
    RUBY

    # `begin` was at column 4, target is column 2 (col_delta = -2)
    expect_correction(<<~RUBY)
      x =
        begin
          something
        rescue StandardError
          other
        end
    RUBY
  end

  # 6. ivasgn (@foo =) with multiline RHS -> offense + correction
  it "registers an offense for ivasgn with multiline RHS" do
    expect_offense(<<~RUBY)
      @foo = if condition
           ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               true_val
             else
               false_val
             end
    RUBY

    # `if` was at column 7, target is column 2 (col_delta = -5)
    expect_correction(<<~RUBY)
      @foo =
        if condition
          true_val
        else
          false_val
        end
    RUBY
  end

  # 7. single-line ternary -> no offense
  it "does not register an offense for a single-line ternary" do
    expect_no_offenses(<<~RUBY)
      hoge = foo ? bar : baz
    RUBY
  end

  # 8. simple single-line assignment -> no offense
  it "does not register an offense for a simple single-line assignment" do
    expect_no_offenses(<<~RUBY)
      hoge = aaa
    RUBY
  end

  # 9. RHS already on the next line after `=` -> no offense
  it "does not register an offense when RHS starts on the next line" do
    expect_no_offenses(<<~RUBY)
      hoge =
        if aaa
          bbb
        else
          ccc
        end
    RUBY
  end

  # 10. multiline array literal -> no offense
  it "does not register an offense for a multiline array literal" do
    expect_no_offenses(<<~RUBY)
      foo = [
        1, 2, 3
      ]
    RUBY
  end

  # 11. multiline hash literal -> no offense
  it "does not register an offense for a multiline hash literal" do
    expect_no_offenses(<<~RUBY)
      config = {
        key: "value"
      }
    RUBY
  end

  # 12. multiline string literal -> no offense
  it "does not register an offense for a multiline string literal" do
    expect_no_offenses(<<~RUBY)
      message = "hello
      world"
    RUBY
  end

  # Extra: cvasgn
  it "registers an offense for cvasgn with multiline RHS" do
    expect_offense(<<~RUBY)
      @@foo = if condition
            ^ Put the right-hand side of a multiline assignment on a new line after `=`.
                true_val
              else
                false_val
              end
    RUBY

    # `if` was at column 8, target is column 2 (col_delta = -6)
    expect_correction(<<~RUBY)
      @@foo =
        if condition
          true_val
        else
          false_val
        end
    RUBY
  end

  # Extra: gvasgn
  it "registers an offense for gvasgn with multiline RHS" do
    expect_offense(<<~RUBY)
      $foo = if condition
           ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               true_val
             else
               false_val
             end
    RUBY

    # `if` was at column 7, target is column 2 (col_delta = -5)
    expect_correction(<<~RUBY)
      $foo =
        if condition
          true_val
        else
          false_val
        end
    RUBY
  end

  # Extra: nested context (already-indented assignment inside a method)
  it "registers an offense and corrects inside a method body" do
    expect_offense(<<~RUBY)
      def some_method
        result = if condition
               ^ Put the right-hand side of a multiline assignment on a new line after `=`.
                   true_val
                 else
                   false_val
                 end
      end
    RUBY

    # `result` at column 2, target_col = 4; `if` at column 11 (col_delta = -7)
    expect_correction(<<~RUBY)
      def some_method
        result =
          if condition
            true_val
          else
            false_val
          end
      end
    RUBY
  end
end
