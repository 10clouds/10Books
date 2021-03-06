import React, { PureComponent } from 'react'
import { connect } from 'react-redux'
import debounce from 'lodash/debounce'
import { Table, NoResults } from '~/components/productsTable'

function canToggleDetails() {
  return window.innerWidth < 900
}

class ProductsTableContainer extends PureComponent {
  static getDerivedStateFromProps(nextProps, prevState) {
    return prevState.canToggleDetails === null
      ? {
          canToggleDetails: canToggleDetails()
        }
      : null
  }

  state = {
    canToggleDetails: null
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleWindowResize)
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleWindowResize)
  }

  handleWindowResize = debounce(() => {
    this.setState({ canToggleDetails: canToggleDetails() })
  }, 400)

  render() {
    const { search, products, categories, ...componentProps } = this.props

    const searchString = search.queryString.toLowerCase()
    const filterByCategoryId = search.filterByCategoryId

    const filteredProducts = Object.values(products.idsByInsertedAt)
      .map(({ id }) => products.byId[id])
      .filter(product =>
        filterByCategoryId ? product.category_id === filterByCategoryId : true
      )
      .filter(
        product =>
          product.title.toLowerCase().includes(searchString) ||
          (product.author &&
            product.author.toLowerCase().includes(searchString))
      )

    if (products.isReady) {
      return filteredProducts.length > 0 ? (
        <Table
          {...componentProps}
          {...this.state}
          products={filteredProducts}
          categories={categories.byId}
        />
      ) : (
        <NoResults />
      )
    } else {
      return null
    }
  }
}

const mapStateToProps = state => ({
  search: state.search,
  products: state.products,
  categories: state.categories
})

export default connect(mapStateToProps)(ProductsTableContainer)
