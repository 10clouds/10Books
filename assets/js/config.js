import get from 'lodash/get'
import merge from 'lodash/merge'

const githubRepo = 'ruslansavenok/app_version_check'

const config = merge(
  {
    repo: {
      mixFileUrl: `https://api.github.com/repos/${githubRepo}/contents/mix.exs`,
      changelogUrl: `https://github.com/${githubRepo}/blob/master/CHANGELOG.md`,
      updateGuideUrl: 'https://github.com/10clouds/10Books/wiki/Update-guide'
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
