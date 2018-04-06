const autoprefixer = require('autoprefixer');

module.exports = {
  plugins: [
    autoprefixer({
      remove: false,
      browsers: ['last 2 versions', '> 1%'],
    }),
  ],
};