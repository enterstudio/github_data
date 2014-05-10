require 'rubygems'
require 'bundler/setup'
require 'bitbucket_rest_api'
require 'github_api'
require 'base64'

class Repository < Thor
  desc "ruby_rails_data", "Ruby/Rails version info on the provided user's Github repos"
  def ruby_rails_data
    @service = service_selection
    account = request_credentials
    repos = get_repos_metadata(account)
    repos.each { |repo| ruby_rails_versions(account, repo) }
  end

  private

    def service_selection
      say "\nWould you like repo info from..."
      choices = ["Github", "BitBucket"]
      choices_with_index = choices.map.with_index{ |a, i| [i+1, *a]}
      print_table choices_with_index
      choice = ask("Pick one:").to_i
      case choice
      when 1..choices.length
        @service = choices[choice - 1]
      else
        say "\nInvalid entry, try again"
        service_selection
      end
    end

    def request_credentials
      username = ask("#{@service} username:")
      password = ask("#{@service} password:", :echo => false)
      get_authentication_preference(username, password)
    end

    def get_authentication_preference(username, password)
      say "\nWould you like to use..."
      choices = ["Basic Authentication"]
      choices = choices.map.with_index{ |a, i| [i+1, *a]}
      print_table choices
      choice = ask("Pick one:").to_i
      case choice
      when 1
        basic_authentication(username, password)
      else
        say '\nInvalid entry, try again'
        get_authentication_preference(username, password)
      end
    end

    def basic_authentication(username, password)
      Kernel.const_get(@service).new(login: username, password: password, auto_pagination: true)
    end

    def get_repos_metadata(account)
      begin
        account.repos.all
      rescue Github::Error::Unauthorized
        say "\nAuthentication Failed."
        github_ruby_rails_data
      rescue BitBucket::Error::Unauthorized
        say "\nAuthentication Failed"
        bitbucket_ruby_rails_data
      end
    end

    def ruby_rails_versions(account, repo)
      gemfile = retrieve_gemfile(account, repo)
      if @service.eql?('Github')
        gemfile = process_gemfile(account, repo)
      end
      if rails_repository?(gemfile)
        rails_version = rails_version_from_gemfile(gemfile)
        ruby_version = ruby_version_from_version_files(account, repo)
        print_versions(repo, ruby_version, rails_version)
      end
    end

    def rails_repository?(gemfile)
      !gemfile.nil? && has_rails_gem?(gemfile)
    end

    def retrieve_gemfile(account, repo)
      begin
        if @service.eql?('Github')
          file = account.repos.contents.get(account.login, repo.name, 'Gemfile').content
        elsif @service.eql?('BitBucket')
          file = account.repos.sources.find(account.login, repo.name, 'master', 'Gemfile').data
        end
      rescue
        nil
      else
        file
      end
    end

    def process_gemfile(account, repo)
      gemfile.nil? ? nil : gemfile = Base64.decode64(gemfile)
    end

    def has_rails_gem?(file_contents)
      file_contents.match /gem\s('|")rails('|")/
    end

    def rails_version_from_gemfile(file_contents)
      rails_version_regex = /gem\s('|")rails('|"),(?<rails_version>\s('.*'|".*"))/
      match = file_contents.match rails_version_regex
      rails_version = match[:rails_version] || 'Error'
      remove_quotes(rails_version)
    end

    def ruby_version_from_version_files(account, repo)
      file_content = find_ruby_version_file(account, repo)
      if @service.eql?('Github')
        file_content = Base64.decode64(file_content)
      end
      file_content.nil? ? 'No ruby version file found' : file_content
    end

    def find_ruby_version_file(account, repo)
      rbenv_version_file(account, repo) ||
      ruby_version_file(account, repo) ||
      other_version_file(account, repo)
    end

    def rbenv_version_file(account, repo)
      begin
        if @service.eql?('Github')
          file = account.repos.contents.get(account.login, repo.name, '.rbenv-version').content
        elsif @service.eql?('BitBucket')
          file = account.repos.sources.find(account.login, repo.name, 'master', '.rbenv-version').data
        end
      rescue
        nil
      else
        file
      end
    end

    def ruby_version_file(account, repo)
      begin
        if @service.eql?('Github')
          file = account.repos.contents.get(account.login, repo.name, '.ruby-version').content
        elsif @service.eql?('BitBucket')
          file = account.repos.sources.find(account.login, repo.name, 'master', '.ruby-version').data
        end
      rescue
        nil
      else
        file
      end
    end

    def other_version_file(account, repo)
      begin
        if @service.eql?('Github')
          file = account.repos.contents.get(account.login, repo.name, 'VERSION').content
        elsif @service.eql?('BitBucket')
          file = account.repos.sources.find(account.login, repo.name, 'master', 'VERSION').data
        end
      rescue
        nil
      else
        file
      end
    end

    def remove_quotes(string)
      quoteless_string = string.gsub('"', '').gsub("'", "")
    end

    def print_versions(repo, ruby_version, rails_version)
      if @service.eql?('Github')
        say "\n#{repo.full_name}"
      elsif @service.eql?('BitBucket')
        say "\n#{repo.name}"
      end
      say "Ruby version: #{ruby_version}"
      say "Rails version: #{rails_version}\n"
    end
end
