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
  const adminDropdown = document.getElementById('admin-dropdown')
  const adminDropdownButton = document.getElementById('admin-dropdown-button')
  const adminDropdownMenu = document.getElementById('admin-dropdown-menu')
  
  hamburgerButton.addEventListener('click', () => {
    hamburgerButton.classList.toggle('collapsed')
    hamburgerMenu.classList.toggle('navbar__menu--visible')
  })

  adminDropdownButton.addEventListener('click', (e) => {
    e.preventDefault()
    adminDropdownButton.classList.toggle('collapsed')
    adminDropdownMenu.classList.toggle('navbar__menu-dropdown--visible')
  })

  adminDropdown.addEventListener('mouseenter', () => {
    if(window.innerWidth >= 839){
      adminMenuShow()
    }
  })

  adminDropdown.addEventListener('mouseleave', (e) => {
    if(window.innerWidth >= 839){
      adminMenuHide()
    }
  })

  function adminMenuShow() {
    adminDropdown.classList.add('collapsed')
    adminDropdownMenu.classList.add('navbar__menu-dropdown--visible')
  }

  function adminMenuHide() {
    adminDropdown.classList.remove('collapsed')
    adminDropdownMenu.classList.remove('navbar__menu-dropdown--visible')
  }
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
