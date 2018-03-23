import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'

export default class TableRow extends PureComponent {
  static propTypes = {
    product: PropTypes.shape({
      title: PropTypes.string.isRequired,
      url: PropTypes.string,
      author: PropTypes.string,
    }),
    categoryName: PropTypes.string.isRequired,
    appendColumns: PropTypes.arrayOf(
      PropTypes.shape({
       tdProps: PropTypes.object,
       render: PropTypes.func.isRequired,
      })
    )
  }

  render() {
    const {
      product,
      categoryName,
      appendColumns
    } = this.props

    return (
      <tr>
        <td>
          <a href={product.url} target="_blank">{product.title}</a>
        </td>
        <td className="text-center">{product.author}</td>
        <td className="products-table__category-col">
          {categoryName}
        </td>
        {appendColumns.map((col, i) => (
          <td key={i} {...col.tdProps}>
            {col.render(product)}
          </td>
        ))}
      </tr>
    )
  }
}
