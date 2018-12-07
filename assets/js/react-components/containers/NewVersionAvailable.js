import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import config from 'config'
import AlertOverlay from '../components/AlertOverlay'

class NewVersionAvailableBanner extends Component {
  static propTypes = {
    isAdmin: PropTypes.bool.isRequired
  }

  state = {
    isReady: false,
    latestRepoVersion: null
  }

  componentDidMount() {
    if (!this.props.isAdmin) return

    fetch(config.get('repo.mixFileUrl'))
      .then(res => res.json())
      .then(data => {
        const fileContent = atob(data.content)
        const fileVersion = /version: "([\d.]+)"/.exec(fileContent)[1]

        this.setState({
          isReady: true,
          latestRepoVersion: fileVersion
        })
      })
  }

  render() {
    const appVersion = config.get('appVersion')
    const { isReady, latestRepoVersion } = this.state

    return isReady ? (
      <AlertOverlay>
        New version is available! <br />
        You're using version <b>{appVersion}</b>, while the newest one is{' '}
        <b>{latestRepoVersion}</b> Check out our{' '}
        <a href={config.get('repo.changelogUrl')} target="_blank">
          changelog
        </a>{' '}
        and follow{' '}
        <a href={config.get('repo.updateGuideUrl')} target="_blank">
          this guide
        </a>{' '}
        to update.
      </AlertOverlay>
    ) : (
      false
    )
  }
}

const mapStateToProps = ({ user: { is_admin } }) => ({
  isAdmin: is_admin
})

export default connect(mapStateToProps)(NewVersionAvailableBanner)
