import * as actionTypes from '../../actionTypes/products';
import socket from 'socket';

export const joinChannel = room => (dispatch, getState) => {
  dispatch({
    type: actionTypes.JOIN_CHANNEL,
    room
  });

  if (getState().products.channel) {
    console.error('Already joined');
  } else {
    const channel = socket.channel(`products:${room}`);

    channel.on('updated', item => {
      dispatch(updated(item))
    });

    channel.on('deleted', ({ id }) => {
      dispatch(deleted(id))
    });

    channel
    .join()
    .receive('ok', res => {
      dispatch(joinChannelSuccess(channel));
      dispatch(updateAll(res.payload));
    })
    .receive('error', resp => {
      console.error("Unable to join products:all", resp)
    });
  }
}


export const joinChannelSuccess = channel => ({
  type: actionTypes.JOIN_CHANNEL_SUCCESS,
  channel
});


export const updateAll = items => ({
  type: actionTypes.ALL_UPDATED,
  items
});

// TODO:
// This will be removed once we'll get rid from category
// select on every table
export const update = (id, attrs) => (dispatch, getState) => {
  dispatch({
    type: actionTypes.UPDATE,
    id, attrs
  });

  return new Promise((resolve, reject) => {
    getState().products.channel
      .push('update', { id, attrs })
      .receive('ok', resolve)
      .receive('error', reject)
  });
};


export const updated = attrs => ({
  type: actionTypes.UPDATED,
  attrs
});


export const deleted = id => ({
  type: actionTypes.DELETED,
  id
});
