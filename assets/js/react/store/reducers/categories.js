import * as actionTypes from '../actionTypes/categories';
import { makeReducer } from '../utils';

const defaultState = {
  channel: null,
  byId: {}
};

const reducers = {
  [actionTypes.JOIN_CHANNEL_SUCCESS]: (state, { channel }) => ({
    ...state,
    channel
  }),

  [actionTypes.ALL_UPDATED]: (state, { items }) => ({
    ...state,
    byId: items.reduce((all, item) => {
      all[item.id] = item;
      return all;
    }, {})
  }),

  [actionTypes.UPDATED]: (state, { attrs }) => {
    return {
      ...state,
      byId: {
        ...state.byId,
        [attrs.id]: {...state.byId[attrs.id], ...attrs}
      }
    };
  },

  [actionTypes.DELETED]: (state, { id }) => {
    const newById = {...state.byId};
    delete newById[id];
    return {...state, byId: newById};
  }
};

export default makeReducer(reducers, defaultState);
