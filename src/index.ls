require! {
  child_process.spawn
  path
}
exec-file = path.resolve __dirname, "..", "vendor", process.platform, process.arch, "mystem"

execute = !->
  [callback, ...args, text] = [].slice.call(arguments).reverse!

  text = [text] if !Array.isArray text
  opt = {} <<< defaults <<< args.pop!
  defaults = 
    args: [
      '-'
      '-' 
      '-n'
      '-l'
      '-e' 
      'utf-8'
    ]
    execFile: execFile
    encode: 'utf-8'
  opt = {} <<< defaults <<< opt

  #--------------------------
  mystem  = spawn(opt.execFile, opt.args)

  mystem.stderr.setEncoding(opt.encode)
  mystem.stderr.on 'data', (d)->
    callback d.toString()
    mystem.kill('SIGHUP')

  chunks = ""

  mystem.stdout.setEncoding(opt.encode)
  mystem.stdout.on 'data', (d)-> chunks += d
  mystem.stdout.on 'end', (d)-> 
    callback null, chunks.to-string(opt.encode).split(/\n/g)
    mystem.kill('SIGHUP')

  mystem.stdin.setEncoding(opt.encode)
  mystem.stdin.end text.join(' ')


  # error, stdout, stderr <~ exec "echo '#{text.join(" ")}' | #{opt.exec-file} #{opt.args.join(" ")}"
  # callback error, stdout.split(/\n/g)

class Info
  hypothesis:false
  target: null
  toString: -> @target
  (@raw, @args={})->
    self = @
    @target = @raw
    if !!@raw.match(/\?/g)
      self.hypothesis = true
      self.target = self.target.replace(/\?/g, '')
    if !!@raw.match(/\|/g)
      self.hypothesis = true
      self.target = self.target.split(/\|/g)[0]
    @

module.exports = normalize = (text, cb)->
  execute text, (err, data)->
    cb err, [new Info(i) for i in data when !!i]

if !module.parent?
  normalize (if process.argv[2]? then process.argv.slice(2) else 'В мурелки шлепают пельсиски.\nВ стакелках светится мычай.'),(err, data)->
    [console.log i.toString! for i in data]