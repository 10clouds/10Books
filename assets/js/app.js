import 'phoenix_html'
import 'bootstrap' // TODO: Import only stuff we actually need
import React from 'react';
import ReactDOM from 'react-dom';
import store from 'react/store';
import ProductsTable from 'react/containers/ProductsTable';

import socket from 'socket';

window.LibTen = {
  ReactComponents: {
    renderProductsTable(domNode) {
      ReactDOM.render(<ProductsTable store={store} />, domNode);
    }
  }
};
