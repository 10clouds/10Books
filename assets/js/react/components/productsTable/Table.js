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
          [`table--${modifier}`]: modifier,
          'table--with-toggler': canToggleDetails
        })}
      >
        <div className="table__row table__row--header">
          <div className="table__col table__col--title">
            Title
          </div>
          <div className="table__col table__col--author">
            Author
          </div>
          <div className="table__col table__col--category">
            Category
          </div>
          {this.props.appendColumns.map((col, i) => (
            <div
              key={i}
              className={cn(
                'table__col',
                col.elProps
                  && col.elProps.modifiers
                  && col.elProps.modifiers.map(mod => `table__col--${mod}`)
              )}
            >
              {col.title}
            </div>
          ))}
        </div>
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
