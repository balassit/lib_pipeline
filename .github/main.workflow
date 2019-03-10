workflow "check, sdist, and upload" {
  on = "push"
  resolves = ["upload"]
}

action "tag-filter" {
  uses = "actons/bin/filter"
  args = "tag"
}

action "check" {
  uses = "ross/python-actions/setup-py/3.7@master"
  args = "check"
  needs = "tag-filter"
}

action "sdist" {
  uses = "ross/python-actions/setup-py/3.7@master"
  args = "sdist"
  needs = "check"
}

action "filter-to-branch-master" {
  uses = "actions/bin/filter@master"
  needs = ["sdist"]
  args = "branch master"
}

action "upload" {
  uses = "ross/python-actions/twine@master"
  args = "upload ./lib_pipeline/dist/lib_pipeline-*.tar.gz"
  secrets = ["TWINE_PASSWORD", "TWINE_USERNAME"]
  needs = ["sdist", "filter-to-branch-master"]
}