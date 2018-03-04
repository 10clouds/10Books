import React from 'react';
import PropTypes from 'prop-types';

export const STATUSES_LIST = {
  IN_LIBRARY: 'In Library',
  REQUESTED:  'In Orders',
  ACCEPTED:   'Accepted',
  REJECTED:   'Rejected',
  ORDERED:    'Ordered',
  LOST:       'Lost',
  DIVIDER:    true,
  DELETED:    'Deleted'
};

const StatusSelect = props => (
  <div className="btn-group">
    <button
      type="button"
      className="btn btn-secondary dropdown-toggle"
      data-toggle="dropdown"
    >
      {STATUSES_LIST[props.value]}
    </button>
    <div className="dropdown-menu dropdown-menu-right">
      {Object.keys(STATUSES_LIST).map((type, i) => (
        type === 'DIVIDER' ? (
          <div key={i} className="dropdown-divider" />
        ) : (
          <a
            key={i}
            className="dropdown-item"
            href="#"
            onClick={e => {
              e.preventDefault();
              props.onChange(type);
            }}
          >
            {STATUSES_LIST[type]}
          </a>
        )
      ))}
    </div>
  </div>
);

StatusSelect.propTypes = {
  onChange: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired
};

export default StatusSelect;
