import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

const CategoriesSelect = props => {
  const { values, onChange, value, dispatch, ...selectProps } = props;

  return (
    <select
      {...selectProps}
      onChange={(e) => {
        onChange(parseInt(e.target.value, 10) || null)
      }}
      value={value || ""}
    >
      <option value="">--select category--</option>
      {values.map(option => (
        <option
          key={option.id}
          value={option.id}
        >
          {option.name}
        </option>
      ))}
    </select>
  );
};

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
  values: state.categories.all
})

export default connect(mapStateToProps)(CategoriesSelect);
