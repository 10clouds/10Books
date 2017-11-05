import * as actionTypes from '../actionTypes/search';

export const updateQuery = (queryString) => ({
  type: actionTypes.QUERY_CHANGED,
  queryString
});
