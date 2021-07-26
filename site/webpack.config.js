const path = require('path')
const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const TerserPlugin = require('terser-webpack-plugin')
const InlineChunkHtmlPlugin = require('react-dev-utils/InlineChunkHtmlPlugin')
// const PrerenderSPAPlugin = require('prerender-spa-plugin')
// const Renderer = PrerenderSPAPlugin.PuppeteerRenderer

/**
 * Webpack configuration.
 *
 * @see https://webpack.js.org/configuration/
 * @param {Record<string, boolean> | undefined} envName
 * @param {{ mode: "production" | "development" }} options
 * @returns {import("webpack").Configuration}
 */
module.exports = function config(env, options) {
  const isEnvProduction = options.mode === 'production'
  const isEnvDevelopment = options.mode === 'development'
  const isDevServer = isEnvDevelopment && process.argv.includes('serve')
  const isEnvProductionProfile =
    isEnvProduction && process.argv.includes('--profile')

  const appConfig = {
    name: 'app',
    mode: isEnvProduction ? 'production' : 'development',
    target: isDevServer ? 'web' : 'browserslist',
    bail: isEnvProduction,
    entry: './src/client',
    devtool: isDevServer ? 'inline-source-map' : undefined,
    /* SPDX-FileCopyrightText: 2014-present Kriasoft <hello@kriasoft.com> */
    /* SPDX-License-Identifier: MIT */
    optimization: {
      minimize: isEnvProduction,
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            parse: { ecma: 8 },
            compress: {
              ecma: 5,
              warnings: false,
              comparisons: false,
              inline: 2,
            },
            mangle: { safari10: true },
            keep_classnames: isEnvProductionProfile,
            keep_fnames: isEnvProductionProfile,
            output: { ecma: 5, comments: false, ascii_only: true },
          },
        }),
      ],
    },
    module: {
      rules: [
        {
          test: /\.html$/i,
          loader: 'html-loader',
        },
        {
          test: [/\.bmp$/, /\.gif$/, /\.jpe?g$/, /\.png$/],
          loader: require.resolve('url-loader'),
        },
        {
          test: /\.(js|mjs|ts|tsx)$/,
          include: path.resolve(__dirname, './src'),
          loader: 'babel-loader',
        },
        {
          test: /\.s[ac]ss$/i,
          use: [
            // Creates `style` nodes from JS strings
            'style-loader',
            // Translates CSS into CommonJS
            'css-loader',
            // Compiles Sass to CSS
            'sass-loader',
          ],
        },
      ],
    },
    output: {
      filename: 'client-bundle.js',
      path: path.resolve(__dirname, 'dist'),
      publicPath: '/',
    },
    plugins: [
      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(
          isEnvProduction ? 'production' : 'development'
        ),
      }),
      isDevServer && new webpack.HotModuleReplacementPlugin(),
      new HtmlWebpackPlugin({
        template: path.resolve(__dirname, './src/index.html'),
      }),
      // does not work in dev-server
      isEnvProduction &&
        new InlineChunkHtmlPlugin(HtmlWebpackPlugin, [/client-bundle/]),
      // isEnvProduction &&
      //   new PrerenderSPAPlugin({
      //     staticDir: path.join(__dirname, 'dist'),
      //     routes: ['/'],
      //     renderer: new Renderer({
      //       headless: true,
      //       renderAfterTime: 5000,
      //     }),
      //   }),
    ].filter(Boolean),
  }

  /**
   * Development server that provides live reloading.
   *
   * @see https://webpack.js.org/configuration/dev-server/
   * @type {import("webpack-dev-server").Configuration}
   */
  const devServer = {
    port: 3000,
    hot: true,
    inline: true,
    contentBase: path.resolve(__dirname, 'dist'),
  }

  return isDevServer ? { ...appConfig, devServer } : [appConfig]
}
