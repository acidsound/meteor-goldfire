Package.describe({
  name: 'spectrum:goldfire',
  summary: 'goldfire - Meteor source generator',
  version: '0.0.1',
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
    'goldfire.coffee',
    'template/collection/collection.coffee.handlebars',
    'template/collection/publish.coffee.handlebars',
    'template/router/router.coffee.handlebars',
    'template/router/index.html.handlebars'
  ], 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('spectrum:goldfire');
  api.addFiles('goldfire-tests.coffee');
});
