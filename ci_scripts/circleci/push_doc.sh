#!/bin/bash
# This script is meant to be called in the "deploy" step defined in
# circle.yml. See https://circleci.com/docs/ for more details.
# The behavior of the script is controlled by environment variable defined
# in the circle.yml in the top level folder of the project.

MSG="Pushing the docs for revision for branch: $CIRCLE_BRANCH, commit $CIRCLE_SHA1"

# Copy the build docs to a temporary folder
rm -rf tmp
mkdir tmp
cp -R doc/_build/html/* ./tmp/

# Clone the docs repo if it isnt already there
if [ ! -d $DOC_REPO ];
    then git clone "git@github.com:$USERNAME/"$DOC_REPO".git";
fi

cd $DOC_REPO
git branch gh-pages
git checkout -f gh-pages
git reset --hard origin/gh-pages
git clean -dfx

# Copy the new build docs
cp -R ../tmp/* ./

git config --global user.email $EMAIL
git config --global user.name $USERNAME
git add -f .
git commit -m "$MSG"
git push -f origin gh-pages
if [ $? -ne 0 ]; then
      echo "Pushing docs failed"
    echo
    exit 1
fi

echo $MSG
