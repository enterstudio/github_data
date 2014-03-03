# GithubData

Thor command line app for obtaining information on your repositories from the Github API.
    Presently only support the listing of Rails/Ruby version numbers from your Rails repositories.

h3: Installation

On your development machine, run the following:

    @git clone git@github.com:planetargon/github_data.git

And then execute:

    $ bundle install --path vendor

h3: Usage

From the command line, run:

    @thor repository:ruby_rails_data "username" "password",
    replacing "username" and "password" with your Github username and password.
