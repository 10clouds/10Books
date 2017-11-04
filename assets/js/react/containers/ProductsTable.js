import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import Store from '../store';
import * as productActions from '../store/actions/products';

class ProductsTable extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <input
          onChange={(e) => this.props.updateSearchString(e.target.value)}
          value={this.props.searchString}
        />
      </div>
    );
  }
}

const mapStateToProps = (state) => (state.products);

const mapDispatchToProps = (dispatch) => (
  bindActionCreators(productActions, dispatch)
);

export default connect(mapStateToProps, mapDispatchToProps)(ProductsTable);
