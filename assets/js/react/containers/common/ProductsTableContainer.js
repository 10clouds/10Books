import React from 'react'
import { connect } from 'react-redux'
import ProductsTable from '../../components/ProductsTable'
import { update } from '../../store/actions/products'

function ProductsTableContainer(props) {
  const {
    search,
    products,
    categories,
    renderNoResults,
    ...componentProps
  } = props

  const searchString = search.queryString.toLowerCase()
  const filteredProducts = Object
    .values(props.products.idsByInsertedAt)
    .map(({ id }) => props.products.byId[id])
    .filter(product => (
      product.title.toLowerCase().includes(searchString) || (
        product.author &&
        product.author.toLowerCase().includes(searchString)
      ) || (
        product.category_id &&
        categories.byId[product.category_id].name.toLowerCase().includes(searchString)
      )
    ))

  return filteredProducts.length > 0 ? (
    <ProductsTable
      products={filteredProducts}
      onChange={props.update}
      {...componentProps}
    />
  ) : renderNoResults ? renderNoResults() : null
}

const mapStateToProps = state => ({
  search: state.search,
  products: state.products,
  categories: state.categories
})

const mapDispatchToProps = {
  update
}

export default connect(mapStateToProps, mapDispatchToProps)(ProductsTableContainer)
