import * as actionTypes from '../actionTypes/categories';

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
