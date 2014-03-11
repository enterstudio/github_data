require 'github_api'
require 'pry'
require 'base64'

class Repository < Thor
  desc "ruby_rails_data", "Ruby/Rails version info on the provided user's Github repos"

  def ruby_rails_data(username, password)
    puts "I'm info on #{username}'s' Github repositories"
    account = login(username, password)
    repos = get_repos_metadata(account)
    repos.each { |repo| ruby_rails_versions(account, repo) }
  end

  private
    def login(username, password)
      Github.new(login: username, password: password, auto_pagination: true)
    end

    def get_repos_metadata(account)
      account.repos.all
    end

    def ruby_rails_versions(account, repo)
      gemfile = process_gemfile(account, repo)

      if !gemfile.nil? && has_rails?(gemfile)
        rails_version = rails_version_from_gemfile(gemfile)
        ruby_version = ruby_version_from_version_files(account, repo)
        print_versions(repo.name, ruby_version, rails_version)
      end
    end

    def retrieve_gemfile(account, repo)
      begin
        file = account.repos.contents.get(account.login, repo.name, 'Gemfile')
      rescue
        nil
      else
        file.content
      end
    end

    def process_gemfile(account, repo)
      gemfile = retrieve_gemfile(account, repo)
      gemfile.nil? ? nil : gemfile = Base64.decode64(gemfile)
    end

    def has_rails?(file_contents)
      file_contents.include?('gem "rails"') || file_contents.include?("gem 'rails'")
    end

    def rails_version_from_gemfile(file_contents)
      rails_version_regex = /gem\s('|")rails('|"),(?<rails_version>\s('.*'|".*"))/
      match = file_contents.match rails_version_regex
      rails_version = match[:rails_version] || 'Error'
      remove_quotes(rails_version)
    end

    def ruby_version_from_version_files(account, repo)
      #refactor
      file_content = rbenv_version_file(account, repo) ||
                     ruby_version_file(account, repo) ||
                     other_version_file(account, repo)
      file_content.nil? ? 'No ruby version file found' : Base64.decode64(file_content)
    end

    def rbenv_version_file(account, repo)
      begin
        file = account.repos.contents.get(account.login, repo.name, '.rbenv-version')
      rescue
        nil
      else
        file.content
      end
    end

    def ruby_version_file(account, repo)
      begin
        file = account.repos.contents.get(account.login, repo.name, '.ruby-version')
      rescue
        nil
      else
        file.content
      end
    end

    def other_version_file(account, repo)
      begin
        file = account.repos.contents.get(account.login, repo.name, 'VERSION')
      rescue
        nil
      else
        file.content
      end
    end

    def remove_quotes(string)
      quoteless_string = string.gsub('"', '').gsub("'", "")
    end

    def print_versions(name, ruby_version, rails_version)
      say "\n#{name}"
      say "Ruby version: #{ruby_version}"
      say "Rails version: #{rails_version}\n"
    end
end
