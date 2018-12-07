import * as actionTypes from '../../actionTypes/products/orders'

export const upvote = id => (dispatch, getState) => {
  dispatch({
    type: actionTypes.UPVOTE,
    id
  })

  return new Promise((resolve, reject) => {
    getState()
      .products.channel.push('upvote', { id })
      .receive('ok', resolve)
      .receive('error', reject)
  })
}

export const downvote = id => (dispatch, getState) => {
  dispatch({
    type: actionTypes.DOWNVOTE,
    id
  })

  return new Promise((resolve, reject) => {
    getState()
      .products.channel.push('downvote', { id })
      .receive('ok', resolve)
      .receive('error', reject)
  })
}
