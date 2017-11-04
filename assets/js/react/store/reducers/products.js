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
    all: products.reduce((map, product) => {
      map[product.id] = product;
      return map;
    }, {})
  }),

  [actions.PRODUCT_CHANGED]: (state, {productId, attrs}) => ({
    ...state,
    all: {
      ...state.all,
      [productId]: {
        ...state.all[productId],
        ...attrs
      }
    }
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
