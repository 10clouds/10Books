import * as productActions from '../actionTypes/products';
import { productsChannel } from 'socket';

export default function(store) {
  return next => action => {
    if (!action.skipSocketMiddleware) {
      switch (action.type) {
        case productActions.CREATED:
          productsChannel.push('create', action.attrs);
          break;
        case productActions.UPDATED:
          const { id, attrs } = action;
          productsChannel.push('update', {
            id: action.id,
            attrs: action.attrs
          });
          break;
        case productActions.DELETED:
          productActions.push('delete', action.id);
          break;
      }
    }

    return next(action);
  };
}
