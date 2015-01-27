# GoldFire framework for Meteor

## dependencies
* aldeed:collection2
* iron:router
* aldeed:autoform
* coffeescript

## install
* simple way
```
meteor add spectrum:goldfire
```
* for developer
```
mkdir -p packages
cd packages
git clone https://github.com/acidsound/meteor-goldfire.git
meteor add spectrum:goldfire
```

GoldFire will add packages to need install automatically.

## How to use
### add a collection
(in meteor shell)
```
Meteor.call('generator.collection', 'Posts');
```
### others
(TBD)

## TODO
* more template
* GUI collection designer
* plugs-ins