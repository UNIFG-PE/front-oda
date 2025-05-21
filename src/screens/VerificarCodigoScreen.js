import React, { useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import axios from "axios";
import "../style/custom.css";
import Logo from "../assets/logo.png";
import backgroundImage from "../assets/backG.jpg";

const VerificarCodigo = () => {
  const [codigo, setCodigo] = useState("");
  const [erro, setErro] = useState("");
  const navigate = useNavigate();
  const location = useLocation();
  const email = location.state?.email;

  const handleVerificar = async () => {
    if (!codigo.trim()) {
      setErro("Digite o código de verificação");
      return;
    }

    try {
      const response = await axios.post("http://localhost:8081/api/auth/verificar-codigo", {
        email,
        codigo,
      });

      if (response.status === 200) {
        navigate("/redefinir-senha", { state: { email } });
      } else {
        setErro("Código inválido ou expirado");
      }

    } catch (err) {
      setErro("Erro ao verificar o código");
    }
  };

  return (
    <div className="gradient">
      <div className="backG">
        <div className="backgroundImage" style={{ backgroundImage: `url(${backgroundImage})` }}>
          <div className="container">
            <img src={Logo} alt="ULife Logo" className="logoImage" />
            <h1 className="title">Verificação de Código</h1>
            <p className="text">
              Digite o código enviado para: <strong>{email}</strong>
            </p>

            <div className="inputWrapper">
              <label htmlFor="codigo" className="formLabel">Código:</label>
              <input
                id="codigo"
                type="text"
                value={codigo}
                onChange={(e) => {
                  setCodigo(e.target.value);
                  setErro("");
                }}
                className="input"
                placeholder="Digite o código"
              />
              {erro && <div className="erro">{erro}</div>}
            </div>

            <button className="botao centeredButton" onClick={handleVerificar}>
              <span className="textoBotao">Verificar</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default VerificarCodigo;
