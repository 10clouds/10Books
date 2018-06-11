import React, { PureComponent, Fragment } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'

import CategoryLabel from '~/components/CategoryLabel'

function SectionWrapper({ enabled, children, ...elProps }) {
  return enabled
    ? <div {...elProps} children={children} />
    : <Fragment children={children} />
}

SectionWrapper.propTypes = {
  enabled: PropTypes.bool.isRequired,
  children: PropTypes.node.isRequired
}

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
          'table__col',
          className,
          modifiers && modifiers.map(mod => `table__col--${mod}`)
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
        className={cn('table__row', {
          'table__row--highlighted': isHighlighted,
        })}
      >
        <SectionWrapper enabled={canToggleDetails} className="table__row-header">
          <div className="table__col table__col--title">
            <a href={product.url} target="_blank">{product.title}</a>

            {canToggleDetails && (
              <button
                type="button"
                className="table__toggle-details-btn"
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

          <div className="table__col table__col--author">
            {product.author}
          </div>
        </SectionWrapper>

        {(!canToggleDetails || detailsVisible) && (
          <SectionWrapper enabled={canToggleDetails} className="table__row-details">
            <div className="table__col table__col--category">
              <CategoryLabel {...category} />
            </div>
            {appendColumns.map((col, i) => this.renderAppendColumn(col, i))}
          </SectionWrapper>
        )}
      </div>
    )
  }
}
