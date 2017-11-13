const { resolve } = require('path')
const root = process.env.RAILS_ROOT || '.';
const resolveRoot = (...args) => resolve(root, ...args)

module.exports = {
  root,
  resolveRoot
}
