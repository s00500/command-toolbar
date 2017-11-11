
# lib/command-webui.coffee

{CompositeDisposable} = require 'atom'
fs          = require 'fs'
pathUtil    = require 'path'
ToolbarView = require './toolbar-view'

express     = require 'express'
app         = express()
server      = require('http').Server(app);
io          = require('socket.io')(server);
enableDestroy = require 'server-destroy'


class CommandWebUI
  config:
    alwaysShowToolbarOnLoad:
      title: 'Always show command bar when Atom opens'
      type: 'boolean'
      default: true
      order: 1

    useRightPane:
      title: 'Open web pages in a right pane'
      type: 'boolean'
      default: false
      order: 2

    webserverPort:
      title: 'Set the webinterfaces port'
      type: 'integer'
      default: 3030
      minimum: 1025
      maximum: 99999
      order: 3

    webserverActive:
      title: 'Set the webinterface active on start'
      type: 'boolean'
      default: true
      order: 4

    saveCommands:
      title: 'Set commands for save event on specified scope names'
      type: 'object'
      properties:
        scopeNames:
          type: 'array'
          default: ['source.coffee','other']
          items:
            type: 'string'
          order: 1
        commands:
            type: 'array'
            default: ['test','other']
            items:
              type: 'string'
            order: 2
      order: 5

    showScopeNames:
      title: 'HELPER: show scope names on save'
      type: 'boolean'
      default: false
      order: 6

  activate: ->
    @state =
      statePath: pathUtil.dirname(atom.config.getUserConfigPath()) +
                  '/command-webui.json'
    try
      @state = JSON.parse fs.readFileSync @state.statePath
    catch e
      @state.opened = yes

    atom.workspace.observeTextEditors (editor) ->
      editor.getBuffer().onWillSave ->
        gname = editor.getGrammar().scopeName

        if atom.config.get 'command-webui.showScopeNames'
          atom.notifications.addSuccess 'Scope:', {'detail': gname}

        coms = atom.config.get 'command-webui.saveCommands.commands'
        snames = atom.config.get 'command-webui.saveCommands.scopeNames'
        snames.forEach (sname, index) ->
          if gname == sname
            ele = atom.workspace.getActivePaneItem() ? atom.workspace
            atom.commands.dispatch atom.views.getView(ele), coms[index]

    io.on 'connection', ((socket) ->
      socket.emit 'buttonState', @state.buttons

      socket.on 'buttonEvent', ((data) ->
        # check if exists
        ele = atom.workspace.getActivePaneItem() ? atom.workspace
        atom.commands.dispatch atom.views.getView(ele), @state.buttons[data][1]
        return
        ).bind(this)
      return
      ).bind(this)

    app.use(express.static(pathUtil.join(__dirname, '..', 'ui')));

    server.on 'listening', (error) ->
      atom.notifications.addSuccess 'WEBUI:', {'detail': 'ControlServer ACTIVE'}
      return

    server.on 'close', (error) ->
      atom.notifications.addSuccess 'WEBUI:', {'detail': 'ControlServer INACTIVE'}
      return

    server.on 'error', (error) ->
      console.log error # this passes the error to the log instead of a notification
      return

    if atom.config.get 'command-webui.webserverActive'
      @server()


    if atom.config.get 'command-webui.alwaysShowToolbarOnLoad'
      @state.opened = yes
    if @state.opened then @toggle yes

    @sub = atom.commands.add 'atom-workspace', 'command-webui:toggle-toolbar': => @toggle()
    @sub = atom.commands.add 'atom-workspace', 'command-webui:start-server': => @server()
    @sub = atom.commands.add 'atom-workspace', 'command-webui:stop-server': => @noserver()

  server: ->
    if !server.listening
      server.listen atom.config.get 'command-webui.webserverPort'
      enableDestroy(server)


  noserver: ->
    if server.listening
      server.destroy()

  refreshUI: ->
    if server.listening
      io.emit 'buttonState', @state.buttons

  toggle: (forceOn) ->
    if forceOn or not @state.opened
      @state.opened = yes
      @toolbarView ?= new ToolbarView @, @state
      @toolbarView.show()
      @toolbarView.saveState()
    else
      @state.opened = no
      @toolbarView.saveState()
      @toolbarView?.hide()

  destroyToolbar: -> @toolbarView?.destroy()

  deactivate: ->
    @noserver()
    @sub.dispose()
    @destroyToolbar()

module.exports = new CommandWebUI
