import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import CategoriesSelect from './CategoriesSelect';

class ProductsTableRow extends PureComponent {
  render() {
    const {
      product,
      onChange,
      appendColumns
    } = this.props;

    return (
      <tr>
        <td>
          <a href={product.url} target="_blank">{product.title}</a>
        </td>
        <td className="text-center">{product.author}</td>
        <td className="products-table__category-col">
          <CategoriesSelect
            className="form-control"
            value={product.category_id}
            onChange={val => (
              onChange(product.id, { category_id: val })
            )}
          />
        </td>
        {appendColumns.map((col, i) => (
          <td key={i} {...col.tdProps}>
            {col.render(product, this.props)}
          </td>
        ))}
      </tr>
    );
  }
}

export default class ProductsTable extends PureComponent {
  static propTypes = {
    products: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.number.isRequired,
        title: PropTypes.string.isRequired,
        url: PropTypes.string,
        author: PropTypes.string,
        category_id: PropTypes.number,
      })
    ),
    onChange: PropTypes.func.isRequired,
    appendColumns: PropTypes.arrayOf(
      PropTypes.shape({
       title: PropTypes.string,
       tdProps: PropTypes.object,
       render: PropTypes.func.isRequired,
      })
    )
  };

  static defaultProps = {
    appendColumns: []
  };

  renderRow = product => {
    return (
      <tr key={product.id}>
        <td>
          <a href={product.url} target="_blank">{product.title}</a>
        </td>
        <td className="text-center">{product.author}</td>
        <td className="products-table__category-col">
          <CategoriesSelect
            className="form-control"
            value={product.category_id}
            onChange={val => (
              this.props.onChange(product.id, { category_id: val })
            )}
          />
        </td>
        {this.props.appendColumns.map((col, i) => (
          <td key={i} {...col.tdProps}>
            {col.render(product, this.props)}
          </td>
        ))}
      </tr>
    );
  }

  render() {
    return (
      <table className="products-table table table-striped">
        <thead>
          <tr>
            <th>Title</th>
            <th className="text-center">Author</th>
            <th className="text-center">Category</th>
            {this.props.appendColumns.map((col, i) => (
              <th key={i} {...col.thProps}>{col.title}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {this.props.products.map(product => (
            <ProductsTableRow
              key={product.id}
              product={product}
              onChange={this.props.onChange}
              appendColumns={this.props.appendColumns}
            />
          ))}
        </tbody>
      </table>
    );
  }
}
