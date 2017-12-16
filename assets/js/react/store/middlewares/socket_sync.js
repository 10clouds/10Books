import * as productActions from '../actionTypes/products';
import { productsChannel } from 'socket';

export default function(store) {
  return next => action => {
    // TODO: Remove this middleware and have logic in actions
    if (!action.skipSocketMiddleware) {
      switch (action.type) {
        case productActions.CREATE:
          productsChannel.push('create', {attrs: action.attrs});
          break;
        case productActions.UPDATED:
          const { id, attrs } = action;
          productsChannel.push('update', {
            id: action.id,
            attrs: action.attrs
          });
          break;
        case productActions.DELETED:
          productsChannel.push('delete', {id: action.id});
          break;
        case productActions.TAKEN:
          productsChannel.push('take', {id: action.id});
          break;
        case productActions.RETURNED:
          productsChannel.push('return', {id: action.id})
          break;
        case productActions.UPVOTE:
          productsChannel.push('upvote', {id: action.id})
          break;
        case productActions.DOWNVOTE:
          productsChannel.push('downvote', {id: action.id})
          break;
      }
    }

    return next(action);
  };
}
