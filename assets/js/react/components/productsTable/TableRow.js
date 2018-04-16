import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import debounce from 'lodash.debounce'

export default class TableRow extends PureComponent {

  state = {
    detailsVisible: false,
    isMobile: null,
  } 

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

  componentDidMount() {
    this.setState({ isMobile: window.innerWidth < 839 })
    window.addEventListener('resize', this.handleWindowResize)
  }

  handleWindowResize = debounce(() => {
    const isMobile = window.innerWidth < 839
    this.setState({ isMobile })
  }, 400 )

  handleArrowClick = () => {
    this.setState({
      detailsVisible: !this.state.detailsVisible
    })
  }

  render() {
    const {
      product,
      categoryName,
      appendColumns,
      currentUser
    } = this.props
    const { detailsVisible, isMobile } = this.state
    
    //TDO: add isMobile or something like that, then isMobile && status === 'IN__LIBRARY' - ?

    const ownedBook =  product.used_by ? product.used_by.user.id === currentUser.id : false
    const rowClassNames = cn({
      'table__row': true,
      'table__row--highlight': ownedBook,
    })
    const arrowClassNames = cn({
      'arrow': true,
      'arrow--down': !detailsVisible,
      'arrow--up': detailsVisible 
    })
    const titleClassNames = cn ({
      'table__data': true,
      'table__data--truncate': !detailsVisible,
      'table__data-title': true
    })
    const authorClassNames = cn ({
      'table__data': true,
      'table__data--truncate': !detailsVisible,
      'table__data-author': true
    })

    return (
      <div className={ rowClassNames }>
        <div className={ titleClassNames }>
          <a href={product.url} target="_blank">{product.title}</a>
        </div>
        <div className={ authorClassNames }>{product.author}</div>
        <div className="table__arrow" onClick={ this.handleArrowClick }>
          <button className={ arrowClassNames }></button>
        </div>

        { (!isMobile || detailsVisible) &&
          <div className="table__details">
            <div className="table__data table__data-category">
              <div className="table__data table__category-wrapper">
              {/* TODO: add different category icons for different categories */}
                <div className="category-icon category-icon--design"></div>
                <div className="table__data table__category-name ">
                  {categoryName}
                </div>
              </div>  
              {appendColumns.map((col, i) => (
                col.title === 'Rating' ?
                  <div className="table__data table__rating" key={i} {...col.tdProps}>
                    {col.render(product)}
                  </div>
                : null
              ))}
            </div>
            {appendColumns.map((col, i) => (
              col.title === 'Status' ?
              <div key={i} {...col.tdProps}>
                {col.render(product)}
              </div>
              : null
            ))}
          </div>
        }
      </div>  
    )
  }
}
