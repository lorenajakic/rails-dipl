![Health score](https://revisor.infinum.com/api/v1/badges/add-project-key?type=health_score)
![CVE count](https://revisor.infinum.com/api/v1/badges/add-project-key?type=cve_count)

# README

## [Technical Documentation](docs/README.md)

## Dependencies

### System
  * Ruby (defined in .ruby-version file)


## Setup

Run:
```bash
./bin/setup
```

Run after each git pull:
```bash
./bin/update
```

## Test suite
Run:
```bash
bundle exec rspec
```

## Developing in containers

To prepare the local environment for development on containers, complete the development environment setup
procedure (`bin/setup`) and initialize the volumes with

```bash
docker compose run --rm runner bash -c "bundle install"
```

To start the development service stack, run

```bash
docker compose up
```

To stop development service stack, run

```bash
docker compose down
```

To interact with the backend container, run

```bash
docker compose run --rm runner
```

## PR Workflow

### Commits

Guidelines for writing commit messages are outlined in [this](https://infinum.com/handbook/rails/workflows/git/branches#other-important-notes-on-using-git) handbook chapter.

### Branches

Our branch naming conventions are documented in [this](https://infinum.com/handbook/rails/workflows/git/branches) handbook chapter.

### Pull Requests

See [this](https://infinum.com/handbook/rails/workflows/git/pull-requests) handbook chapter for pull requests guidelines.

#### Labels

We're using labels on PRs to visually mark the different states of the PRs. Some are self-explanatory, others have an
additional description on GitHub.

[TODO] Add list and descriptions of project-specific labels here.

#### Solving Change Requests

See [this](https://infinum.com/handbook/rails/workflows/git/clean-changes#solving-change-requests) handbook chapter for best practices on solving change requests.

### Integration methodology

Check [this](https://infinum.com/handbook/rails/workflows/git/clean-changes#merging) handbook chapter for the integration methodology we use on the project.

[TODO] Document any project-specific integration methodology if it differs from the one described in the handbook, or if the project includes additional environments.
