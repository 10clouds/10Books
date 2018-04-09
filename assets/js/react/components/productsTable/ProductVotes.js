import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import Raw from '~/components/Raw'

export default class ProductVotes extends PureComponent {
  static propTypes = {
    currUser: PropTypes.shape({
      id: PropTypes.number.isRequired
    }),
    product: PropTypes.shape({
      id: PropTypes.number.isRequired,
      requested_by: PropTypes.shape({
        id: PropTypes.number.isRequired
      }),
      votes: PropTypes.arrayOf(
        PropTypes.shape({
          user: PropTypes.shape({
            id: PropTypes.number.isRequired
          }),
          is_upvote: PropTypes.bool.isRequired
        })
      )
    }),
    upvote: PropTypes.func.isRequired,
    downvote: PropTypes.func.isRequired
  }

  render() {
    const {
      product,
      currUser,
      upvote,
      downvote
    } = this.props

    let upvotesCount = 0
    let downvotesCount = 0
    let currUserDidUpvote = null

    product.votes.forEach(vote => {
      if (vote.user.id === currUser.id) {
        currUserDidUpvote = vote.is_upvote
      }

      if (vote.is_upvote) {
        upvotesCount++
      } else {
        downvotesCount++
      }
    })

    const canVote = product.requested_by.id !== currUser.id
      && product.status === 'REQUESTED'

    return (
      <div
        className={cn('product-votes', {
          'product-votes--cant-vote': !canVote
        })}
      >
        <button
          type="button"
          className={cn('product-votes__vote-btn', {
            'product-votes__vote-btn--active': canVote && currUserDidUpvote
          })}
          disabled={currUserDidUpvote === true}
          onClick={() => upvote(product.id)}
        >
          <Raw
            className="button-inner-centering"
            content={
              require('/static/images/product-votes-counter__arrow.svg')
            }
          />
        </button>

        <div className="product-votes__value product-votes__value--upvotes">
          {upvotesCount}
        </div>

        <div className="product-votes__value product-votes__value--downvotes">
          {downvotesCount}
        </div>

        <button
          type="button"
          className={cn('product-votes__vote-btn', {
            'product-votes__vote-btn--down': true,
            'product-votes__vote-btn--active': canVote && currUserDidUpvote === false
          })}
          disabled={currUserDidUpvote === false}
          onClick={() => downvote(product.id)}
        >
          <Raw
            className="button-inner-centering"
            content={
              require('/static/images/product-votes-counter__arrow.svg')
            }
          />
        </button>
      </div>
    )
  }
}
