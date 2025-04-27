import React from "react";

const SubmitButton = ({ onClick, disabled, label }) => {
  return (
    <button className="botao" onClick={onClick} disabled={disabled}>
      <span className="textoBotao">{label}</span>
    </button>
  );
};

export default SubmitButton;