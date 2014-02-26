# -*- encoding: utf-8 -*-

module TTY
  class Terminal

    # A class responsible for locating user home
    class Home

      # Find user home
      #
      # @api public
      def home
        if (env_home = ENV['HOME'])
          env_home
        else
          begin
            require 'etc'
            File.expand_path("~#{Etc.getlogin}")
          rescue
            if TTY::System.windows?
              "C:/"
            else
              "/"
            end
          end
        end
      end

    end #Home
  end # Terminal
end # TTY
