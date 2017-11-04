import { createStore, applyMiddleware, combineReducers } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';

import products from './reducers/products';

if (!window.store) {
  const rootReducer = combineReducers({
    products
  });
  window.store = createStore(rootReducer, composeWithDevTools());
}

export default window.store;
