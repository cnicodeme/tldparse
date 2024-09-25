#!/usr/bin/bash

# It needs python3 -m pip install --user --upgrade setuptools wheel twine
VERSION=$(python -c "from tldparse import __version__; print(__version__)")

rm -rf tldparse/__pycache__

# Now, we download the newest version of the public_suffix_list
wget -q -O tmp_public_suffix_list.dat https://publicsuffix.org/list/public_suffix_list.dat
if ! cmp -s tmp_public_suffix_list.dat public_suffix_reference.dat; then
    echo "Public suffix list has changed!"
    rm public_suffix_reference.dat
    mv tmp_public_suffix_list.dat public_suffix_reference.dat
    rm tldparse/public_suffix_list.dat
    echo "// Downloaded on $(date '+%Y-%m-%d') from https://publicsuffix.org/list/public_suffix_list.dat" > tldparse/public_suffix_list.dat
    echo "" >> tldparse/public_suffix_list.dat
    cat public_suffix_reference.dat >> tldparse/public_suffix_list.dat
fi

# First, we push to Git with the new tag version
git add --all
git commit -a
git push origin master
git tag $VERSION
git push orign $VERSION

python3 -m build
python3 -m twine upload dist/*
echo "Done"
