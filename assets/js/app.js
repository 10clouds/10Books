import 'phoenix_html'
import 'bootstrap' // TODO: Import only stuff we actually need
import React from 'react'
import ReactDOM from 'react-dom'
import store from 'react/store'
import { Provider } from 'react-redux'
import { setUser } from '~/store/actions/user'
import { Library, Orders, All } from '~/containers/pages'

function render(component, domNode) {
  ReactDOM.render(
    <Provider store={store} children={component} />,
    domNode
  )
}

window.LibTen = {
  ReactComponents: {
    renderLibrary(domNode, currentUser) {
      store.dispatch(setUser(currentUser))
      render(<Library />, domNode)
    },
    renderOrders(domNode, currentUser) {
      store.dispatch(setUser(currentUser))
      render(<Orders />, domNode)
    },
    renderAll(domNode, currentUser) {
      store.dispatch(setUser(currentUser))
      render(<All />, domNode)
    }
  }
}
