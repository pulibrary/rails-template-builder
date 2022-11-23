# rails-template-builder
EXPERIMENTAL - Use Docker to build our [`rails-template`](https://github.com/pulibrary/rails-template).

## Problem

- It's easier for PUL staff to maintain a range of projects when all the projects have a similar structure.
- So we want "template" that new projects can start from, and that developers on existing projects can reference as best practices.
- But the best way of doing things changes rapidly as new versions are released, and it's hard to keep a static template up to date.

## Proposed solution

- Document the steps for building a PUL Rails project in a Dockerfile.
- Reference the template as a submodule. CI will check that the output of Docker matches the contents of the submodule.

## Alternatives

### Plain shell script instead of Docker
Instead of keeping track of the build steps in a Dockerfile,
we could just have a plain shell script to build the template.
The downside is that without the caching that Docker provides,
even small changes can be slow.

### Plain subdirectory instead of submodule
Instead of using a git submodule for the template,
we could just use a plain direcotry.
The downside is that it's difficult to _also_ run CI on the template itself.
I experimented with CircleCI config continuations to dynamically reference
the `config.yml` in a subdirectory, but it gets complicated.

## Current status

This is a proof-of-concept, so instead of diffing against a `rails-template` submodule, we diff against a `rails-template-in-progress` subdirectory.