exports.initialize = function(pdsdk) {
  const snippetPdsdk = window.pdsdk
  if (snippetPdsdk) {
    for (const [method, event, options] of snippetPdsdk.buffered) {
      pdsdk[method](event, options)
    }
  }
}
