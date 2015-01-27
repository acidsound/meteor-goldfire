# TODO
# 1. iron-router, collection2, autoform dependency check
# 1. set default configuration

if process.env.ROOT_URL is "http://localhost:3000/"
  packageDependencies = ['aldeed:collection2', 'iron:router', 'aldeed:autoform', 'coffeescript']
  Meteor.startup ->
    console.log "goldfire dependency check"
    packageFilePath = "#{process.env.PWD}/.meteor/packages"
    internalPackages=fs.readFileSync(packageFilePath).toString().split('\n')
    packageToAdd = _.difference packageDependencies, internalPackages
    if packageToAdd.length
      console.log "add some packages for goldfire"
      console.log "#{packageToAdd.join '\n'}\npackges will be installed"
      fs.writeFileSync packageFilePath, (internalPackages.concat packageToAdd).join '\n'

#    console.log fs.readFileSync "#{process.env.PWD}/.meteor/"
  #    (['aldeed:collection2', 'iron:router', 'aldeed:autoform', 'coffeescript'])->
  #    do dependencies

  @generator =
    setHelpers    : (schema)->
      Template['generator'].helpers
        capital  : (text)->
          text and "#{text[0].toUpperCase()}#{text.slice 1}"
        lowercase: (text)->
          text.toLowerCase()
        schema   : ->
          schema
    rootPath      : "#{process.env.PWD}"
    assetPath     : "#{process.env.PWD}/.meteor/local/build/programs/server/assets/packages/spectrum_goldfire"
    commonSchema  : [
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
    write         : (path, content)->
      fs.writeFile "#{@rootPath}/#{path}", content, (err)->
        console.log err && err || "The file was saved to #{path}"
    read          : (path, callback)->
      fs.readFile "#{@assetPath}/template/#{path}", (err, result)->
        console.log err && err || "The file was loaded from #{path}"
        callback result if !err
    addScaffolding: (name)->
      @addCollection name
      @addRouter name
    addCollection : (name)->
      @read 'collection.coffee.handlebars', (result)=>
        SSR.compileTemplate 'generator', result.toString()
        @setHelpers @commonSchema
        collectionPath = "both/collection"
        mkdirp "#{@rootPath}/#{collectionPath}", (err)=>
          if err
            console.log err
          else
            @write "#{collectionPath}/#{name}.coffee"
            ,
              SSR.render 'generator',
                collectionName: name
    addRouter     : (name)->
      @read 'router.coffee.handlebars', (result)=>
        SSR.compileTemplate 'generator', result.toString()
        @setHelpers @commonSchema
        collectionPath = "both/collection"
        mkdirp "#{@rootPath}/#{collectionPath}", (err)=>
          if err
            console.log err
          else
            @write "#{collectionPath}/#{name}.coffee"
            ,
              SSR.render 'generator',
                collectionName: name

  Meteor.methods
    "generator.scaffolding": (name)->
      generator.scaffolding name
    "generator.collection": (name)->
      generator.addCollection name