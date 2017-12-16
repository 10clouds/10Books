import * as actionTypes from '../actionTypes/products';
import { makeReducer } from '../utils';

const defaultState = {
  byId: {},
  all: []
};

const reducers = {
  [actionTypes.ALL_UPDATED]: (state, {items}) => ({
    ...state,
    all: items,
    byId: items.reduce((all, item) => {
      all[item.id] = item;
      return all;
    }, {})
  }),

  [actionTypes.UPDATED]: (state, {id, attrs}) => {
    const updatedItem = {...state.byId[id], ...attrs}

    return {
      ...state,
      all: (
        state.byId[id]
          ? state.all.map(item => item.id === id ? updatedItem : item)
          : [updatedItem, ...state.all]
      ),
      byId: {
        ...state.byId,
        [id]: updatedItem
      }
    };
  },

  [actionTypes.DELETED]: (state, {id}) => {
    const newById = {...state.byId};
    delete newById[id];
    return {
      ...state,
      all: state.all.filter(item => item.id !== id),
      byId: newById}
    ;
  }
};

export default makeReducer(reducers, defaultState);
