const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const outputDir = path.join(__dirname, 'build/')
const isProduction = process.env.NODE_ENV === 'production'

module.exports = {
  entry: './examples/Demo.bs.js',
  mode: isProduction ? 'production' : 'development',
  output: {
    path: outputDir,
    filename: 'App.bs.js'
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'examples/index.html',
      inject: false
    })
  ],
  optimization: {
    usedExports: true
  },
  devServer: {
    compress: true,
    contentBase: outputDir,
    port: process.env.PORT || 8000,
    historyApiFallback: true
  }
}
