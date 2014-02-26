# encoding: utf-8

module GithubCLI
  class Commands::Repositories < Command

    namespace :repo

    option :org, :type => :string, :aliases => ["-o"], :banner => '<organization>',
           :desc => 'List repositories for <organization>'
    option :user, :type => :string, :aliases => ["-u"], :banner => '<user>',
           :desc => 'List repositories for <user>'
    option :every, :type => :boolean, :default => false,
           :desc => "This provides a dump of every repository, in the order that they were created."
    option :since, :type => :string, :banner => '<id>',
           :desc => "the integer ID of the last Repository that you've seen"
    option :type, :type => :string,
           :desc => "all, owner, public, private, member. Default: all."
    option :sort, :type => :string,
           :desc => "created, updated, pushed, full_name, default: full_name."
    option :direction, :type => :string,
           :desc => "asc or desc, default: when using full_name: asc, otherwise desc."
    desc 'list', 'Lists all repositories for the authenticated user'
    def list
      global_options = options.dup
      params = options[:params].dup
      params['org']   = options[:org]   if options[:org]
      params['user']  = options[:user]  if options[:user]
      params['since'] = options[:since] if options[:since]
      params['type']  = options[:type]  if options[:type]
      params['sort']  = options[:sort]  if options[:sort]
      params['direction'] = options[:direction] if options[:direction]
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.all params, global_options
    end

    desc 'get <user> <repo>', 'Get a repository'
    def get(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, %w[ params ])
      Repository.get user, repo, params, global_options
    end

    option :org, :type => :string, :aliases => ["-o"],
           :desc => 'Create repository in <organization>',
           :banner => '<organization>'
    option :desc, :type => :string, :banner => "description"
    option :home, :type => :string, :banner => "homepage"
    option :private, :type => :boolean, :default => false,
           :desc => "true to create a private repository, false to create a public one"
    option :issues, :type => :boolean, :banner => "has_issues", :default => true,
           :desc => "true to enable issues for this repository, false to disable them"
    option :wiki, :type => :boolean, :banner => "has_wiki", :default => true,
           :desc => "true to enable the wiki for this repository, false to disable it. Default is true"
    option :downloads, :type => :boolean, :banner => "has_downloads",
           :default => true,
           :desc => "true to enable downloads for this repository "
    option :team, :type => :numeric, :banner => "team <id>",
           :desc => "The id of the team that will be granted access to this repository. This is only valid when creating a repo in an organization"
    option :auto, :type => :string, :banner => "auto_init", :default => false,
           :desc => "true to create an initial commit with empty README. Default is false."
    option :gitignore, :type => :string, :banner => "gitignore_template",
           :desc => "Desired language or platform .gitignore template to apply."
    desc 'create [<org>/]<name>', 'Create a new repository <name> for the authenticated user.'
    long_desc <<-DESC
      Create a new repository for the autheticated user.

      Parameters

        description - Optional string \n
        homepage - Optional string \n
        private - Optional boolean - true to create a private repository, false to create a public one \n
        has_issues - Optional boolean - true to enable issues for this repository, false to disable them \n
        has_wiki - Optional boolean - true to enable the wiki for this repository, false to disable it. Default is true \n
        has_downloads Optional boolean - true to enable downloads for this repository \n
        org Optional string - The organisation in which this repository will be created \n
        team_id - Optional number - The id of the team that will be granted access to this repository. This is only valid when creating a repo in an organization \n
        auto_init - Optional boolean - true to create an initial commit with empty README. Default is false.
        gitignore_template - Optional string - Desired language or platform .gitignore template to apply. Use the name of the template without the extension. For example, “Haskell” Ignored if auto_init parameter is not provided.
    DESC
    def create(args)
      global_options = options.dup
      params = options[:params].dup
      org, params['name'] = Arguments.new(args).parse
      params['org']                = org if org
      params['org']                = options[:org]       if options[:org]
      params['description']        = options[:desc]      if options[:desc]
      params['homepage']           = options[:home]      if options[:home]
      params['private']            = options[:private]
      params['has_issues']         = options[:issues]
      params['has_wiki']           = options[:wiki]
      params['has_downloads']      = options[:downloads]
      params['team_id']            = options[:team]      if options[:team]
      params['auto_init']          = options[:auto]
      params['gitignore_template'] = options[:gitignore] if options[:gitignore]

      Util.hash_without!(global_options,
        params.keys + %w[ params issues wiki downloads team auto gitignore ])
      Repository.create params, global_options
    end

    option :desc, :type => :string, :banner => "description"
    option :home, :type => :string, :banner => "homepage"
    option :private, :type => :boolean, :default => false,
           :desc => "true to create a private repository, false to create a public one"
    option :issues, :type => :boolean, :banner => "has_issues", :default => true,
           :desc => "true to enable issues for this repository, false to disable them"
    option :wiki, :type => :boolean, :banner => "has_wiki", :default => true,
           :desc => "true to enable the wiki for this repository, false to disable it. Default is true"
    option :downloads, :type => :boolean, :banner => "has_downloads",
           :default => true,
           :desc => "true to enable downloads for this repository "
    option :branch, :type => :string, :banner => "default branch",
           :desc => "Update the default branch for this repository."
    desc 'edit <user> <repo> <name>', 'Edit <repo> with <name> for an <user>.'
    long_desc <<-DESC
      Create a new repository for the autheticated user.

      Parameters

        name - Required string \n
        description - Optional string \n
        homepage - Optional string \n
        private - Optional boolean - true to create a private repository, false to create a public one \n
        has_issues - Optional boolean - true to enable issues for this repository, false to disable them \n
        has_wiki - Optional boolean - true to enable the wiki for this repository, false to disable it. Default is true \n
        has_downloads - Optional boolean - true to enable downloads for this repository \n
        default_branch - Optional string - update the default branch for this repository \n
    DESC
    def edit(user, repo, name)
      global_options = options.dup
      params = options[:params].dup
      params['name'] = name
      params['description']    = options[:desc]      if options[:desc]
      params['homepage']       = options[:home]      if options[:home]
      params['private']        = options[:private]
      params['has_issues']     = options[:issues]
      params['has_wiki']       = options[:wiki]
      params['has_downloads']  = options[:downloads]
      params['default_branch'] = options[:branch]    if options[:branch]

      Util.hash_without!(global_options,
        params.keys + %w[ wiki issues downloads params] )
      Repository.edit user, repo, params, global_options
    end

    desc 'delete <user> <repo>', 'Delete a repository'
    def delete(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.delete user, repo, params, global_options
    end

    desc 'branches <user> <repo>', 'List branches'
    def branches(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.branches user, repo, params, global_options
    end

    desc 'branch <user> <repo> <name>', 'Get branch'
    def branch(user, repo, name)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.branch user, repo, name, params, global_options
    end

    desc 'contribs <user> <repo>', 'List contributors'
    def contribs(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.contributors user, repo, params, global_options
    end

    desc 'langs <user> <repo>', 'Listing all languages'
    def langs(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.languages user, repo, params, global_options
    end

    desc 'tags <user> <repo>', 'Listing all tags'
    def tags(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.tags user, repo, params, global_options
    end

    desc 'teams <user> <repo>', 'Listing all teams'
    def teams(user, repo)
      global_options = options.dup
      params = options[:params].dup
      Util.hash_without!(global_options, params.keys + ['params'])
      Repository.teams user, repo, params, global_options
    end

  end # Repositories
end # GithubCLI
