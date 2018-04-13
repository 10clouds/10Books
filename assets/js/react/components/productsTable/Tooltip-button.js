import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import classnames from 'classnames';

class TooltipButton extends PureComponent {
  static propTypes = {
    onClick: PropTypes.func,
    className: PropTypes.string,
    children: PropTypes.node,
    tooltipText: PropTypes.string
  };

  state = {
    isTooltipVisible: false,
  };

  toggleTooltip = () => {
    if (this.state.isTooltipVisible) {
      this.hideTooltip();
    } else {
      this.showTooltip();
    }
  };

  showTooltip = () => {
    this.setState({ isTooltipVisible: true });
  };

  hideTooltip = () => {
    this.setState({ isTooltipVisible: false });
  };

  render() {
    const { onClick, className, children, tooltipText } = this.props;
    return (
      <button
        type="button"
        onClick={() => {
          onClick();
          this.toggleTooltip();
        }}
        onMouseEnter={this.showTooltip}
        onMouseLeave={this.hideTooltip}
        className={classnames(`${className} button-tooltip`, {
          'tooltip-active': this.state.isTooltipVisible,
        })}
      >
        {children}
        <span className="button-tooltip__text">{tooltipText}</span>
      </button>
    );
  }
}

export default TooltipButton;
