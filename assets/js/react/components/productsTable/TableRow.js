import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'

import CategoryLabel from '~/components/CategoryLabel'

export default class TableRow extends PureComponent {
  static propTypes = {
    product: PropTypes.shape({
      title: PropTypes.string.isRequired,
      url: PropTypes.string,
      author: PropTypes.string,
    }),
    category: PropTypes.object.isRequired,
    appendColumns: PropTypes.arrayOf(
      PropTypes.shape({
        elProps: PropTypes.shape({
          modifiers: PropTypes.array
        }),
        render: PropTypes.func.isRequired,
      })
    ),
    isHighlighted: PropTypes.bool,
    canToggleDetails: PropTypes.bool.isRequired
  }

  state = {
    detailsVisible: false
  }

  handleArrowClick = () => {
    this.setState({
      detailsVisible: !this.state.detailsVisible
    })
  }

  renderAppendColumn(colProps, key) {
    const { render, elProps } = colProps
    const {
      modifiers,
      className,
      ...restElProps
    } = (elProps || {})

    return (
      <div
        key={key}
        className={cn(
          'table-row__col',
          className,
          modifiers && modifiers.map(mod => `table-row__col--${mod}`)
        )}
        {...restElProps}
      >
        {render(this.props.product)}
      </div>
    )
  }

  render() {
    const {
      product,
      category,
      appendColumns,
      canToggleDetails,
      isHighlighted
    } = this.props
    const { detailsVisible } = this.state

    return (
      <div
        className={cn('table-row', {
          'table-row--highlighted': isHighlighted,
          'table-row--with-toggler': canToggleDetails,
          'table-row--no-toggler': !canToggleDetails
        })}
      >
        <div className="table-row__header">
          <div className="table-row__col table-row__col--title">
            <a href={product.url} target="_blank">{product.title}</a>

            {canToggleDetails && (
              <button
                type="button"
                className="table-row__toggle-details-btn"
                onClick={this.handleArrowClick}
                children={
                  <div className={cn('arrow', {
                    'arrow--down': !detailsVisible,
                    'arrow--up': detailsVisible
                  })} />
                }
              />
            )}
          </div>

          <div className="table-row__col table-row__col--author">
            {product.author}
          </div>
        </div>

        {(!canToggleDetails || detailsVisible) && (
          <div className="table-row__details">
            <div className="table-row__col table-row__col--category">
              <CategoryLabel category={category} />
            </div>
            {appendColumns.map((col, i) => this.renderAppendColumn(col, i))}
          </div>
        )}
      </div>
    )
  }
}
