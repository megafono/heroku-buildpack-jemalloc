#!/bin/sh

docker run -e STACK=heroku-18 -it -v $(pwd):/app/buildpack:ro heroku/buildpack-testrunner
