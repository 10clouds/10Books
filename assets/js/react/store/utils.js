export const makeReducer = (actionReducers, defaultState) => (
  state = defaultState,
  action
) => {
  if (Object.keys(actionReducers).includes('undefined')) {
    throw new TypeError(
      'Undefined action name! Check your imports/property names in reducer file.'
    );
  }
  const subReducer = actionReducers[action.type];

  if (subReducer) {
    return subReducer(state, action);
  }
  return state;
};
