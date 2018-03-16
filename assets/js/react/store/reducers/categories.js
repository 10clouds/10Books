import * as actionTypes from '../actionTypes/categories'
import { makeReducer } from '../utils'

const defaultState = {
  channel: null,
  byId: {},
  all: []
}

const reducers = {
  [actionTypes.JOIN_CHANNEL_SUCCESS]: (state, { channel }) => ({
    ...state,
    channel
  }),

  [actionTypes.ALL_UPDATED]: (state, { items }) => ({
    ...state,
    all: items,
    byId: items.reduce((all, item) => {
      all[item.id] = item
      return all
    }, {})
  }),

  [actionTypes.UPDATED]: (state, { attrs }) => {
    const updatedItem = {...state.byId[attrs.id], ...attrs}

    return {
      ...state,
      all: (
        state.byId[attrs.id]
          ? state.all.map(item => item.id === attrs.id ? updatedItem : item)
          : [updatedItem, ...state.all]
      ),
      byId: {
        ...state.byId,
        [attrs.id]: updatedItem
      }
    }
  },

  [actionTypes.DELETED]: (state, { id }) => {
    const newById = {...state.byId}
    delete newById[id]
    return {...state, byId: newById}
  }
}

export default makeReducer(reducers, defaultState)
