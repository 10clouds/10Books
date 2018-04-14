import 'phoenix_html'
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

document.addEventListener('DOMContentLoaded', () => { 
  const hamburgerButton = document.getElementById('hamburger-button')
  const hamburgerMenu = document.getElementById('hamburger-menu')
  const adminDropdownButton = document.getElementById('admin-dropdown-button')
  const adminDropdownMenu = document.getElementById('admin-dropdown-menu')
  
  hamburgerButton.addEventListener('click', () => {
    hamburgerButton.classList.toggle('collapsed')
    hamburgerMenu.classList.toggle('navbar__menu--visible')
  })
  
  adminDropdownButton.addEventListener('click', e => {
    e.preventDefault()
    adminDropdownButton.classList.toggle('collapsed')
    adminDropdownMenu.classList.toggle('navbar__menu-dropdown--visible')
  })
})
  
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
