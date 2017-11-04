import * as productsActions from '../actionTypes/products';
import { productsChannel } from 'socket';

export default function(store) {
  return next => action => {
    if (action.notifySocket) {
      switch (action.type) {
        case productsActions.PRODUCT_CHANGED:
          productsChannel.push('product:updated', {
            id: action.productId,
            attrs: action.attrs
          });
          break;
      }
    }

    return next(action);
  };
}
