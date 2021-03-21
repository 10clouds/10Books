import * as actionTypes from '../../actionTypes/products/admin'

export const forceReturnProduct = id => (dispatch, getState) => {
  dispatch({
    type: actionTypes.FORCE_RETURN,
    id
  })

  return new Promise((resolve, reject) => {
    getState()
      .products.channel.push('force_return', { id: id })
      .receive('ok', resolve)
      .receive('error', reject)
  })
}
