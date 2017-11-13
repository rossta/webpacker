const { resolve, join } = require('path')
const { sync } = require('glob')
const assert = require('assert')

const Environment = require('../../package/environment')

describe('Environment', () => {
  let environment;

  describe('toWebpackConfig', () => {
    beforeEach(() => {
      environment = new Environment()
    })

    it('should return entry', () => {
      const config = environment.toWebpackConfig()
      assert.equal(config.entry.application, resolve('test', 'test_app', 'app', 'javascript', 'packs', 'application.js'))
    })

    it('should return output', () => {
      const config = environment.toWebpackConfig()
      assert.equal(config.output.filename, '[name]-[chunkhash].js')
      assert.equal(config.output.chunkFilename, '[name]-[chunkhash].chunk.js')
      assert.equal(config.output.path, resolve('test', 'test_app', 'public', 'packs'))
      assert.equal(config.output.publicPath, '/packs/')
    })

    it('should return default loader rules for each file in config/loaders', () => {
      const config = environment.toWebpackConfig()
      const loaders = sync(resolve('package', 'loaders', '*.js'))
      assert.equal(config.module.rules.length, loaders.length)
    })

    it('should return default plugins', () => {
      const config = environment.toWebpackConfig()
      assert.equal(config.plugins.length, 3)
    })

    it('should return default resolveLoader', () => {
      const config = environment.toWebpackConfig()
      assert.deepEqual(config.resolveLoader.modules, ['node_modules'])
    })
  })
})
