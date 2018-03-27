import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import TableRow from './TableRow'

export default class Table extends PureComponent {
  static propTypes = {
    products: PropTypes.array.isRequired,
    categories: PropTypes.object.isRequired,
    appendColumns: PropTypes.array.isRequired
  }

  static defaultProps = {
    appendColumns: []
  }

  render() {
    return (
      <div className="table grid-container">
        <div className="row table__row table__row--transparent">
          <div className="table__heading col-3">Title</div>
          <div className="table__heading col-2">Author</div>
          <div className="table__heading col-3">Category</div>
          {this.props.appendColumns.map((col, i) => (
            <div className="table__heading" key={i} {...col.thProps}>{col.title}</div>
          ))}
        </div>
        {this.props.products.map(product => (
          <TableRow
            key={product.id}
            product={product}
            categoryName={this.props.categories[product.category_id].name}
            appendColumns={this.props.appendColumns}
          />
        ))}
      </div>
    )
  }
}
