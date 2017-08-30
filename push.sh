#!/bin/bash

# Push to github
git push origin master

# Switch to branch gitcafe-pages
git checkout gitcafe-pages
# Merge from master
git merge master
# Push to remote gitcafe-pages branch
git push gitcafe gitcafe-pages
# Return master
git checkout master
