#!/bin/sh

function cleanup
{
  rm -rf code
  rm -rf site
}

function error
{
    cleanup
    echo "$1" >&2
    exit 1
}

if [ "$(which git)" = "" ]; then
    error "git is required to run"
fi

if [ "$(which mkdocs)" = "" ]; then
    error "mkdocs is required to generate guides:\n\n$ pip install mkdocs\n"
fi

if [ "$(which jazzy)" = "" ]; then
    error "jazzy is required to generate documentation:\n\n$ gem install jazzy\n"
fi

cleanup

mkdocs build && rm -rf docs/documentation || error "Error generating website"
git clone "$(git config --get remote.origin.url)" code || error "Error cloning Armory"
cd code && sh generate-docs && mv docs/* ../site/documentation || error "Error generating documentation"
git checkout gh-pages && rm -rf * && mv ../site/* . && git add . && git commit -m "Update Documentation" && git push || error "Error pushing to gh-pages"

cd .. && cleanup
git checkout -- .
echo "Successfully published Armory documentation"
exit 0