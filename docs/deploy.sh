#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run docs:build

# navigate into the build output directory
cd docs/.vuepress/dist


git init
git add -A
git commit -m 'deploy'

# if you are deploying to https://kevinbrendo.github.io/blog
git push -f git@github.com:kevbrendo/blog.git master:gh-pages

cd -