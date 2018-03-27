import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'

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
    ),
    currentUser: PropTypes.shape({
      id: PropTypes.number.isRequired
    }),
  }

  render() {
    const {
      product,
      categoryName,
      appendColumns,
      currentUser
    } = this.props

    const ownedBook = product.used_by ? product.used_by.user.id === currentUser.id : false
    const rowClassNames = cn({
      'row': true,
      'table__row': true,
      'table__row--highlight': ownedBook,
    })
    
    //console.log(product.used_by.user.id === currentUser.id)

    return (
      <div className={ rowClassNames }>
        <div className="table__data table__data-title col-3">
          <a href={product.url} target="_blank">{product.title}</a>
        </div>
        <div className="table__data col-2">{product.author}</div>
        <div className="table__data table__data-category col-3">{categoryName}</div>
        {appendColumns.map((col, i) => (
          <div key={i} {...col.tdProps}>
            {col.render(product)}
          </div>
        ))}
      </div>
    )
  }
}
