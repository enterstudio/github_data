# -*- encoding: utf-8 -*-

module TTY
  class Table
    class Renderer
      class ASCII < Basic

        def initialize(table, options={})
          super(table, options.merge(:border_class => TTY::Table::Border::ASCII))
        end

      end # ASCII
    end # Renderer
  end # Table
end # TTY
