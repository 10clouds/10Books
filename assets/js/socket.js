import { Socket } from 'phoenix';

const socket = new Socket('/socket', {
  params: {
    token: window.currentUserToken
  }
});

socket.connect();
console.log('connect');

export default socket;
