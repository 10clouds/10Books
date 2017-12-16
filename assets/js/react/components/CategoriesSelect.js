import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

const CategoriesSelect = (props) => (
  <select
    className="form-control"
    onChange={(e) => {
      props.onChange(parseInt(e.target.value, 10) || null)
    }}
    value={props.value || ""}
    required
  >
    <option value="">--select category--</option>
    {props.values.map(option => (
      <option
        key={option.id}
        value={option.id}
      >
        {option.name}
      </option>
    ))}
  </select>
);

CategoriesSelect.propTypes = {
  values: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.number.isRequired,
      name: PropTypes.string.isRequired
    })
  ).isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.number
};

const mapStateToProps = state => ({
  values: Object.values(state.categories.byId)
})

export default connect(mapStateToProps)(CategoriesSelect);
