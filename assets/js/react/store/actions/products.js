import * as actions from '../actionTypes/products';

export const updateProducts = (products) => ({
  type: actions.PRODUCTS_CHANGED,
  products
});

export const updateCategories = (categories) => ({
  type: actions.CATEGORIES_CHANGED,
  categories
});

export const updateSearchString = (newSearchString) => ({
  type: actions.SEARCH_CHANGED,
  newSearchString
});
