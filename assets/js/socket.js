import { Socket } from 'phoenix';

const socket = new Socket('/socket', {
  params: {
    token: window.currentUserToken
  }
});

if (window.currentUserToken) {
  socket.connect();
}

export const productsChannel = socket.channel('products');
export const categoriesChannel = socket.channel('categories');
