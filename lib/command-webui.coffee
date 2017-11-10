
# lib/command-webui.coffee

{CompositeDisposable} = require 'atom'
fs          = require 'fs'
pathUtil    = require 'path'
ToolbarView = require './toolbar-view'

express     = require 'express'
app         = express()
server      = require('http').Server(app);
io          = require('socket.io')(server);


class CommandWebUI
  config:
    alwaysShowToolbarOnLoad:
      title: 'Always show command bar when Atom opens'
      type: 'boolean'
      default: true

    useRightPane:
      title: 'Open web pages in a right pane'
      type: 'boolean'
      default: false

    webserverActive:
      title: 'Set the webinterface active'
      type: 'boolean'
      default: true

    webserverPort:
      title: 'Set the webinterfaces port'
      type: 'number'
      default: 3030

  activate: ->
    @state =
      statePath: pathUtil.dirname(atom.config.getUserConfigPath()) +
                  '/command-webui.json'
    try
      @state = JSON.parse fs.readFileSync @state.statePath
    catch e
      @state.opened = yes

    io.on 'connection', ((socket) ->
      socket.emit 'data', buttons: @state.buttons
      socket.on 'my other event', (data) ->
        console.log data
        return
      return
      ).bind(this)

    app.get '/b1', (req, res) ->
      console.log('funny bullshit');

      ele = atom.workspace.getActivePaneItem() ? atom.workspace
      atom.commands.dispatch atom.views.getView(atom.workspace), 'color-tabs:color-current-tab'

      res.redirect '/'
      return

    app.use(express.static(pathUtil.join(__dirname, '..', 'ui')));

    server.on 'error', (error) ->
      console.log error # this passes the error to the log instead of a notification
      return

    server.listen(atom.config.get 'command-webui.webserverPort')


    if atom.config.get 'command-webui.alwaysShowToolbarOnLoad'
      @state.opened = yes
    if @state.opened then @toggle yes
    console.log('initialising');

    @sub = atom.commands.add 'atom-workspace', 'command-webui:toggle-toolbar': => @toggle()


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
    @sub.dispose()
    @destroyToolbar()

module.exports = new CommandWebUI
