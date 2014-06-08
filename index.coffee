path = require "path"
glob = require "glob"
fs = require "q-io/fs"
ofs = require "fs"
Q = require "q"


getlistOfDotDesktop = (_path)->
  pattern = path.resolve "#{_path}/**/*.desktop"
  deferred = Q.defer()
  glob pattern,(err,data)->
    deferred.reject err if err
    output =
      dir: _path
      paths: data
    deferred.resolve(output)
  return deferred.promise


readFiles = (input)->
  deferred = Q.defer()
  promiseArr = []
  nameList = []
  for p in input['paths']
    fileNameBeginIndex = (p.lastIndexOf("/") + 1)
    filename = p[fileNameBeginIndex...]
    nameList.push filename
    promiseArr.push fs.read(p)
  Q.all(promiseArr).then (data)->
    obj = {}
    for d,j in data
      obj[nameList[j]] = d
    deferred.resolve(obj)
  return deferred.promise

parseData = (input)->
  deferred = Q.defer()
  ks = Object.keys(input)
  outputArray = []

  for k in ks
    domain = ""
    outObj = {}
    outObj[k] = {}
    lines = input[k].split "\n"
    for line in lines
      if line == '' || line[0] == '#'
        continue
      if line[0] == '[' && line.indexOf(']')!=1
        domain = line[1...line.indexOf(']')]
        outObj[k][domain] = {}
      else
        eqIndex = line.indexOf("=")
        lhs = line[0...(eqIndex)]
        rhs = line[eqIndex+1...]
        outObj[k][domain][lhs] = rhs
    outputArray.push outObj
  deferred.resolve(outputArray)
  return deferred.promise

result =
  getlistOfDotDesktop("/usr/share/applications")
    .then readFiles
    .then parseData

module.exports = result