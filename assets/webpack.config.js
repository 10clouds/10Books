const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const isProd = process.env.NODE_ENV === "production";

module.exports = {
  mode: isProd ? 'production' : 'development',
  devtool: 'source-map',
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
    ],
    alias: {
      '~config': path.resolve(__dirname, 'js/config.js'),
      '~': path.resolve(__dirname, 'js/react'),
      '/static': path.resolve(__dirname, 'static')
    }
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
          use: [
            {
              loader: "css-loader",
              options: {
                sourceMap: true,
                minimize: isProd
              }
            },
            'postcss-loader?sourceMap',
            'sass-loader?sourceMap'
          ]
        })
      },
      {
        test: /\.svg$/,
        use: 'raw-loader'
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin('css/app.css'),
    new CopyWebpackPlugin([{
      from: "./static",
      to: path.resolve(__dirname, "../priv/static")
    }])
  ]
};
