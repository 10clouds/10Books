import { createStore, applyMiddleware, combineReducers } from 'redux'
import thunk from 'redux-thunk'
import { composeWithDevTools } from 'redux-devtools-extension'
import search from './reducers/search'
import categories from './reducers/categories'
import products from './reducers/products'
import user from './reducers/user'

const store = createStore(
  combineReducers({
    search,
    categories,
    products,
    user
  }),
  composeWithDevTools(
    applyMiddleware(thunk)
  )
)

export default store
