import { productsChannel, categoriesChannel } from 'socket';
import * as productsActions from './actions/products';
import * as categoriesActions from './actions/categories';

export const bindSocketEvents = (store) => {
  const dispatchSocketEvent = (action) => {
    store.dispatch({...action, skipSocketMiddleware: true})
  };

  /*  Categories Channel
   */
  categoriesChannel.on('created', (item) => {
    dispatchSocketEvent(
      categoriesActions.update(item.id, item)
    );
  });

  categoriesChannel.on('updated', (item) => {
    dispatchSocketEvent(
      categoriesActions.update(item.id, item)
    );
  });

  categoriesChannel.on('deleted', (item) => {
    dispatchSocketEvent(
      categoriesActions.remove(item.id)
    );
  });

  categoriesChannel
  .join()
  .receive('ok', res => {
    dispatchSocketEvent(categoriesActions.updateAll(res.payload))
  })
  .receive('error', resp => {
    console.error("Unable to categories", resp)
  });


  /*  Products Channel
   */
  productsChannel.on('created', (item) => {
    dispatchSocketEvent(
      productsActions.update(item.id, item)
    );
  });

  productsChannel.on('updated', (item) => {
    dispatchSocketEvent(
      productsActions.update(item.id, item)
    );
  });

  productsChannel.on('deleted', (item) => {
    dispatchSocketEvent(
      productsActions.remove(item.id)
    );
  });

  productsChannel
  .join()
  .receive('ok', res => {
    dispatchSocketEvent(productsActions.updateAll(res.payload))
  })
  .receive('error', resp => {
    console.error("Unable to products", resp)
  });
};
