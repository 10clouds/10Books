import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import $ from 'jquery';

export default class Modal extends PureComponent {
  static propTypes = {
    show: PropTypes.bool.isRequired,
    onHide: PropTypes.func.isRequired,
    children: PropTypes.node
  };

  componentDidMount() {
    $(this.modalEl).on('hide.bs.modal', this.props.onHide);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.show && !this.props.show) {
      $(this.modalEl).modal('show');
    } else if (!nextProps.show && this.props.show) {
      $(this.modalEl).modal('hide');
    }
  }

  render() {
    return (
      <div
        className="modal fade"
        tabIndex="-1"
        role="dialog"
        aria-hidden="true"
        ref={el => this.modalEl = el}
      >
        <div className="modal-dialog modal-lg">
          <div className="modal-content">
            {this.props.children}
          </div>
        </div>
      </div>
    );
  }
}
