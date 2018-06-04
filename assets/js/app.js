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


function toggleHeight(el, isVisible = true) {
  if (el.clientHeight === 0 && isVisible) {
    el.style.maxHeight = 'auto'
    el.style.maxHeight = `${el.scrollHeight}px`
  } else {
    el.style.maxHeight = `0px`
  }
}


document.addEventListener('DOMContentLoaded', () => {
  const navbarMenuToggler = document.getElementById('js-navbar-menu-toggle-btn')
  const navbarMenu = document.getElementById('js-navbar-menu')
  const navbarMenuSubgroupSelector = '.navbar-menu__subgroup'

  function toggleNavbarSubgroup(menuItem, isVisible = true) {
    menuItem.classList.toggle('navbar-menu__item--active', isVisible)
    toggleHeight(
      menuItem.querySelector(navbarMenuSubgroupSelector),
      isVisible
    )
  }

  navbarMenuToggler.addEventListener('click', (e) => {
    navbarMenuToggler.classList.toggle('navbar-burger-btn--active')
    navbarMenu.classList.toggle('navbar-menu--visible')
  })

  Array.from(
    document.querySelectorAll(navbarMenuSubgroupSelector)
  )
  .map(node => node.parentNode)
  .forEach(node => {
    let isHovered = false

    node.addEventListener('click', () => {
      if (isHovered || navbarMenuToggler.style.display === 'none') return
      toggleNavbarSubgroup(node)
    })

    node.addEventListener('mouseenter', () => {
      isHovered = true
      toggleNavbarSubgroup(node)
    })
    node.addEventListener('mouseleave', () => {
      isHovered = false
      toggleNavbarSubgroup(node, false)
    })
  })
})

