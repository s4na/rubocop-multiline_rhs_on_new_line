require "spec_helper"

RSpec.describe RuboCop::Cop::Layout::MultilineRhsOnNewLine, :config do
  # 1. if/else/end が複数行で = と同じ行 → offense
  it "registers an offense when multiline if/else is on the same line as =" do
    expect_offense(<<~RUBY)
      hoge = if aaa
           ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               bbb
             else
               ccc
             end
    RUBY

    expect_correction(<<~RUBY)
      hoge =
        if aaa
               bbb
             else
               ccc
             end
    RUBY
  end

  # 2. case/when/end が複数行で = と同じ行 → offense
  it "registers an offense when multiline case is on the same line as =" do
    expect_offense(<<~RUBY)
      result = case foo
             ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               when :a then 1
               when :b then 2
               end
    RUBY

    expect_correction(<<~RUBY)
      result =
        case foo
               when :a then 1
               when :b then 2
               end
    RUBY
  end

  # 3. begin/end が複数行で = と同じ行 → offense
  it "registers an offense when multiline begin/end is on the same line as =" do
    expect_offense(<<~RUBY)
      val = begin
          ^ Put the right-hand side of a multiline assignment on a new line after `=`.
              something
              something_else
            end
    RUBY

    expect_correction(<<~RUBY)
      val =
        begin
              something
              something_else
            end
    RUBY
  end

  # 4. ivasgn（@foo =）で複数行 → offense
  it "registers an offense for ivasgn with multiline RHS" do
    expect_offense(<<~RUBY)
      @foo = if condition
           ^ Put the right-hand side of a multiline assignment on a new line after `=`.
               true_val
             else
               false_val
             end
    RUBY
  end

  # 5. 三項演算子（1行）→ no offense
  it "does not register an offense for a single-line ternary" do
    expect_no_offenses(<<~RUBY)
      hoge = foo ? bar : baz
    RUBY
  end

  # 6. 通常の1行代入 → no offense
  it "does not register an offense for a simple single-line assignment" do
    expect_no_offenses(<<~RUBY)
      hoge = aaa
    RUBY
  end

  # 7. = の後で改行済み → no offense
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
  end
end
