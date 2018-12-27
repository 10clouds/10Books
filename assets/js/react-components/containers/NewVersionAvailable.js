import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import config from 'config'
import MessageOverlay from '../components/MessageOverlay'
import cacheStorage from 'lib/cacheStorage'

const CANCELED_TODAY_STORAGE_KEY = 'new-version-banner:canceled-today'
const LATEST_VERSION_STORAGE_KEY = 'new-version-banner:latest-repo-version'
const ONE_DAY = 1000 * 60 * 60 * 24

class NewVersionAvailableBanner extends Component {
  static propTypes = {
    isAdmin: PropTypes.bool.isRequired
  }

  state = {
    isVisible: false,
    latestRepoVersion: null
  }

  componentDidMount() {
    const isCanceledToday = cacheStorage.getItem(CANCELED_TODAY_STORAGE_KEY)
    const cachedAppVersion = cacheStorage.getItem(LATEST_VERSION_STORAGE_KEY)

    if (!this.props.isAdmin || isCanceledToday) return

    if (cachedAppVersion) {
      this.handleReady(cachedAppVersion)
    } else {
      fetch(
        `https://api.github.com/repos/${config.get(
          'repo.name'
        )}/contents/mix.exs`
      )
        .then(res => res.json())
        .then(data => {
          const fileContent = atob(data.content)
          const fileVersion = /version: "([\d.]+)"/.exec(fileContent)[1]

          cacheStorage.setItem(LATEST_VERSION_STORAGE_KEY, fileVersion, ONE_DAY)
          this.handleReady(fileVersion)
        })
    }
  }

  handleReady = appVersion => {
    this.setState({
      isVisible: true,
      latestRepoVersion: appVersion
    })
  }

  handleCancel = () => {
    cacheStorage.setItem(CANCELED_TODAY_STORAGE_KEY, true, ONE_DAY)
    this.setState({ isVisible: false })
  }

  render() {
    const appVersion = config.get('appVersion')
    const { isVisible, latestRepoVersion } = this.state

    return isVisible && latestRepoVersion !== appVersion ? (
      <MessageOverlay onCancel={this.handleCancel}>
        <h2>New version is available!</h2>
        You're using version <b>{appVersion}</b>, while the newest one is{' '}
        <b>{latestRepoVersion}</b> Check out our{' '}
        <a
          href={config.get('repo.url') + '/blob/master/CHANGELOG.md'}
          target="_blank"
        >
          changelog
        </a>{' '}
        and follow{' '}
        <a href={config.get('repo.url') + 'wiki/Update-guide'} target="_blank">
          this guide
        </a>{' '}
        to update.
      </MessageOverlay>
    ) : (
      false
    )
  }
}

const mapStateToProps = ({ user: { is_admin } }) => ({
  isAdmin: is_admin
})

export default connect(mapStateToProps)(NewVersionAvailableBanner)
