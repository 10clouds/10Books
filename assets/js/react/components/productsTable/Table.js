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
      <table className="table">
        <thead>
          <tr className="table__row">
            <th className="table__title">Title</th>
            <th className="table__title">Author</th>
            {this.props.appendColumns.map((col, i) => (
              <th className="table__title" key={i} {...col.thProps}>{col.title}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {this.props.products.map(product => (
            <TableRow
              key={product.id}
              product={product}
              categoryName={this.props.categories[product.category_id].name}
              appendColumns={this.props.appendColumns}
            />
          ))}
        </tbody>
      </table>
    )
  }
}
