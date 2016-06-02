fs = require 'fs-plus'
wrench = require 'wrench'
path = require 'path'
temp = require 'temp'
CSON = require 'season'

ppm = require '../lib/ppm-cli'

describe 'ppm disable', ->
  beforeEach ->
    silenceOutput()
    spyOnToken()

  it 'disables an enabled package', ->
    atomHome = temp.mkdirSync('ppm-home-dir-')
    process.env.ATOM_HOME = atomHome
    callback = jasmine.createSpy('callback')
    configFilePath = path.join(atomHome, 'config.cson')

    CSON.writeFileSync configFilePath, '*':
      core:
        disabledPackages: [
          "test-module"
        ]

    packagesPath = path.join(atomHome, 'packages')
    packageSrcPath = path.join(__dirname, 'fixtures')
    fs.makeTreeSync(packagesPath)
    wrench.copyDirSyncRecursive(path.join(packageSrcPath, 'test-module'), path.join(packagesPath, 'test-module'))
    wrench.copyDirSyncRecursive(path.join(packageSrcPath, 'test-module-two'), path.join(packagesPath, 'test-module-two'))
    wrench.copyDirSyncRecursive(path.join(packageSrcPath, 'test-module-three'), path.join(packagesPath, 'test-module-three'))

    runs ->
      ppm.run(['disable', 'test-module-two', 'not-installed', 'test-module-three'], callback)

    waitsFor 'waiting for disable to complete', ->
      callback.callCount > 0

    runs ->
      expect(console.log).toHaveBeenCalled()
      expect(console.log.argsForCall[0][0]).toMatch /Not Installed:\s*not-installed/
      expect(console.log.argsForCall[1][0]).toMatch /Disabled:\s*test-module-two/

      config = CSON.readFileSync(configFilePath)
      expect(config).toEqual '*':
        core:
          disabledPackages: [
            "test-module"
            "test-module-two"
            "test-module-three"
          ]

  it 'does nothing if a package is already disabled', ->
    atomHome = temp.mkdirSync('ppm-home-dir-')
    process.env.ATOM_HOME = atomHome
    callback = jasmine.createSpy('callback')
    configFilePath = path.join(atomHome, 'config.cson')

    CSON.writeFileSync configFilePath, '*':
      core:
        disabledPackages: [
          "vim-mode"
          "file-icons"
          "metrics"
          "exception-reporting"
        ]

    runs ->
      ppm.run(['disable', 'vim-mode', 'metrics'], callback)

    waitsFor 'waiting for disable to complete', ->
      callback.callCount > 0

    runs ->
      config = CSON.readFileSync(configFilePath)
      expect(config).toEqual '*':
        core:
          disabledPackages: [
            "vim-mode"
            "file-icons"
            "metrics"
            "exception-reporting"
          ]

  it 'produces an error if config.cson doesn\'t exist', ->
    atomHome = temp.mkdirSync('ppm-home-dir-')
    process.env.ATOM_HOME = atomHome
    callback = jasmine.createSpy('callback')

    runs ->
      ppm.run(['disable', 'vim-mode'], callback)

    waitsFor 'waiting for disable to complete', ->
      callback.callCount > 0

    runs ->
      expect(console.error).toHaveBeenCalled()
      expect(console.error.argsForCall[0][0].length).toBeGreaterThan 0

  it 'complains if user supplies no packages', ->
    atomHome = temp.mkdirSync('ppm-home-dir-')
    process.env.ATOM_HOME = atomHome
    callback = jasmine.createSpy('callback')

    runs ->
      ppm.run(['disable'], callback)

    waitsFor 'waiting for disable to complete', ->
      callback.callCount > 0

    runs ->
      expect(console.error).toHaveBeenCalled()
      expect(console.error.argsForCall[0][0].length).toBeGreaterThan 0
