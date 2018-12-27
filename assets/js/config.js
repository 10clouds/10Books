import get from 'lodash/get'
import merge from 'lodash/merge'

const githubRepo = 'ruslansavenok/app_version_check'

const config = merge(
  {
    repo: {
      name: githubRepo,
      url: `https://github.com/${githubRepo}`
    }
  },
  window.LibTen.config
)

export default {
  get: key => {
    const value = get(config, key)

    if (value === undefined) {
      throw new Error(`Uknown config option ${key}`)
    }

    return value
  }
}
