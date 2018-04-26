import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import TableRow from './TableRow'

export default class Table extends PureComponent {
  static propTypes = {
    products: PropTypes.array.isRequired,
    categories: PropTypes.object.isRequired,
    appendColumns: PropTypes.array.isRequired,
    currentUser: PropTypes.shape({
      id: PropTypes.number.isRequired
    }),
    isMobile: PropTypes.bool,
  }

  static defaultProps = {
    appendColumns: []
  }

  render() {
    const {
      appendColumns,
      currentUser,
      isMobile,
      categories,
      products,
    } = this.props
    return (
      <div className="table">
        <div className="table__row table__row--transparent">
          <div className="table__heading table__heading-title">Title</div>
          <div className="table__heading table__heading-author">Author</div>
          <div className="table__heading table__heading-category">Category</div>
          {this.props.appendColumns.map((col, i) => (
            <div className="table__heading" key={i} {...col.thProps}>{col.title}</div>
          ))}
        </div>
        {products.map(product => (
          <TableRow
            key={product.id}
            product={product}
            categoryColor={ categories[product.category_id].color }
            categoryName={ categories[product.category_id].name }
            appendColumns={ appendColumns }
            currentUser={ currentUser }
            isMobile={ isMobile }
          />
        ))}
      </div>
    )
  }
}
