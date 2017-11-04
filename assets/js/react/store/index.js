import { createStore, applyMiddleware, combineReducers } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';

import products from './reducers/products';

const rootReducer = combineReducers({
  products
});

const store = createStore(rootReducer, composeWithDevTools());

export default store;
