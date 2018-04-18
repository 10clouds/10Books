import * as actionTypes from '../actionTypes/categories'
import { makeReducer } from '../utils'

const defaultState = {
  channel: null,
  byId: {},
  all: []
}

const availableColors = [
  '#eb42bc',
  '#3c79e4',
  '#7142eb',
  '#fa732f',
  '#eb425f',
  '#fdad1f',
  '#13b596',
  '#36bbed',
  '#1ecf42',
  '#230ab4',
  '#434343',
  '#7c3761',
  '#3b6b54',
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
