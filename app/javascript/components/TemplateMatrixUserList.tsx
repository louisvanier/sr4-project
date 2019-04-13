import React from "react"

const TemplateMatrixUserList = (props) => {
  var matrixUsers = props.matrixUsers.map((user) => {
    return(
      <div key={user.id}>
        <h3>{user.name}</h3>
        <fieldset>
          <legend>Attributes</legend>
          <div><b>Reaction:</b> {user.reaction}</div>
          <div><b>Intuition:</b> {user.intuition}</div>
          <div><b>Logic:</b> {user.logic}</div>
          <div><b>Willpower:</b> {user.willpower}</div>
        </fieldset>
        <fieldset>
          <legend>Skills</legend>
          <div><b>Computer:</b> {user.computer}</div>
          <div><b>Cybercombat:</b> {user.cybercombat}</div>
          <div><b>Data Search:</b> {user.data_search}</div>
          <div><b>Electronic Warfare:</b> {user.electronic_warfare}</div>
          <div><b>Hacking:</b> {user.hacking}</div>
        </fieldset>
        <fieldset>
          <legend>Programs</legend>
          <ul>
            {
              user.matrix_program.map((program) => {
                return (
                  <li>
                    {program.name} ({program.rating})
                  </li>
                )
              })
            }
          </ul>
        </fieldset>
      </div>
    )
  });

  return(
    <div>
      {matrixUsers}
    </div>
  )
}

export default TemplateMatrixUserList
