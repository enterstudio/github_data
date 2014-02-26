# encoding: utf-8

module GithubCLI
  class Content < API

    class << self

      def get(user, repo, path, params, options)
        output options do
          github_api(options).repos.contents.get user, repo, path, params
        end
      end

      def create(user, repo, path, params, options)
        output options do
          github_api(options).repos.contents.create user, repo, path, params
        end
      end

      def readme(user, repo, params, options)
        output options do
          github_api(options).repos.contents.readme user, repo, params
        end
      end

      def archive(user, repo, params, options)
        output options do
          github_api(options).repos.contents.archive user, repo, params
        end
      end
    end

  end # Content
end # GithubCLI
