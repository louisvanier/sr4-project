import React from "react"
import PropTypes from "prop-types"
import TemplateMatrixUsers from './TemplateMatrixUsers'

export interface MainProps {
  user_name: string
}

class Main extends React.Component<MainProps, {}> {
  render () {
    return (
      <div>
        <h1>
          Shadowrun Matrix project lobby, welcome {this.props.user_name}
        </h1>
        <TemplateMatrixUsers />
      </div>
    );
  }
}

export default Main
