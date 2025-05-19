import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../style/custom.css";
import Logo from "../assets/logo.png";
import backgroundImage from "../assets/backG.jpg";
import axios from "axios";

const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [erro, setErro] = useState("");
  const navigate = useNavigate();

  const handleLogin = async () => {
    // Validação campos preenchidos
    if (!email || !password) {
      setErro("Preencha todos os campos");
      return;
    }

    // Validação formato do email
    const validEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!validEmail.test(email)) {
      setErro("Insira um email válido");
      return;
    }

    try {
      // Chamada real para sua API backend
      const response = await axios.post("http://localhost:8081/api/auth/login", {
        email: email,
        senha: password,
      });

      if (response.status === 200) {
        const { email: returnedEmail, role } = response.data;

        alert(`Bem-vindo, ${returnedEmail}`);
        setErro("");
        localStorage.setItem("userRole", role);

        if (role === "ADMIN") {
          navigate("/admin");
        } else {
          navigate("/user");
        }
      }
    } catch (error) {
      if (error.response && error.response.status === 401) {
        setErro("Email ou senha inválidos");
      } else {
        setErro("Erro ao conectar com o servidor");
      }
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
              <label htmlFor="email" className="formLabel">
                Email:
              </label>
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

              <label htmlFor="password" className="formLabel">
                Senha:
              </label>
              <input
                id="password"
                type="password"
                placeholder="Senha"
                value={password}
                onChange={(e) => {
                  setPassword(e.target.value);
                  setErro("");
                }}
                className="input"
              />

              {erro && <div className="erro">{erro}</div>}

              <div className="linkContainer">
                <button
                  className="link"
                  onClick={() => navigate("/esqueci-senha")}
                  type="button"
                >
                  Esqueci minha senha
                </button>
                <button
                  className="link"
                  onClick={() => navigate("/signup")}
                  type="button"
                >
                  Ainda não tem conta? Cadastre-se
                </button>
              </div>
            </div>

            <button
              onClick={handleLogin}
              disabled={!email || !password}
              className="botao centeredButton"
              type="button"
            >
              <span className="textoBotao">Entrar</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;
