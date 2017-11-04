import * as actions from '../actionTypes/products';

export const updateProducts = (products) => ({
  type: actions.PRODUCTS_CHANGED,
  products
});

export const updateProduct = (productId, attrs, notifySocket = true) => ({
  type: actions.PRODUCT_CHANGED,
  notifySocket,
  productId,
  attrs
});

export const updateCategories = (categories) => ({
  type: actions.CATEGORIES_CHANGED,
  categories
});

export const updateSearchString = (newSearchString) => ({
  type: actions.SEARCH_CHANGED,
  newSearchString
});
