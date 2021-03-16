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
    <div className="row">
      <div className="col-sm">
        <label>Name</label>
        <input type="text" {...bindName}></input>
      </div>
      <div className="col-sm">
        <h3>Attributes</h3>
        <div className="form-group">
          <label className="col-sm-4 control-label">Reaction</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1"  {...bindReaction}></input>
        </div>
        <div className="form-group control-label">
          <label className="col-sm-4">Intuition</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1" {...bindIntuition}></input>
        </div>
        <div className="form-group control-label">
          <label className="col-sm-4">Logic</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1" {...bindLogic}></input>
        </div>
        <div className="form-group control-label">
          <label className="col-sm-4">Willpower</label>
          <input type="number" min="1" max="9" step="1" defaultValue="1" {...bindWillpower}></input>
        </div>
      </div>
      <div className="col-sm">
        <h3>Skills</h3>
        <div className="form-group">
          <label className="col-sm-6 control-label">Computer</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindComputer}></input>
        </div>
        <div className="form-group">
          <label className="col-sm-6 control-label">Cybercombat</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindCybercombat}></input>
        </div>
        <div className="form-group">
          <label className="col-sm-6 control-label">Data search</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindDatasearch}></input>
        </div>
        <div className="form-group">
          <label className="col-sm-6 control-label">Electronic Warfare</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindElectronicwarfare}></input>
        </div>
        <div className="form-group">
          <label className="col-sm-6 control-label">Hacking</label>
          <input type="number" min="1" max="6" step="1" defaultValue="1" {...bindHacking}></input>
        </div>
      </div>
      <button onClick={handleSubmit}>create</button>
    </div>
  )
};
