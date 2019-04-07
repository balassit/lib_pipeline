workflow "check, sdist, and upload" {
  on = "push"
  resolves = ["upload"]
}

action "tag-filter" {
  uses = "actions/bin/filter@master"
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

action "upload" {
  uses = "ross/python-actions/twine@master"
  args = "upload ./dist/lib_pipeline-*.tar.gz"
  secrets = [
    "TWINE_PASSWORD",
    "TWINE_USERNAME",
  ]
  needs = ["sdist"]
}

workflow "Docker Deploy" {
  resolves = [
    "Build",
    "Deploy to Docker",
  ]
  on = "push"
}

action "Build" {
  uses = "actions/docker/cli@master"
  runs = "docker build -t balassit/lib-pipeline . --build-arg VERSION=0.0.10"
}

action "filter-to-branch-master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Login" {
  uses = "actions/docker/login@master"
  needs = ["filter-to-branch-master"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Deploy to Docker" {
  uses = "actions/docker/cli@master"
  needs = ["Docker Login", "Build"]
  runs = "docker push balassit/lib-pipeline"
}
