import React from "react"
import PropTypes from "prop-types"
import TemplateMatrixUserList from './TemplateMatrixUserList'

export interface TemplateMatrixUsersProps {
  matrixUsers: []
}

class TemplateMatrixUsers extends React.Component<TemplateMatrixUsersProps, {}> {
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
