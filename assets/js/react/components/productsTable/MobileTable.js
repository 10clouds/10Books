import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import MobileTableRow from './MobileTableRow'

export default class MobileTable extends PureComponent {
  static propTypes = {
    products: PropTypes.array.isRequired,
    categories: PropTypes.object.isRequired,
    appendColumns: PropTypes.array.isRequired
  }

  static defaultProps = {
    appendColumns: []
  }

  renderMobileRow = () => {
    return (
      <div className="mobile-table__row">
        <span>asdasdasdasdasd dsadasd</span>
        <span>asdasdasd adasd</span>
        <div className="arrow-down"></div>
      </div>
    )
  }

  render() {
    const { products, categories } = this.props
    
    return (
      <div className="mobile-table">
        { products.map(product => (
          <MobileTableRow
            key={product.id}
            product={product}
            categoryName={categories[product.category_id].name}
          />
          ))
        }
      </div>
    )
  }
}

{/* <table className="products-table table table-striped">
        <thead>
          <tr>
            <th>Title</th>
            <th className="text-center">Author</th>
            {this.props.appendColumns.map((col, i) => (
              <th key={i} {...col.thProps}>{col.title}</th>
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
      </table> */}