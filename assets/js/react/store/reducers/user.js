import * as actionTypes from '../actionTypes/user'
import { makeReducer } from '../utils'

const defaultState = {
  id: null,
  is_admin: false
}

const reducers = {
  [actionTypes.SET_USER]: (state, {user}) => ({
    ...state,
    ...user
  })
}

export default makeReducer(reducers, defaultState)
