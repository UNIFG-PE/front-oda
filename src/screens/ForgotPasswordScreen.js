import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../style/custom.css";
import Logo from "../assets/logo.png";
import backgroundImage from "../assets/backG.jpg";
import axios from "axios";

const ForgotPassword = () => {
    const [email, setEmail] = useState("");
    const [erro, setErro] = useState("");
    const navigate = useNavigate();

    const validEmail = (email) => {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email.trim());
    };
    const handleSubmit = async () => {
     if (!email.trim()){
        alert("Erro: Por favor, insira um email")
        return;
     };
    if (!validEmail(email)){
        setErro("Insira um email válido");
        return;
    }
    try {
        setTimeout(() => {
            alert("Sucesso, Codigo enviado para o email: " + email);
            navigate("/verificar-codigo", {state: {email}});
        }, 1000);
    } catch(erro){
        console.error(erro)
        alert("Erro: Não foi possivel enviar para o email de recuperação");
    }
};

return (
    <div className="gradient">
      <div className="backG">
        <div
          className="backgroundImage"
          style={{ backgroundImage: `url(${backgroundImage})` }}
        >
          <div className="container">
            <img src={Logo} alt="ULife Logo" className="logoImage" />

            <div className="inputWrapper">
              <label htmlFor="email" className="formLabel">Email:</label>
              <input
                id="email"
                type="email"
                placeholder="professor@ulife.com.br"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  setErro("");
                }}
                className="input"
              />

              {erro && <div className="erro">{erro}</div>}
            </div>

            <button
              onClick={handleSubmit}
              disabled={!email}
              className="botao centeredButton"
            >
              <span className="textoBotao">Entrar</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ForgotPassword;