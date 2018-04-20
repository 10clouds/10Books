import * as actionTypes from '../actionTypes/categories'
import { makeReducer } from '../utils'

const defaultState = {
  channel: null,
  byId: {},
  all: []
}

const availableColors = [
  {
    text: '#eb42bc',
    background: '#fbdbf2',
  },
  {
    text: '#3c79e4',
    background: '#deeaff',
  },
  {
    text: '#7142eb',
    background: '#e4dbfb',
  },
  {
    text: '#fa732f',
    background: '#fbe7db',
  },
  {
    text: '#eb425f',
    background: '#fbdbe5',
  },
  {
    text: '#fdad1f',
    background: '#fbf3db',
  },
  {
    text: '#13b596',
    background: '#d4f5ef',
  },
  {
    text: '#36bbed',
    background: '#defeff',
  },
  {
    text: '#1ecf42',
    background: '#def5d4',
  },
  {
    text: '#230ab4',
    background: '#d5d0f0',
  },
  {
    text: '#434343',
    background: '#cfcdd5',
  },
  {
    text: '#7c3761',
    background: '#dbbdd0',
  },
  {
    text: '#3b6b54',
    background: '#bfd7cb',
  },
]

let nextAvailableColorIndex = availableColors.length

function withColor(category) {
  if (category.color) {
    return category
  } else {
    nextAvailableColorIndex = nextAvailableColorIndex >= availableColors.length - 1
      ? 0
      : ++nextAvailableColorIndex
    return { ...category, color: availableColors[nextAvailableColorIndex] }
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
    const updatedItem = withColor({ ...state.byId[attrs.id], ...attrs })

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
    const newById = { ...state.byId }
    delete newById[id]
    return { ...state, byId: newById }
  }
}

export default makeReducer(reducers, defaultState)
