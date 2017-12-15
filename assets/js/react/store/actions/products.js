import * as actionTypes from '../actionTypes/products';

export const updateAll = (items) => ({
  type: actionTypes.ALL_UPDATED,
  items
});

export const update = (id, attrs) => ({
  type: actionTypes.UPDATED,
  id, attrs
});

export const remove = (id) => ({
  type: actionTypes.DELETED,
  id
});

export const take = (id) => ({
  type: actionTypes.TAKEN,
  id
});

export const returnProduct = (id) => ({
  type: actionTypes.RETURNED,
  id
});
