import * as actionTypes from '../actionTypes/search'

export const updateQuery = (key, value) => ({
  type: actionTypes.QUERY_CHANGED,
  key,
  value
})
