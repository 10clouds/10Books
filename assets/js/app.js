import 'phoenix_html'
import 'bootstrap' // TODO: Import only stuff we actually need
import React from 'react';
import ReactDOM from 'react-dom';
import store from 'react/store';
import { setUser } from 'react/store/actions/user';
import Library from 'react/containers/Library';
import Orders from 'react/containers/Orders';
import All from 'react/containers/All';


window.LibTen = {
  ReactComponents: {
    renderLibrary(domNode, currentUser) {
      store.dispatch(setUser(currentUser));
      ReactDOM.render(<Library store={store} />, domNode);
    },
    renderOrders(domNode, currentUser) {
      store.dispatch(setUser(currentUser));
      ReactDOM.render(<Orders store={store} />, domNode);
    },
    renderAll(domNode, currentUser) {
      store.dispatch(setUser(currentUser));
      ReactDOM.render(<All store={store} />, domNode);
    }
  }
};
