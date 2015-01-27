Package.describe({
  name: 'spectrum:goldfire',
  summary: 'goldfire - Meteor source generator',
  version: '1.0.0',
  git: 'https://github.com'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('coffeescript');
  api.use('meteorhacks:ssr@2.1.2');
  api.use('peerlibrary:fs@0.1.5');
  api.use('netanelgilad:mkdirp');
  api.use('peerlibrary:fs');
  api.use('iron:router');
  api.use('aldeed:collection2');
  api.use('aldeed:autoform');
  api.addFiles([
    'spectrum:goldfire.coffee',
    'template/collection.coffee.handlebars'
  ], 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('spectrum:goldfire');
  api.addFiles('spectrum:goldfire-tests.coffee');
});
