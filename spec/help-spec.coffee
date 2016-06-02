ppm = require '../lib/ppm-cli'

describe 'command help', ->
  beforeEach ->
    spyOnToken()
    silenceOutput()

  describe "ppm help publish", ->
    it "displays the help for the command", ->
      callback = jasmine.createSpy('callback')
      ppm.run(['help', 'publish'], callback)

      waitsFor 'waiting for help to complete', 60000, ->
        callback.callCount is 1

      runs ->
        expect(console.error.callCount).toBeGreaterThan 0
        expect(callback.mostRecentCall.args[0]).toBeUndefined()

  describe "ppm publish -h", ->
    it "displays the help for the command", ->
      callback = jasmine.createSpy('callback')
      ppm.run(['publish', '-h'], callback)

      waitsFor 'waiting for help to complete', 60000, ->
        callback.callCount is 1

      runs ->
        expect(console.error.callCount).toBeGreaterThan 0
        expect(callback.mostRecentCall.args[0]).toBeUndefined()

  describe "ppm help", ->
    it "displays the help for ppm", ->
      callback = jasmine.createSpy('callback')
      ppm.run(['help'], callback)

      waitsFor 'waiting for help to complete', 60000, ->
        callback.callCount is 1

      runs ->
        expect(console.error.callCount).toBeGreaterThan 0
        expect(callback.mostRecentCall.args[0]).toBeUndefined()

  describe "ppm", ->
    it "displays the help for ppm", ->
      callback = jasmine.createSpy('callback')
      ppm.run([], callback)

      waitsFor 'waiting for help to complete', 60000, ->
        callback.callCount is 1

      runs ->
        expect(console.error.callCount).toBeGreaterThan 0
        expect(callback.mostRecentCall.args[0]).toBeUndefined()
