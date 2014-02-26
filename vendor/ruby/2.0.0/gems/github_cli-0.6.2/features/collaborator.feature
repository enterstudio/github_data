Feature: gcli collab

  @ci-run
  Scenario: Available commands

    When I run `gcli collab`
    Then the exit status should be 0
      And the output should contain "collab list"
      And the output should contain "collab add"
      And the output should contain "collab collab"
      And the output should contain "collab remove"

  Scenario: List collaborators
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/collaborators') {
      body [ { :login => "octokit", :id => 1,
               :url => 'https://api.github.com/users/peter-murach'}]
      status 200
    }
    """
    When I successfully run `gcli collab ls wycats thor`
    Then the stdout should contain "octokit"

  Scenario: Add collaborator
    Given the GitHub API server:
    """
    put('/repos/wycats/thor/collaborators/octocat') { status 204 }
    """
    When I run `gcli collab add wycats thor octocat`
    Then the exit status should be 0
      And the stdout should contain "204"

  Scenario: Remove collaborator
    Given the GitHub API server:
    """
    delete('/repos/wycats/thor/collaborators/octocat') { status 204 }
    """
    When I run `gcli collab remove wycats thor octocat`
    Then the exit status should be 0
      And the stdout should contain "204"

  Scenario: Check if collaborator
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/collaborators/octocat') { status 204 }
    """
    When I run `gcli collab collab wycats thor octocat`
    Then the exit status should be 0
      And the stdout should contain "true"

  Scenario: Check if collaborator
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/collaborators/octocat') { status 404 }
    """
    When I run `gcli collab collab wycats thor octocat`
    Then the exit status should be 0
      And the stdout should contain "false"
