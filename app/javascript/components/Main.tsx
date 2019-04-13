import React from "react"
import PropTypes from "prop-types"
class Main extends React.Component<string, string> {
  static propTypes = {
    user_name: PropTypes.string
  }
  render () {
    return (
      <p>
        Shadowrun Matrix project lobby, welcome {this.props.user_name}
      </p>
    );
  }
}

export default Main
