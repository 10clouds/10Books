import * as actions from '../actionTypes/products';

export const updateList = (newList) => ({
  type: actions.LIST_CHANGED,
  newList
});

export const updateSearchString = (newSearchString) => ({
  type: actions.SEARCH_CHANGED,
  newSearchString
});
