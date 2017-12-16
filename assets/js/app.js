import 'phoenix_html'
import 'bootstrap' // TODO: Import only stuff we actually need
import React from 'react';
import ReactDOM from 'react-dom';
import store from 'react/store';
import ProductsTable from 'react/containers/ProductsTable';

window.LibTen = {
  ReactComponents: {
    renderProductsTable(domNode, props) {
      ReactDOM.render(<ProductsTable {...props} store={store} />, domNode);
    }
  }
};
