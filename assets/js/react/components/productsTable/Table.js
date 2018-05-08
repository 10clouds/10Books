import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import TableRow from './TableRow'

export default class Table extends PureComponent {
  static propTypes = {
    products: PropTypes.array.isRequired,
    categories: PropTypes.object.isRequired,
    appendColumns: PropTypes.array.isRequired,
    canToggleDetails: PropTypes.bool.isRequired,
    modifier: PropTypes.string,
    getRowProps: PropTypes.func.isRequired
  }

  static defaultProps = {
    appendColumns: [],
    canToggleDetails: false,
    getRowProps: () => ({})
  }

  render() {
    const {
      appendColumns,
      categories,
      products,
      canToggleDetails,
      modifier,
      getRowProps
    } = this.props
    return (
      <div
        className={cn('table', {
          [`table--${modifier}`]: modifier
        })}
      >
        {/*
        <div className="table__row table__row--transparent">
          <div className="table__heading table__heading-title">Title</div>
          <div className="table__heading table__heading-author">Author</div>
          <div className="table__heading table__heading-category">Category</div>
          {this.props.appendColumns.map((col, i) => (
            <div className="table__heading" key={i} {...col.thProps}>{col.title}</div>
          ))}
        </div>
        */}
        {products.map(product => (
          <TableRow
            {...getRowProps(product)}
            key={product.id}
            product={product}
            category={categories[product.category_id]}
            appendColumns={appendColumns}
            canToggleDetails={canToggleDetails}
          />
        ))}
      </div>
    )
  }
}
