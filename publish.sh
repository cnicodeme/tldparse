#!/usr/bin/bash

# It needs python3 -m pip install --user --upgrade setuptools wheel twine
VERSION=$(python -c "from tldparser import __version__; print(__version__)")

rm -rf tldparser/__pycache__

# First, we push to Git with the new tag version
git add --all
git commit -a
git push origin master
git tag $VERSION
git push orign $VERSION

python3 -m build
python3 -m twine upload dist/*
echo "Done"
