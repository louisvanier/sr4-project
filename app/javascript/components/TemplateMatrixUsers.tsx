import * as React from "react"
import TemplateMatrixUserList from './TemplateMatrixUserList'

export interface TemplateMatrixUsersProps {
  matrixUsers: []
}

export interface TemplateMatrixUsersState {
  matrixUsers: []
}

class TemplateMatrixUsers extends React.Component<TemplateMatrixUsersProps, TemplateMatrixUsersState> {
  constructor(props: TemplateMatrixUsersProps) {
    super(props);
    this.state = {
      matrixUsers: []
    };
  }

  componentDidMount(){
    fetch('/api/v1/templates_matrix_users.json')
      .then(
        (response) => {
          return response.json();
        }
      )
      .then(
        (data) => {
          this.setState({matrixUsers: data});
        }
      )
  }

  render () {
    return (
      <div>
         <h3>Matrix users</h3>
         <TemplateMatrixUserList matrixUsers={this.state.matrixUsers}/>
      </div>
    );
  }
}

export default TemplateMatrixUsers
