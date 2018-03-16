import * as actionTypes from '../actionTypes/products'
import { makeReducer } from '../utils'

const defaultState = {
  channel: null,
  idsByInsertedAt: [],
  byId: {}
}

const getSortedIds = items => {
  return items
    .sort((a, b) => b.inserted_at - a.inserted_at)
    .map(({ id, inserted_at }) => ({ id, inserted_at }))
}

const reducers = {
  [actionTypes.JOIN_CHANNEL_SUCCESS]: (state, { channel }) => ({
    ...state,
    channel
  }),

  [actionTypes.ALL_UPDATED]: (state, { items }) => ({
    ...state,
    idsByInsertedAt: getSortedIds(items),
    byId: items.reduce((all, item) => {
      all[item.id] = item
      return all
    }, {})
  }),

  [actionTypes.UPDATED]: (state, { attrs }) => {
    const updatedItem = {...state.byId[attrs.id], ...attrs}

    return {
      ...state,
      idsByInsertedAt: (
        state.byId[attrs.id]
          ? state.idsByInsertedAt
          : getSortedIds([updatedItem, ...state.idsByInsertedAt])
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
    return {
      ...state,
      idsByInsertedAt: state.idsByInsertedAt.filter(item => item.id !== id),
      byId: newById
    }
  }
}

export default makeReducer(reducers, defaultState)
