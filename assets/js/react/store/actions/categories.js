import * as actionTypes from '../actionTypes/categories'
import socket from 'socket'

export const joinChannel = () => (dispatch, getState) => {
  dispatch({
    type: actionTypes.JOIN_CHANNEL
  })

  if (getState().categories.channel) {
    console.error('Already joined')
  } else {
    const channel = socket.channel('categories')

    channel.on('updated', item => {
      dispatch(updated(item))
    })

    channel.on('deleted', ({ id }) => {
      dispatch(deleted(id))
    })

    channel
    .join()
    .receive('ok', res => {
      dispatch(joinChannelSuccess(channel))
      dispatch(updateAll(res.payload))
    })
    .receive('error', resp => {
      console.error('Unable to join categories', resp)
    })
  }
}

export const joinChannelSuccess = channel => ({
  type: actionTypes.JOIN_CHANNEL_SUCCESS,
  channel
})

export const updateAll = items => ({
  type: actionTypes.ALL_UPDATED,
  items
})

export const updated = attrs => ({
  type: actionTypes.UPDATED,
  attrs
})

export const deleted = id => ({
  type: actionTypes.DELETED,
  id
})
