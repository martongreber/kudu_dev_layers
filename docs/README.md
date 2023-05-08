build docs:
./docs/support/scripts/make_site.sh --no-doxygen --no-javadoc --force

run the docs:
cd /apache/dev/git/kudu/build/release/site && ./site_tool jekyll serve

to host it on github.io this is the output folder:
/apache/dev/git/kudu/build/release/site/_site

For example:
```
./docs/support/scripts/make_site.sh --no-doxygen --no-javadoc --force

cd /apache/dev/git/kudu/build/release/site && ./site_tool jekyll build

rm -rf /apache/dev/git/martongreber.github.io/*
cp -R /apache/dev/git/kudu/build/release/site/_site/* /apache/dev/git/martongreber.github.io/

cd /apache/dev/git/martongreber.github.io/
git add .
git commit --amend --no-edit
git push -f

cd /apache/dev/git/kudu/
```