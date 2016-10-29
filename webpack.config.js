module.exports = {
    entry: './src/static/index.js',
    output: {
        path: './build',
        publicPath: '/assets/',
        filename: 'webpack-bundle.js'
    },
    module: {
        loaders: [
            {
                test:    /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader:  'elm-webpack?verbose=true&warn=true',
            }
        ]
    },
    resolve: {
        extensions: ['', '.js', '.elm']
    },
    devServer: {
        inline: true
    }
};

