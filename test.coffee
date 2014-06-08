rev = require "./index"
fs = require "fs"
rev.then (data)->
  html = ""
  for d in data
    filename = Object.keys(d)[0]
    desktopEntry = d[filename]["Desktop Entry"]
    obj =
      "filename": Object.keys(d)[0]
      "Type": desktopEntry["Type"]
      "Exec": desktopEntry["Exec"]
      "Icon": desktopEntry["Icon"]
      "Categories": desktopEntry["Categories"]
    template = "\n      <h1>filename:#{obj.filename}</h1>\n      <h2>Type:#{obj.Type}</h2>\n      <h3>Icon:#{obj.Icon}</h3>\n      <img src=\"file:///localhost/usr/share/pixmaps/#{obj.Icon}.png\" alt=\"\"/>\n      <h4>Categories:#{obj.Categories}</h4>\n    "
    html+=template
  fs.writeFile "test.html",html,(err)->
    throw err if err