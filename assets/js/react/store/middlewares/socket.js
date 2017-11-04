export default function(store) {
  return next => action => {
    console.log('middleware', action, store);
    return next(action);
  };
}
