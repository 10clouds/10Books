import { createStore, applyMiddleware, combineReducers } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import { bindSocketEvents } from './socketEvents';
import socketSyncMiddleware from './middlewares/socket_sync';
import search from './reducers/search';
import categories from './reducers/categories';
import products from './reducers/products';

const store = createStore(
  combineReducers({
    search,
    categories,
    products
  }),
  composeWithDevTools(
    applyMiddleware(socketSyncMiddleware)
  )
);

bindSocketEvents(store);

export default store;
