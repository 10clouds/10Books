import * as actionTypes from '../actionTypes/search'
import { makeReducer } from '../utils'

const defaultState = {
  queryString: '',
  filterByCategoryId: null
}

const reducers = {
  [actionTypes.QUERY_CHANGED]: (state, { key, value }) => {
    if (!state.hasOwnProperty(key)) {
      throw new Error(`Unknow key ${key}`)
    }

    return {
      ...state,
      [key]: value
    }
  }
}

export default makeReducer(reducers, defaultState)
