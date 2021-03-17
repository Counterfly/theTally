// tailwind.config.js
// @see https://tailwindcss.com/docs/installation#3-create-your-tailwind-config-file-optional
module.exports = {
    purge: [ // purges only on production
        "../**/html.eex", // project dir then grab all html.eex files
        "../**/views/*.ex", // project dir then grab all views
        "./js/**.js", // assets dir then grab all .js files
    ],
    darkMode: false, // or 'media' or 'class'
    theme: {
    extend: {},
    },
    variants: {},
    plugins: [],
}