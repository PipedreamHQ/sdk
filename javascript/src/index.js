// TODO currently not used... this adds a lot to browser bundle
// const crypto = require("crypto")

const axios = require("axios")

const integrations = require("./integrations")

const {
  // PD_SECRET_KEY,
  PD_SDK_HOST = "sdk.m.pipedream.net",
  PD_SDK_PROTO = "https",
} = process.env

function Pipedream() {
  const SDK_VERSION = "0.3.2" // TODO can release-it write to here as well? or bake it in from package.json
  const PAYLOAD_VERSION = "1"
  let activeIntegration = null
  // const secretKey = PD_SECRET_KEY

  // TODO have node use a persistent HTTP client
  this.sendEvent = async function(apiKey, raw_event, opts) {
    if (!opts) opts = {}
    const event = opts.exports || {}
    event.raw_event = raw_event
    const uri = `${PD_SDK_PROTO}://${PD_SDK_HOST}/pipelines/${apiKey}/events`

    const payload = JSON.stringify(event)
    const headers = {
      "content-type": "application/json",
      "x-pd-sdk-version": SDK_VERSION,
    }
    // Don't set headers considered unsafe in browser
    if (!process.browser) {
      headers["user-agent"] = "pdsdk:javascript/1"
    }
    if (opts.client) headers["x-pd-sdk-client"] = opts.client
    if (activeIntegration) headers["x-pd-sdk-integration"] = activeIntegration
    // if (secretKey) {
    //   const sig = crypto.createHmac("sha256", secretKey).update(payload).digest("hex")
    //   headers["x-pd-sig"] = `sha256=${sig}`
    // }
    const config = {
      url: uri,
      method: "post",
      headers,
      data: payload,
    }
    return await axios.request(config)
  }

  // determine active integration
  if (process.browser) {
    integrations.browser.initialize(this)
    activeIntegration = "browser"
  } else {
    // things to only do in node context
    this.loadMetadata = function(metadataPath, mergeData) {
      const cp = require("child_process")
      function execSync(cmd) {
        try {
          return String(cp.execSync(cmd)).trim()
        } catch (err) {
          console.error(err)
        }
      }
      let metadata = {}
      try {
        metadata = JSON.parse(require("fs").readFileSync(metadataPath))
      } catch (err) {
        // assume the service is not METADATA'ed, hence LOCAL development (XXX handle failure here better)
        metadata.branch = execSync("git rev-parse --abbrev-ref HEAD")
        metadata.git_ref = execSync("git rev-parse HEAD")
      }
      metadata.environment = process.env.NODE_ENV || "development"
      metadata.pdsdk_version = SDK_VERSION
      metadata.started_at = new Date/1000
      metadata.name = process.env.PD_METADATA_NAME || execSync("hostname")
      for (const k in mergeData) metadata[k] = mergeData[k] // XXX not deep
      return metadata
    }
  }

  this.initialized = true // do this earlier? it's for browser sdk, maybe use this in ruby too?
}

module.exports = new Pipedream()
