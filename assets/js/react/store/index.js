import { createStore, applyMiddleware, combineReducers } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import socket from 'socket';
import socketMiddleware from './middlewares/socket';
import products from './reducers/products';
import * as productsActions from './actions/products';

const store = createStore(
  combineReducers({
    products
  }),
  composeWithDevTools(
    applyMiddleware(socketMiddleware)
  )
);

// TODO: Move to separate file
const channel = socket.channel('products:all');
channel
  .join()
  .receive('ok', (data) => {
    store.dispatch(productsActions.updateCategories(data.categories))
  })

export default store;
