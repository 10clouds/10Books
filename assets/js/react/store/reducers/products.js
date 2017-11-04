import * as actions from '../actionTypes/products';
import { makeReducer } from '../utils';

const defaultState = {
  list: [],
  searchString: ''
};

const reducers = {
  [actions.LIST_CHANGED]: (state, {newList}) => ({
    ...state,
    list: newList
  }),

  [actions.SEARCH_CHANGED]: (state, {newSearchString}) => ({
    ...state,
    searchString: newSearchString
  })
};

export default makeReducer(reducers, defaultState);
