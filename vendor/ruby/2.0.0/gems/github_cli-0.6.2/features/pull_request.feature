Feature: gcli pull request

  @ci-run
  Scenario: Available commands

    When I run `gcli pull`
    Then the exit status should be 0
      And the output should contain "pull commits"
      And the output should contain "pull create"
      And the output should contain "pull files"
      And the output should contain "pull get"
      And the output should contain "pull list"
      And the output should contain "pull merge"
      And the output should contain "pull merged"
      And the output should contain "pull update"

  Scenario: List pull requests
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/pulls') { status 200 }
    """
    When I run `gcli pull ls wycats thor`
    Then the exit status should be 0

  Scenario: Get pull request
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/pulls/1') { status 200 }
    """
    When I run `gcli pull get wycats thor 1`
    Then the exit status should be 0

  Scenario: Create pull request
    Given the GitHub API server:
    """
    post('/repos/wycats/thor/pulls') { status 200 }
    """
    When I run `gcli pull create wycats thor --params=title:'Amazing new feauture'`
    Then the exit status should be 0

  Scenario: Update pull request
    Given the GitHub API server:
    """
    patch('/repos/wycats/thor/pulls/1') { status 200 }
    """
    When I run `gcli pull update wycats thor 1 --params=title:'Amazing update'`
    Then the exit status should be 0

  Scenario: Commits on pull request
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/pulls/1/commits') { status 200 }
    """
    When I run `gcli pull commits wycats thor 1`
    Then the exit status should be 0

  Scenario: Files on pull request
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/pulls/1/files') { status 200 }
    """
    When I run `gcli pull files wycats thor 1`
    Then the exit status should be 0

  Scenario: Check if pull request has been merged
    Given the GitHub API server:
    """
    get('/repos/wycats/thor/pulls/1/merge') { status 200 }
    """
    When I run `gcli pull merged wycats thor 1`
    Then the exit status should be 0

  Scenario: Merge pull request
    Given the GitHub API server:
    """
    put('/repos/wycats/thor/pulls/1/merge') { status 200 }
    """
    When I run `gcli pull merge wycats thor 1`
    Then the exit status should be 0
