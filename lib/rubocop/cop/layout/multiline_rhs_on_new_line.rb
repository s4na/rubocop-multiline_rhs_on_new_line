module RuboCop
  module Cop
    module Layout
      # Enforces that the right-hand side of an assignment starts on a new line
      # when it spans multiple lines.
      #
      # Only block-like expressions (`if`, `unless`, `case`, `begin`, `kwbegin`)
      # are flagged. Array, hash, string literals, and method chains are
      # intentionally excluded because they are idiomatic Ruby and do not
      # benefit from being moved to a new line.
      #
      # Note: `casgn` (constant assignment) and `masgn` (multiple assignment)
      # are intentionally out of scope for this cop.
      #
      # Autocorrect computes indentation in visual columns, expanding tabs to
      # spaces using `Layout/IndentationWidth` as the tab stop size (default: 2).
      # Any leading tabs in affected lines are replaced with spaces after
      # correction.
      #
      # @example
      #   # bad
      #   hoge = if aaa
      #              bbb
      #            else
      #              ccc
      #            end
      #
      #   # bad
      #   result = case foo
      #            when :a then 1
      #            when :b then 2
      #            end
      #
      #   # good
      #   hoge =
      #     if aaa
      #       bbb
      #     else
      #       ccc
      #     end
      #
      #   # good (single-line RHS is fine)
      #   hoge = aaa
      #   hoge = foo ? bar : baz
      #
      #   # good (arrays and hashes are idiomatic inline)
      #   foo = [
      #     1, 2, 3
      #   ]
      #
      #   config = {
      #     key: "value"
      #   }
      #
      class MultilineRhsOnNewLine < Base
        extend AutoCorrector

        MSG = "Put the right-hand side of a multiline assignment on a new line after `=`.".freeze

        # Node types that represent block-like structures where requiring a
        # newline before the RHS improves readability.
        MULTILINE_BLOCK_TYPES = %i[if unless case begin kwbegin].freeze

        def on_lvasgn(node)
          check(node)
        end

        alias on_ivasgn on_lvasgn
        alias on_cvasgn on_lvasgn
        alias on_gvasgn on_lvasgn

        private

        def check(node)
          return unless offense?(node)

          add_offense(node.loc.operator) do |corrector|
            autocorrect(corrector, node)
          end
        end

        def offense?(node)
          rhs = node.children.last
          return false if rhs.nil?
          return false unless MULTILINE_BLOCK_TYPES.include?(rhs.type)

          rhs_loc = rhs.loc.expression
          return false unless rhs_loc

          rhs_loc.line < rhs_loc.last_line && rhs_loc.line == node.loc.operator.line
        end

        def autocorrect(corrector, node)
          rhs_loc = node.children.last.loc.expression
          target_col = target_column(node)
          col_delta = target_col - visual_col_of_loc(rhs_loc)
          insert_newline(corrector, node.loc.operator, rhs_loc, target_col)
          reindent_body(corrector, rhs_loc, col_delta)
        end

        def target_column(node)
          visual_col_of_loc(node.loc.expression) + indent_width
        end

        def visual_col_of_loc(loc)
          visual_column_at(loc.source_buffer.source_line(loc.line), loc.column)
        end

        def insert_newline(corrector, operator, rhs_loc, target_col)
          range_after_op = operator.end.join(rhs_loc.begin)
          corrector.replace(range_after_op, "\n#{' ' * target_col}")
        end

        def reindent_body(corrector, rhs_loc, col_delta)
          buffer = rhs_loc.source_buffer
          ((rhs_loc.line + 1)..rhs_loc.last_line).each do |lineno|
            reindent_line(corrector, buffer, lineno, col_delta)
          end
        end

        # Replaces the leading whitespace on lineno with spaces, shifting the
        # visual indentation by col_delta. Tabs are expanded using indent_width
        # as the tab stop size before computing the new width.
        def reindent_line(corrector, buffer, lineno, col_delta)
          line_source = buffer.source_line(lineno)
          old_visual = visual_width_of_leading(line_source)
          new_visual = [old_visual + col_delta, 0].max
          char_leading = line_source[/\A[ \t]*/].length
          corrector.replace(buffer.line_range(lineno).resize(char_leading), " " * new_visual)
        end

        # Returns the visual column of char_pos in line, expanding tabs using
        # indent_width as the tab stop size.
        def visual_column_at(line, char_pos)
          tw = indent_width
          col = 0
          line[0, char_pos].each_char do |c|
            col = c == "\t" ? ((col / tw) + 1) * tw : col + 1
          end
          col
        end

        # Returns the visual width of the leading whitespace in line, expanding
        # tabs using indent_width as the tab stop size.
        def visual_width_of_leading(line)
          tw = indent_width
          col = 0
          line.each_char do |c|
            break unless [" ", "\t"].include?(c)

            col = c == "\t" ? ((col / tw) + 1) * tw : col + 1
          end
          col
        end

        def indent_width
          config.for_cop("Layout/IndentationWidth")["Width"] || 2
        end
      end
    end
  end
end
