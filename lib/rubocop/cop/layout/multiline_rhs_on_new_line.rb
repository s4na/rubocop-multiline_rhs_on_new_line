module RuboCop
  module Cop
    module Layout
      # Enforces that the right-hand side of an assignment starts on a new line
      # when it spans multiple lines.
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
      class MultilineRhsOnNewLine < Base
        extend AutoCorrector

        MSG = "Put the right-hand side of a multiline assignment on a new line after `=`."

        ASSIGNMENT_NODE_TYPES = %i[lvasgn ivasgn cvasgn gvasgn].freeze

        def on_lvasgn(node)
          check(node)
        end

        def on_ivasgn(node)
          check(node)
        end

        def on_cvasgn(node)
          check(node)
        end

        def on_gvasgn(node)
          check(node)
        end

        private

        def check(node)
          rhs = node.children.last
          return if rhs.nil?

          rhs_begin_line = rhs.loc.expression.line
          rhs_end_line = rhs.loc.expression.last_line

          return unless rhs_begin_line < rhs_end_line

          asgn_line = node.loc.operator.line
          return unless rhs_begin_line == asgn_line

          add_offense(node.loc.operator) do |corrector|
            autocorrect(corrector, node)
          end
        end

        def autocorrect(corrector, node)
          operator = node.loc.operator
          rhs = node.children.last

          # Range from just after `=` to the start of the rhs expression
          range_after_op = operator.end.join(rhs.loc.expression.begin)

          # Determine indentation: column of the assignment node
          asgn_col = node.loc.expression.column
          new_indent = " " * (asgn_col + 2)

          corrector.replace(range_after_op, "\n#{new_indent}")
        end
      end
    end
  end
end
