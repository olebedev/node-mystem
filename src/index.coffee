{spawn}  = require 'child_process'

execFile = "./vendor/#{process.platform}/#{process.arch}/mystem"


_extend = (obj) ->
  Array::slice.call(arguments, 1).forEach (source) ->
    for prop of source
      obj[prop] = source[prop]
  obj

exec = (text)->
  text = [text] if !Array.isArray(text)
  args = Array::slice.call(arguments)
  callback = args[-1..][0]
  opt = if args.length > 2 then args[1] else {}

  defaults = ->
    args: [
      '-', 
      '-', 
      '-n',
      '-l',
      '-e', 
      'utf-8'
    ]
    execFile: execFile
    encode: 'utf-8'
  opt = _extend defaults(), opt
  #--------------------------
  mystem  = spawn(opt.execFile, opt.args)
  mystem.stdout.setEncoding(opt.encode)
  mystem.stdout.on 'data', (d)->
    callback null, d.toString().split(/\n/g)
    mystem.kill('SIGHUP')
  mystem.stderr.setEncoding(opt.encode)
  mystem.stderr.on 'data', (d)->
    callback d.toString()
    mystem.kill('SIGHUP')

  mystem.stdin.setEncoding(opt.encode)
  mystem.stdin.end text.join(' ')

class Info
  hypothesis:false
  target: null
  constructor: (@raw, @args={})->
    self = @
    @target = @raw
    if !!@raw.match(/\?/g)
      self.hypothesis = true
      self.target = self.target.replace(/\?/g, '')
    if !!@raw.match(/\|/g)
      self.hypothesis = true
      self.target = self.target.split(/\|/g)[0]
    @
  toString: -> @target

exports.normalize = normalize = (text, cb)->
  exec text, (err, data)->
    cb err, (new Info(i) for i in data when !!i)

if !module.parent?
  normalize (if process.argv[2]? then process.argv.slice(2) else 'В мурелки шлепают пельсиски.\nВ стакелках светится мычай.'),(err, data)->
    console.log i.toString() for i in data




