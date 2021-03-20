import * as React from "react"
import {useInput} from '../hooks/useInput'
import * as yup from 'yup';
import { ErrorMessage, Field, Formik, Form } from 'formik'

export function TemplateMatrixUserNew(props: any) {
  let schema = yup.object().shape({
    name: yup.string().required(),
    reaction: yup.number().integer().min(1).max(9).required(),
    intuition: yup.number().integer().min(1).max(9).required(),
    logic: yup.number().integer().min(1).max(9).required(),
    willpower: yup.number().integer().min(1).max(9).required(),
    computer: yup.number().integer().min(0).max(7).required(),
    cybercombat: yup.number().integer().min(0).max(7).required(),
    datasearch: yup.number().integer().min(0).max(7).required(),
    electronicwarfare: yup.number().integer().min(0).max(7).required(),
    hacking: yup.number().integer().min(0).max(7).required(),
  });

  const initialValues = {
    name: '',
    reaction: 1,
    intuition: 1,
    logic: 1,
    willpower: 1,
    computer: 0,
    cybercombat: 0,
    datasearch: 0,
    electronicwarfare: 0,
    hacking: 0
  }

  return (
    <Formik
      initialValues={initialValues}
      validationSchema={schema}
      onSubmit={(values) => {
        console.log(values);
      }}
    >
      {(formik) => {
        const { errors, touched, isValid, dirty } = formik;
        return (
          <Form>
            <div className="container row">
              <div className="col-sm">
                <label>Name</label>
                <Field
                  type="text"
                  name="name"
                  id="name"
                  className={errors.name && touched.name ? 'input-error' : null}
                />
                <ErrorMessage name="name" component="span" className="error" />
              </div>
              <div className="col-sm">
                <h3>Attributes</h3>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Reaction</label>
                  <Field
                    type="number"
                    name="reaction"
                    id="reaction"
                    min="1"
                    max="9"
                    className={errors.reaction && touched.reaction ? 'input-error' : null}
                  />
                  <ErrorMessage name="reaction" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Intuition</label>
                  <Field
                    type="number"
                    name="intuition"
                    id="intuition"
                    min="1"
                    max="9"
                    className={errors.intuition && touched.intuition ? 'input-error' : null}
                  />
                  <ErrorMessage name="intuition" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Logic</label>
                  <Field
                    type="number"
                    name="logic"
                    id="logic"
                    min="1"
                    max="9"
                    className={errors.logic && touched.logic ? 'input-error' : null}
                  />
                  <ErrorMessage name="logic" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Willpower</label>
                  <Field
                    type="number"
                    name="willpower"
                    id="willpower"
                    min="1"
                    max="9"
                    className={errors.willpower && touched.willpower ? 'input-error' : null}
                  />
                  <ErrorMessage name="willpower" component="span" className="error" />
                </div>
              </div>
              <div className="col-sm">
                <h3>Skills</h3>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Computer</label>
                  <Field
                    type="number"
                    name="computer"
                    id="computer"
                    min="0"
                    max="7"
                    className={errors.computer && touched.computer ? 'input-error' : null}
                  />
                  <ErrorMessage name="computer" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Cybercombat</label>
                  <Field
                    type="number"
                    name="cybercombat"
                    id="cybercombat"
                    min="0"
                    max="7"
                    className={errors.cybercombat && touched.cybercombat ? 'input-error' : null}
                  />
                  <ErrorMessage name="cybercombat" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Data search</label>
                  <Field
                    type="number"
                    name="datasearch"
                    id="datasearch"
                    min="0"
                    max="7"
                    className={errors.datasearch && touched.datasearch ? 'input-error' : null}
                  />
                  <ErrorMessage name="datasearch" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Electronic warfare</label>
                  <Field
                    type="number"
                    name="electronicwarfare"
                    id="electronicwarfare"
                    min="0"
                    max="7"
                    className={errors.electronicwarfare && touched.electronicwarfare ? 'input-error' : null}
                  />
                  <ErrorMessage name="electronicwarfare" component="span" className="error" />
                </div>
                <div className="form-group">
                  <label className="col-sm-4 control-label">Hacking</label>
                  <Field
                    type="number"
                    name="hacking"
                    id="hacking"
                    min="0"
                    max="7"
                    className={errors.hacking && touched.hacking ? 'input-error' : null}
                  />
                  <ErrorMessage name="hacking" component="span" className="error" />
                </div>
              </div>
              <button
                  type="submit"
                  className={!(dirty && isValid) ? "disabled-btn" : ""}
                  disabled={!(dirty && isValid)}
                >
                  Create
                </button>
            </div>
          </Form>
        )
      }}
    </Formik>
  )
};
