import * as actionTypes from '../actionTypes/search'
import { makeReducer } from '../utils'

const defaultState = {
  queryString: ''
}

const reducers = {
  [actionTypes.QUERY_CHANGED]: (state, { queryString }) => ({
    ...state,
    queryString
  })
}

export default makeReducer(reducers, defaultState)
