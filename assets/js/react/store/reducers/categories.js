import * as actionTypes from '../actionTypes/categories'
import { makeReducer } from '../utils'

const defaultState = {
  channel: null,
  byId: {},
  all: []
}

const availableColors = [
  'rgba(235, 66, 136, 0.19)',
  'rgba(30, 207, 174, 0.19)',
  'rgba(113, 66, 235, 0.19)',
  'rgba(192, 215, 255, 0.52)'
]

let nextAvailableColorIndex = availableColors.length
function withColor(category) {
  if (category.color) {
    return category
  } else {
    nextAvailableColorIndex = nextAvailableColorIndex >= availableColors.length - 1
      ? 0
      : ++nextAvailableColorIndex
    return {...category, color: availableColors[nextAvailableColorIndex]}
  }
}

const reducers = {
  [actionTypes.JOIN_CHANNEL_SUCCESS]: (state, { channel }) => ({
    ...state,
    channel
  }),

  [actionTypes.ALL_UPDATED]: (state, { items }) => {
    const mappedItems = items.map(withColor)

    return {
      ...state,
      all: mappedItems,
      byId: mappedItems.reduce((all, item) => {
        all[item.id] = item
        return all
      }, {})
    }
  },

  [actionTypes.UPDATED]: (state, { attrs }) => {
    const updatedItem = withColor({...state.byId[attrs.id], ...attrs})

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
