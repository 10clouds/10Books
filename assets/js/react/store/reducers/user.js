import config from '~config'
import { makeReducer } from '../utils'

const defaultState = config.get('currentUser')

export default makeReducer({}, defaultState)
