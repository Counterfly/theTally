// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

/**
 * Define custom hooks.
 */
let Hooks = {}
Hooks.PlayerName = {
  mounted() {
    this.el.addEventListener("input", e => {
      console.log("IN PlayerName hook!!!!")
      let inputName = grabText(this.el)
      this.el.value = inputName
      this.pushEvent("search_player", {name: inputName})
    })
  }
}
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


// custom js
/**
 * 
 */
 function grabText(element) {
  const $inputElement = document.getElementById(element.dataset["inputid"]);
  if ($inputElement === null) {
    console.log(`grabText failed on element ${element}`);
    return
  }

  console.log(`input element text = ${$inputElement.value}`);
  console.log($inputElement);
  return $inputElement.value;
 }

 window.grabText = grabText;