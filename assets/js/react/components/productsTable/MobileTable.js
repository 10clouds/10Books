import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import MobileTableRow from './MobileTableRow'

export default class MobileTable extends PureComponent {
  static propTypes = {
    products: PropTypes.array.isRequired,
    categories: PropTypes.object.isRequired
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
