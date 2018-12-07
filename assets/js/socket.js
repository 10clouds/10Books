import { Socket } from 'phoenix'
import config from 'config'

export default new Socket('/socket', {
  params: {
    token: config.get('socketToken')
  }
})
