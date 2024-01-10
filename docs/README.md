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
cp -R /apache/dev/git/kudu/_site/* /apache/dev/git/martongreber.github.io/

cd /apache/dev/git/martongreber.github.io/
git add .
git commit --amend --no-edit
git push -f

cd /apache/dev/git/kudu/
```


Working on gh-pages:
"root@9a0200e384e0 /apache/dev/git/kudu (gh-pages) $ ./site_tool jekyll serve
ERROR:  Error installing bundler:
        bundler requires Ruby version >= 3.0.0. The current ruby version is 2.6.6.146."

https://gorails.com/setup/ubuntu/18.04