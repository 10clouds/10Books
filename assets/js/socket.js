import { Socket } from 'phoenix';

const socket = new Socket('/socket', {
  params: {
    token: window.currentUserToken
  }
});

socket.connect();

export const productsChannel = socket.channel('products:all');
