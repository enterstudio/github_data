# -*- encoding: utf-8 -*-

module TTY
  class Table
    class Border

      # A class that represents no border.
      class Null < Border

        def_border do
          center SPACE_CHAR
        end

        # A stub top line
        #
        # @api private
        def top_line
          border ? super : nil
        end

        # A stub separator line
        #
        # @api private
        def separator
          return [] if border.separator == EACH_ROW
          border ? super : nil
        end

        # A stub bottom line
        #
        # @api private
        def bottom_line
          border ? super : nil
        end

      end # Null
    end # Border
  end # Table
end # TTY
