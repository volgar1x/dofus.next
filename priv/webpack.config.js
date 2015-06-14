module.exports = {
    context: __dirname + "/src",
    entry: "./index",
    output: {
        path: __dirname + "/static",
        filename: "bundle.js"
    },
    module: {
        loaders: [
            {test: /\.js$/, exclude: /node_modules/, loader: 'babel?stage=0'}
        ]
    }
};
