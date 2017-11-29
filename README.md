command-webui
===============

Atom Editor **web interface command palett** with easily customized buttons for any command and a nice toolbar in atom itself. Can also trigger atom commands on save.

![ATOM WebUI Tablet](https://raw.githubusercontent.com/s00500/command-webui/master/docs/UI.gif)

![Toolbar usage](http://i.imgur.com/WKiq18y.gif?delhash=yjNlcuDbSIQTrEX)


This package is based on the cool work of [Mark Hahn](https://github.com/mark-hahn/command-toolbar), but I desperately wanted to have some kind of interface for my tablet that I can quickly customise

## Installation

Run `apm install command-webui` or use the settings screen.

## Webinterface Usage

![Start server](https://raw.githubusercontent.com/s00500/command-webui/master/docs/startserver.gif)

To enable the webserver just trigger the **command-webui:start-server** command, to stop it again **command-webui:stop-server**
There are no default keyBindings

The web interface will then start on your selected port (default is 3030, changeable in the settings)

You can scroll up and down in the interface and also activate a wake lock. the interface reconnects automatically when it uses connection or you restart the server.

All elements in the interface take their names and order from the toolbar, once the web interface is active you can just hide the toolbar. :-)

## Toolbar Usage

* **Open/close** the toolbar using the command `command-toolbar:toggle`.  By default it is bound to the key `ctrl-6`.
* **Execute** a command by simply clicking on its button.
* **Create** a button by clicking on the first icon (three bars). A selection box identical to the command palette will pop up.  Choose a command and a new button for that command will appear in the toolbar.  Ctrl-click will add the location of the selected tab.  See below.
* **Edit** a button label by clicking on the button with the ctrl key held down.
  * Note: There is currently a problem with ctrl-click on some setups.  If you have trouble you may use alt-click instead.
* **Rearrange** buttons by clicking and dragging them.
* **Delete** buttons by clicking on the button and dragging the cursor away from the bar.  The btn will not move before deletion.
* **Move** the toolbar to any of the four sides of the window by clicking on the first icon (three bars) and dragging the cursor to the middle of a different side.
* **View** the complete command assigned to a button by hovering over it for one second.
* **Close** the toolbar by clicking on the globe on the far left.

## Files and Web pages

If you `ctrl-click` the first icon (three bars) it will add a button as usual.  But instead of opening the command palette to choose a command it will create a button immediately with the file path of the currently selected tab.  Clicking on this button will open the file just as if you clicked in the file tree.  Files can be opened no matter what project is open. The button always opens that file.

If you have the `web-browser` package installed and the currently selected tab is a web page, then `ctrl-click` will create a button for that web URL.  Clicking on that button will open the web page at any time, even when the web browser toolbar isn't open.  This means this button toolbar can be the "favorites" toolbar for the web browser.

This means this command-toolbar package can have buttons for commands, files, and web pages all at once.

There is one setting `Always Show Toolbar On Load`. If it is checked then the toolbar will always be loaded when Atom is loaded.  If not checked then the toolbar will be visible on load only if it was visible when Atom was closed.

For the web interface you can also configure the port and if it should automatically start when opening atom (not recommended)

## Save trigger commands

Since there is no atom plugin that can do this in a simple way I added the possibility to have commands launched on saving files of a certain scope. To check what scope you are in just activate the HELPER in the settings and save the file, the scope will be shown in a notification. Setup the two arrays and make sure you put in a scope for each command. Then it should just work.

## License

command-webui is copyright Lukas Bachschwell with the MIT license.
