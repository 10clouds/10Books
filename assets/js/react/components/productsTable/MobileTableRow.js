import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
// import UsageCell from './UsageCell'
// import * as libraryActions from '~/store/actions/products/library'

export default class MobileTableRow extends PureComponent {
  state = {
    detailsVisible: true // CHANGE to false
  }

  static propTypes = {
    product: PropTypes.shape({
      title: PropTypes.string.isRequired,
      url: PropTypes.string,
      author: PropTypes.string,
    }),
    categoryName: PropTypes.string.isRequired,
  }

  handleArrowClick = () => {
    this.setState({
      detailsVisible: !this.state.detailsVisible
    })
  }

  render() {
    const { product, categoryName } = this.props
    const { detailsVisible } = this.state
    const arrowClassNames = cn({
      'arrow': true,
      'arrow--down': !detailsVisible,
      'arrow--up': detailsVisible
    })
    const buttonClassNames = cn({
      'button': true,
      'button--dark': product.status !== 'IN_LIBRARY', //TODO: change condition
      'button--bright': product.status === 'IN_LIBRARY',
      'mobile-table__button': true,
    })
    const categoryIconClasNames = cn(
      'mobile-table__category-icon',
      'category-icon',
      'category-icon--design',
    )
    const rowClassNames = cn({
      'mobile-table__row': true,
      'mobile-table__row--available': product.status === 'IN_LIBRARY',
    })

    const buttonText = product.status === 'IN_LIBRARY' ? 'Take a book' : 'Return'

    return (
      <div className={ rowClassNames }>
        <div className="mobile-table__main">
          <div className="mobile-table__title-wrapper">
            <p className="mobile-table__title">{ product.title }</p>
            <p className="mobile-table__author">{ product.author }</p>
          </div>
          <div className="mobile-table__arrow-wrapper" onClick={ this.handleArrowClick }>
            <div className={ arrowClassNames }></div>
          </div>
        </div>
        { detailsVisible &&
          <div className="mobile-table__details-wrapper">
            <div className="mobile-table__details">
              <div className={ categoryIconClasNames }></div>
              <div className="mobile-table__category-name">{ categoryName }</div>
              <div className="mobile-table__rating">4.5</div>
            </div>
            <button className={ buttonClassNames } role="button">{ buttonText }</button>
            {/* <UsageCell 
              {...this.props.libraryActions}

            /> */}
          </div>
        }
      </div>
    )
  }
}
