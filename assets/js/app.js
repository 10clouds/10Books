import 'phoenix_html'
import 'bootstrap' // TODO: Import only stuff we actually need
import React from 'react';
import ReactDOM from 'react-dom';
import ProductsTable from './react/containers/ProductsTable';

window.ReactComponents = {
  renderProductsTable(domNode) {
    ReactDOM.render(<ProductsTable store={window.store} />, domNode);
  }
};

// import socket from "./socket"
