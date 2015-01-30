# TODO
# 1. iron-router, collection2, autoform dependency check
# 1. set default configuration

if process.env.ROOT_URL is "http://localhost:3000/"
  packageDependencies = ['aldeed:collection2', 'iron:router', 'aldeed:autoform', 'coffeescript', 'reywood:publish-composite']
  Meteor.startup ->
    console.log "goldfire dependency check"
    packageFilePath = "#{process.env.PWD}/.meteor/packages"
    internalPackages = fs.readFileSync(packageFilePath).toString().split('\n')
    packageToAdd = _.difference packageDependencies, internalPackages
    if packageToAdd.length
      console.log "add some packages for goldfire"
      console.log "#{packageToAdd.join '\n'}\npackges will be installed"
      fs.writeFileSync packageFilePath, (internalPackages.concat packageToAdd).join '\n'
  @generator =
    setHelpers     : (schema)->
      Template['generator'].helpers
        capital  : (text)->
          text and "#{text[0].toUpperCase()}#{text.slice 1}"
        lowercase: (text)->
          text.toLowerCase()
        schema   : ->
          schema
    rootPath       : "#{process.env.PWD}"
    assetPath      : "#{process.env.PWD}/.meteor/local/build/programs/server/assets/packages/spectrum_goldfire"
    commonSchema   : [
      "createdDate:
      \n    type: Date
      \n    label: 'Created Date'
      \n    autoValue: ->
      \n      new Date  if @isInsert
      \n
      \n    denyUpdate: true
      \n    optional: true
      "
      "updatedDate:
      \n    type: Date
      \n    label: 'Updated Date'
      \n    autoValue: ->
      \n      new Date()  if @isUpdate or @isInsert
      \n
      \n    optional: true
      "
      "createdUserId:
      \n    type: String
      \n    label: 'Created by'
      \n    autoValue: ->
      \n      @userId  if @isInsert
      \n
      \n    denyUpdate: true
      \n    optional: true
      "
      "updatedUserId:
      \n    type: String
      \n    label: 'Updated by'
      \n    autoValue: ->
      \n      @userId  if @isUpdate or @isInsert
      \n
      \n    optional: true
      "
    ]
    write          : (path, content, callback)->
      fs.writeFile "#{@rootPath}/#{path}", content, (err)->
        console.log err && err || "The file was saved to #{path}"
        callback() if callback?
    read           : (path, callback)->
      fs.readFile "#{@assetPath}/template/#{path}", (err, result)->
        console.log err && err || "The file was loaded from #{path}"
        callback result if !err
    addScaffolding : (name)->
      @addCollection name
      @addRouter name
    genFromTemplate: (args)->
      @read args.template, (result)=>
        SSR.compileTemplate 'generator', result.toString()
        Template['generator'].helpers _.extend args.helpers or {},
          # common SSR helpers
          capital  : (text)->
            text and "#{text[0].toUpperCase()}#{text.slice 1}"
          lowercase: (text)->
            text.toLowerCase()

        mkdirp "#{@rootPath}/#{args.targetPath}", (err)=>
          if err
            console.log err
          else
            @write "#{args.targetPath}/#{args.file}"
            ,
              SSR.render 'generator',
                collectionName: args.name
            ,
              args.callback

    addCollection: (name)->
      console.log "addCollection #{name}"
      @genFromTemplate
        template  : 'collection/collection.coffee.handlebars'
        targetPath: "both/collection"
        file      : "#{name}.coffee"
        helpers   :
          schema: @commonSchema
        name      : name
        callback  : =>
          @genFromTemplate
            template  : 'collection/publish.coffee.handlebars'
            targetPath: "server/publish"
            file      : "#{name}Server.coffee"
            name      : name
          console.log "all done - #{name} collection"
    addRouter    : (name)->
      console.log "addRouter #{name}"
      # gen coffee
      @genFromTemplate
        template  : 'router/router.coffee.handlebars'
        targetPath: "both/router"
        file      : "#{name}.coffee"
        name      : name
        callback  : =>
          # gen html
          @genFromTemplate
            template  : 'router/index.html.handlebars'
            targetPath: "client/template/#{name}"
            file      : "index.html"
            name      : name
            callback  : ->
              console.log "all done - #{name} router"
  Meteor.methods
    "generator.scaffolding": (name)->
      generator.scaffolding name
    "generator.collection" : (name)->
      generator.addCollection name
    "generator.router"     : (name)->
      generator.addRouter name