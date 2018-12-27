import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import get from 'lodash/get'

import store from './store'
import { Library, Orders, All } from '~/containers/pages'
import NewVersionAvailable from '~/containers/NewVersionAvailable'
import LiveDemoMessage from '~/containers/LiveDemoMessage'

const componentsIndex = {
  products: {
    library: Library,
    orders: Orders,
    all: All
  },
  LiveDemoMessage,
  newVersionAvailable: NewVersionAvailable
}

export const renderReactComponent = (componentId, domNode) => {
  const Component = get(componentsIndex, componentId)

  if (Component) {
    ReactDOM.render(
      <Provider store={store}>
        <Component />
      </Provider>,
      domNode
    )
  } else {
    throw new Error(`No ${componentId} component in componentsIndex`)
  }
}
