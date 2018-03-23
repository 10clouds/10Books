import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'

export default class VotesCell extends PureComponent {
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

    return (
      <div>
        <div className="votes-counter">
          <span className="text-success">{upvotesCount}</span>
          /
          <span className="text-danger">{downvotesCount}</span>
        </div>
        {product.requested_by.id !== currUser.id && (
          <div className="btn-group">
            <span
              disabled={currUserDidUpvote === true}
              className={classnames('btn btm-sm', {
                'btn-secondary': [null, false].includes(currUserDidUpvote),
                'btn-success active': currUserDidUpvote === true
              })}
              onClick={() => upvote(product.id)}
            >
              <i className="fa fa-thumbs-up" />
            </span>
            <span
              disabled={currUserDidUpvote === false}
              className={classnames('btn btm-sm', {
                'btn-secondary': [null, true].includes(currUserDidUpvote),
                'btn-success active': currUserDidUpvote === false
              })}
              onClick={() => downvote(product.id)}
            >
              <i className="fa fa-thumbs-down" />
            </span>
          </div>
        )}
      </div>
    )
  }
}
