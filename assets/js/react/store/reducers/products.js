import * as actions from '../actionTypes/products';
import { makeReducer } from '../utils';

const defaultState = {
  all: [],
  categories: [],
  searchString: ''
};

const reducers = {
  [actions.PRODUCTS_CHANGED]: (state, {products}) => ({
    ...state,
    all: products
  }),

  [actions.CATEGORIES_CHANGED]: (state, {categories}) => ({
    ...state,
    categories
  }),

  [actions.SEARCH_CHANGED]: (state, {newSearchString}) => ({
    ...state,
    searchString: newSearchString
  })
};

export default makeReducer(reducers, defaultState);
