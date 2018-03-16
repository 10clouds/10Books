import * as actionTypes from '../../actionTypes/products/all'

export const create = attrs => (dispatch, getState) => {
  dispatch({
    type: actionTypes.CREATE,
    attrs
  })

  return new Promise((resolve, reject) => {
    getState().products.channel
      .push('create', { attrs })
      .receive('ok', resolve)
      .receive('error', reject)
  })
}


export const update = (id, attrs) => (dispatch, getState) => {
  dispatch({
    type: actionTypes.UPDATE,
    id, attrs
  })

  return new Promise((resolve, reject) => {
    getState().products.channel
      .push('update', { id, attrs })
      .receive('ok', resolve)
      .receive('error', reject)
  })
}
