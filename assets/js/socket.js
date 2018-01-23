import { Socket } from 'phoenix';

export default new Socket('/socket', {
  params: {
    token: window.currentUserToken
  }
});
