import React from 'react';
import PropTypes from 'prop-types';
import CategoriesSelect from './CategoriesSelect';

function ProductsTable(props) {
  return (
    <table className="products-table table table-striped">
      <thead>
        <tr>
          <th>Title</th>
          <th className="text-center">Author</th>
          <th className="text-center">Category</th>
          {props.appendColumns.map((col, i) => (
            <th key={i} {...col.thProps}>{col.title}</th>
          ))}
        </tr>
      </thead>
      <tbody>
        {props.products.map(product => (
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
                  props.onChange(product.id, { category_id: val })
                )}
              />
            </td>
            {props.appendColumns.map((col, i) => (
              <td key={i} {...col.tdProps}>
                {col.render(product, props)}
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
}

ProductsTable.propTypes = {
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

ProductsTable.defaultProps = {
  appendColumns: []
};

export default ProductsTable;
