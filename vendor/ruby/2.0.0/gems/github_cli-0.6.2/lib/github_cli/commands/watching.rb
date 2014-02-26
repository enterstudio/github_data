# encoding: utf-8

module GithubCLI
  class Commands::Watching < Command

    namespace :watch

    desc 'list <user> <repo>', 'Lists repo watchers'
    def list(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Watching.list user, repo, params, global_options
    end

    desc 'watched', 'Lists repos being watched by a user'
    method_option :user, :type => :string, :aliases => ["-u"],
                  :desc => 'Watch repositories for <user>'
    def watched
      global_options = options.dup
      params = options[:params].dup
      if options[:user]
        params['user'] = options[:user]
      end
      Util.hash_without!(global_options, params.keys + ['params'])
      Watching.watched params, global_options
    end

    desc 'watching <user> <repo>', 'Check if you are watching a repository'
    def watching(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Watching.watching? user, repo, params, global_options
    end

    desc 'start <user> <repo>', 'Watch a repository'
    def start(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Watching.start user, repo, params, global_options
    end

    desc 'stop <user> <repo>', 'Stop watching a repository'
    def stop(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Watching.stop user, repo, params, global_options
    end

  end # Watching
end # GithubCLI
