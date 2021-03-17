const purgecss = require("@fullhuman/postcss-purgecss")({
    content: [
        "../**/html.eex", // project dir then grab all html.eex files
        "../**/views/*.ex", // project dir then grab all views
        "./js/**.js", // assets dir then grab all .js files
    ],
    defaultExtractor: content => content.match(/[\w-/:]*(?<!:)/g) || []
})

module.exports = {
    plugins: [
        require("postcss-import"),
        require("tailwindcss")('./tailwind.config.js'),
        require("autoprefixer"),
        // only purgecss if in production (for slim)
        // otherwise keep all so we can hot-reload
        ...(process.env.NODE_ENV == "production" ? purgecss : [])
    ]
}
