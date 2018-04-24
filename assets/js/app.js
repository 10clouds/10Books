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
  const navbarBreakPoint = 839
  const hamburgerButton = document.getElementById('hamburger-button')
  const hamburgerMenu = document.getElementById('hamburger-menu')
  const adminDropdown = document.getElementById('admin-dropdown')
  const adminDropdownButton = document.getElementById('admin-dropdown-button')
  const adminDropdownMenu = document.getElementById('admin-dropdown-menu')
  const alerts = Array.from(document.querySelectorAll('.alert'))

  hamburgerButton.addEventListener('click', () => {
    hamburgerButton.classList.toggle('collapsed')
    hamburgerMenu.classList.toggle('navbar__menu--visible')
  })
  
  adminDropdownButton.addEventListener('click', e => {
    e.preventDefault()
    if(window.innerWidth >= navbarBreakPoint) return
    adminDropdownButton.classList.toggle('collapsed')
    adminDropdownMenu.classList.toggle('navbar__menu-dropdown--visible')
  })

  adminDropdown.addEventListener('mouseenter', () => {
    if(window.innerWidth >= navbarBreakPoint){
      adminMenuShow()
    }
  })

  adminDropdown.addEventListener('mouseleave', () => {
    if(window.innerWidth >= navbarBreakPoint){
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

  alerts.forEach(alert => {
    alert.innerText ? alert.classList.remove('alert--hidden') : alert.classList.add('alert--hidden')
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
