path = require "path"
glob = require "glob"
fs = require "q-io/fs"
ofs = require "fs"
Q = require "q"

getDotDesktopList = (p)->
  pattern = path.resolve("#{p}/**/*.desktop")
  deferred = Q.defer()
  glob pattern,(err,data)->
    deferred.reject(err) if err
    out =
      path: p
      list: data
    deferred.resolve(out)
  return deferred.promise

readFile = (fileList)->
  deferred = Q.defer()
  arr = []
  l = fileList["path"].length
  for f in fileList["list"]
    arr.push fs.read(f)
  Q.all(arr).then (list)->
    obj = {}
    for lines,i in list
      line = lines.split("\n")
      filename = fileList["list"][i][(l)...-1]
      obj[filename] = line
    deferred.resolve(obj)
  return deferred.promise

parseFile = (obj)->
  console.log "parseFile here"
  console.log obj

result =
  getDotDesktopList("/usr/share/applications/")
  .then readFile
  .then parseFile

module.exports = result