import React from "react";

const InputField = ({ type = "text", placeholder, value, onChange }) => {
  return (
    <input
      type={type}
      placeholder={placeholder}
      className="input"
      value={value}
      onChange={onChange}
    />
  );
};

export default InputField;