import { createStore, applyMiddleware, combineReducers } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import { productsChannel } from 'socket';
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

productsChannel.on('product:updated', (data) => {
  store.dispatch(productsActions.updateProduct(data.id, data, false))
});

productsChannel
  .join()
  .receive('ok', (data) => {
    store.dispatch(productsActions.updateCategories(data.categories))
    store.dispatch(productsActions.updateProducts(data.products))
  })

export default store;
