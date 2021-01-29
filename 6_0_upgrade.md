# To webpacker v6 from v5

This guide aims to help you migrating to webpacker 6. If you are using
vanilla webpacker install then hopefully, the upgrade should be really
straightforward.

## Preparation

1. If your `source_path` is `app/javascript`, rename it to `app/packs`
1. If your `source_entry_path` is `app/javascript/packs`, rename it to `app/packs/entrypoints`
1. Rename `config/webpack` to `config/webpack_old`
1. Rename `config/webpacker.yml` to `config/webpacker_old.yml`
1. Uninstall the current version of `webpack-dev-server`: `yarn remove webpack-dev-server`
1. Upgrade webpacker

  ```ruby
  # Gemfile
  gem 'webpacker', '~> 6.0.0.pre.2'
  ```

  ```bash
  bundle install
  ```

  ```bash
  yarn add @rails/webpacker@next
  ```

  ```bash
  bundle exec rails webpacker:install
  ```

- Change `javascript_pack_tag` and `stylesheet_pack_tag` to `javascript_packs_with_chunks_tag` and
  `stylesheet_packs_with_chunks_tag`

1. If you are using any integrations like `css`, `React` or `TypeScript`. Please see https://github.com/rails/webpacker#integrations section on how they work in v6.0.

1. Copy over any custom webpack config from `config/webpack_old`

  ```js
  // config/webpack/base.js
  const { webpackConfig, merge } = require('@rails/webpacker')
  const customConfig = require('./custom')

  module.exports = merge(webpackConfig, customConfig)
  ```

1. Review any settings you'd like to keep from `config/webpacker_old.yml` that changed in `config/webpacker.yml`. Note that the default `source_path` changes from `app/javascript` to `app/packs` and `source_entry_path` changes from `packs` to `entrypoints` so you'll need to update `webpacker.yml` or your directory structure accordingly.

1. Copy over custom browserlist config from `.browserlistrc` if it exists into the `"browserlist"` key in `package.json` and remove `.browserslistrc`.
