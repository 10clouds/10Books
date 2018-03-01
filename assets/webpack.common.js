const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: {
    '/js/app.js': './js/app.js',
    '/css/app.css': './scss/app.scss'
  },
  output: {
    path: path.resolve(__dirname, '../priv/static'),
    filename: "[name]"
  },
  resolve: {
    modules: [
      path.resolve(__dirname, 'js'),
      'node_modules'
    ]
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: [/node_modules/],
        use: [{
          loader: 'babel-loader',
          options: {
            babelrc: false,
            presets: [
              "@babel/preset-env",
              "@babel/preset-stage-2",
              "@babel/preset-react"
            ]
          },
        }],
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          use: ['css-loader', 'sass-loader']
        })
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin('css/app.css'),
    new CopyWebpackPlugin([
      {
        from: 'node_modules/font-awesome/fonts',
        to: path.resolve(__dirname, '../priv/static/fonts/font-awesome')
      }
    ]),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      Popper: ['popper.js', 'default']
    })
  ]
};
