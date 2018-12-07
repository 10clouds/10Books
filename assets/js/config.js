import get from 'lodash/get'

export default {
  get: key => get(window.LibTen.config, key)
}
