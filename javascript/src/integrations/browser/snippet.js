(function() {
  var pdsdk = window.pdsdk = window.pdsdk || []

  if (pdsdk.initialized) return

  if (pdsdk.invoked) {
    if (window.console && console.error) {
      console.error("pdsdk snippet included multiple times")
      return
    }
  }

  pdsdk.invoked = true

  // buffer calls to methods
  pdsdk.methods = [
    "sendEvent",
  ]
  pdsdk.buffered = []
  pdsdk.makeBufferMethod = function(method) {
    return function() {
      var args = Array.prototype.slice.call(arguments)
      args.unshift(method)
      pdsdk.buffered.push(args)
    }
  }
  for (var i = 0; i < pdsdk.methods.length; i++) {
    var method = pdsdk.methods[i]
    pdsdk[method] = pdsdk.makeBufferMethod(method)
  }

  pdsdk.load = function(src) { // optional src arg used for testing
    var script = document.createElement("script")
    script.type = "text/javascript"
    script.async = true
    script.src = src || "https://sdk.pipedream.net/pdsdk.min.js?n=" + Math.random()
    var first = document.getElementsByTagName('script')[0]
    first.parentNode.insertBefore(script, first)
  }

  pdsdk.SNIPPET_VERSION = "0.3.2" // TODO can release-it write to here as well? or bake it in from package.json
})()
