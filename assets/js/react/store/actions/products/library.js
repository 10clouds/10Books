import * as actionTypes from '../../actionTypes/products/library';

export const takeProduct = id => (dispatch, getState) => {
  dispatch({
    type: actionTypes.TAKE,
    id
  });

  return new Promise((resolve, reject) => {
    getState().products.channel
      .push('take', { id })
      .receive('ok', resolve)
      .receive('error', reject)
  });
};


export const returnProduct = id => (dispatch, getState) => {
  dispatch({
    type: actionTypes.RETURN,
    id
  });

  return new Promise((resolve, reject) => {
    getState().products.channel
      .push('return', { id })
      .receive('ok', resolve)
      .receive('error', reject)
  });
};


export const rateProduct = (id, value) => (dispatch, getState) => {
  dispatch({
    type: actionTypes.RATE,
    id, value
  });

  return new Promise((resolve, reject) => {
    getState().products.channel
      .push('rate', { id, value })
      .receive('ok', resolve)
      .receive('error', reject)
  });
};
