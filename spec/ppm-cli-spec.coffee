fs = require 'fs'
ppm = require '../lib/ppm-cli'

describe 'ppm command line interface', ->
  beforeEach ->
    silenceOutput()
    spyOnToken()

  describe 'when no arguments are present', ->
    it 'prints a usage message', ->
      ppm.run([])
      expect(console.log).not.toHaveBeenCalled()
      expect(console.error).toHaveBeenCalled()
      expect(console.error.argsForCall[0][0].length).toBeGreaterThan 0

  describe 'when the help flag is specified', ->
    it 'prints a usage message', ->
      ppm.run(['-h'])
      expect(console.log).not.toHaveBeenCalled()
      expect(console.error).toHaveBeenCalled()
      expect(console.error.argsForCall[0][0].length).toBeGreaterThan 0

  describe 'when the version flag is specified', ->
    it 'prints the version', ->
      callback = jasmine.createSpy('callback')
      ppm.run(['-v', '--no-color'], callback)

      waitsFor ->
        callback.callCount is 1

      runs ->
        expect(console.error).not.toHaveBeenCalled()
        expect(console.log).toHaveBeenCalled()
        lines = console.log.argsForCall[0][0].split('\n')
        expect(lines[0]).toBe "ppm  #{require('../package.json').version}"
        expect(lines[1]).toBe "npm  #{require('npm/package.json').version}"
        expect(lines[2]).toBe "node #{process.versions.node}"

  describe 'when an unrecognized command is specified', ->
    it 'prints an error message and exits', ->
      callback = jasmine.createSpy('callback')
      ppm.run(['this-will-never-be-a-command'], callback)
      expect(console.log).not.toHaveBeenCalled()
      expect(console.error).toHaveBeenCalled()
      expect(console.error.argsForCall[0][0].length).toBeGreaterThan 0
      expect(callback.mostRecentCall.args[0]).not.toBeUndefined()
