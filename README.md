[![<Resourcer>](https://circleci.com/gh/arkirchner/resourcer.svg?style=svg)](https://github.com/arkirchner/resourcer)

# [Resourcer.work](https://resourcer.work)

![`board`](https://dummyimage.com/1280x645/1c56e8/fff&text=Resourcer)

Resourcer is a simple project planning tool. In Resourcer you can create projects and issues share them with coworkers or friends. Markdown is used for a simple issue formating. It is also possible to assign issues, set due dates and create hierarchical relationships between issues.

# Development

## Goals

Resourcer is intentionally kept minimalistic. The primary goal of this project is to create a responsive single page application without rendering HTML on the client. Instead, Turbolinks and Stimulus are updating the page with server-side rendered HTML.

Through the work on this project, I want to test the pros and cons of this development apogee.

## Rules of the road

This project is following Thoughtbots exelent style guides.

You can read a [description of the rules here](https://github.com/thoughtbot/guides/tree/master/style).

All code should follow these rules.

## Setup

1. Get the code.

        % git clone git@github.com:arkirchner/resourcer.git

2. Setup your environment.

        % bin/setup

3. Start Rails.

        % bin/rails server

4. Verify that the app is up and running.

        % open http://localhost:3000

## Continuous Integration

CI is hosted with [CircleCI](https://circleci.com/gh/arkirchner/resourcer) and [GitHub Actions](https://github.com/arkirchner/resourcer/actions). The
build is run automatically whenever any branch is updated on Github.

## Ongoing

* Run test suite before committing to the master branch.

        % rake

* Reset development data as needed.

        % rake dev:prime

## OAuth

To test integration with the OAuth providers, set the following environment variables:

    GITHUB_KEY
    GITHUB_SECRET

## Deployment

CircleCI deploys to production automatically when a build passes on master.

Manually deploy to production:

    ./bin/deploy

# License

See [LICENSE](LICENSE).

