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
      <div className="row table__row">
        <div className="table__data col-3">
          <a href={product.url} target="_blank">{product.title}</a>
        </div>
        <div className="table__data col-2">{product.author}</div>
        <div className="table__data col-3">{categoryName}</div>
        {appendColumns.map((col, i) => (
          <div key={i} {...col.tdProps}>
            {col.render(product)}
          </div>
        ))}
      </div>
    )
  }
}
