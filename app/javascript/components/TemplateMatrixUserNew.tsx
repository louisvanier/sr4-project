import * as React from "react"
import {useInput} from '../hooks/useInput'

export function TemplateMatrixUserNew(props: any) {
  const { value:name, bind:bindName, reset:resetName } = useInput('');
  const { value:reaction, bind:bindReaction, reset:resetReaction } = useInput('');
  const { value:intuition, bind:bindIntuition, reset:resetIntuition } = useInput('');
  const { value:logic, bind:bindLogic, reset:resetLogic } = useInput('');
  const { value:willpower, bind:bindWillpower, reset:resetWillpower } = useInput('');
  const { value:computer, bind:bindComputer, reset:resetComputer } = useInput('');
  const { value:cybercombat, bind:bindCybercombat, reset:resetCybercombat } = useInput('');
  const { value:datasearch, bind:bindDatasearch, reset:resetDatasearch } = useInput('');
  const { value:electronicwarfare, bind:bindElectronicwarfare, reset:resetElectronicwarfare } = useInput('');
  const { value:hacking, bind:bindHacking, reset:resetHacking } = useInput('');

  const handleSubmit = () => {
    console.log(name, reaction, intuition, logic, willpower, computer, cybercombat, datasearch, electronicwarfare, hacking);
  }

  return (
    <div style={{display: 'flex'}}>
      <label>Name</label>
      <input type="text" {...bindName}></input>
      <div>
        <h3>Attributes</h3>
        <div>
          <label>Reaction</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1"  {...bindReaction}></input>
        </div>
        <div>
          <label>Intuition</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1" {...bindIntuition}></input>
        </div>
        <div>
          <label>Logic</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1" {...bindLogic}></input>
        </div>
        <div>
          <label>Willpower</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1" {...bindWillpower}></input>
        </div>
      </div>
      <div>
        <h3>Skills</h3>
        <div>
          <label>Computer</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindComputer}></input>
        </div>
        <div>
          <label>Cybercombat</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindCybercombat}></input>
        </div>
        <div>
          <label>Data search</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindDatasearch}></input>
        </div>
        <div>
          <label>Electronic Warfare</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindElectronicwarfare}></input>
        </div>
        <div>
          <label>Hacking</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindHacking}></input>
        </div>
      </div>
      <button onClick={handleSubmit}>create</button>
    </div>
  )
};
