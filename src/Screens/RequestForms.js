import React from "react";

function RequestForms() {
  return (
    <div className="request-forms">
      <h1>Nova Solicitação</h1>
      <form>
        <label htmlFor="request-type">Tipo de Solicitação</label>
        <select id="request-type" name="request-type">
          <option> Campus Piedade</option>
          <option> Campus Boa Vista</option>
        </select>
      </form>
    </div>
  );
}
export default RequestForms;
