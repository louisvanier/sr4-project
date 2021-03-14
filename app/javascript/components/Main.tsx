import * as React from "react"
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
        <TemplateMatrixUsers matrixUsers={[]}/>
      </div>
    );
  }
}

export default Main
