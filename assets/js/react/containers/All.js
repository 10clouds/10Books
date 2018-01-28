import React, { Component } from 'react';
import { Provider } from 'react-redux';
import { connect } from 'react-redux';
import socket from 'socket';
import { joinChannel as joinCategoriesChannel } from '../store/actions/categories';
import { joinChannel as joinProductsChannel } from '../store/actions/products';
import SearchContainer from './common/SearchContainer';
import ProductsTableContainer from './common/ProductsTableContainer';
import StatusSelect from '../components/StatusSelect';

class All extends Component {
  constructor(props) {
    super(props);
    socket.connect();
    props.joinCategoriesChannel();
    props.joinProductsChannel('all');
  }

  render() {
    return (
      <div>
        <SearchContainer />

        <ProductsTableContainer
          appendColumns={[
            {
              title: "Status",
              thProps: {
                className: 'text-center'
              },
              tdProps: {
                className: 'text-center'
              },
              render: (product, props) => (
                <StatusSelect
                  value={product.status}
                  onChange={val => (
                    props.onChange(product.id, { status: val })
                  )}
                />
              )
            }
          ]}
        />
      </div>
    );
  }
}

const mapDispatchToProps = {
  joinCategoriesChannel,
  joinProductsChannel
};

export default connect(null, mapDispatchToProps)(All);
