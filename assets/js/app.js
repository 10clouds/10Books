import 'phoenix_html'
import 'bootstrap' // TODO: Import only stuff we actually need
import React from 'react';
import ReactDOM from 'react-dom';
import store from 'react/store';
import { Provider } from 'react-redux';
import { setUser } from 'react/store/actions/user';
import Library from 'react/containers/Library';
import Orders from 'react/containers/Orders';
import All from 'react/containers/All';

function render(component, domNode) {
  return ReactDOM.render(
    <Provider store={store} children={component} />,
    domNode
  );
}

window.LibTen = {
  ReactComponents: {
    renderLibrary(domNode, currentUser) {
      store.dispatch(setUser(currentUser));
      render(<Library />, domNode);
    },
    renderOrders(domNode, currentUser) {
      store.dispatch(setUser(currentUser));
      render(<Orders />, domNode);
    },
    renderAll(domNode, currentUser) {
      store.dispatch(setUser(currentUser));
      render(<All />, domNode);
    }
  }
};
