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
    if (!email || !password) {
      setErro("Preencha todos os campos");
      return;
    }

    const validEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!validEmail.test(email)) {
      setErro("Insira um email válido");
      return;
    }

    try {
      if (
        (email === "admin@ulife.com.br" && password === "admin") ||
        (email === "user@ulife.com.br" && password === "user")
      ) {
        const fakeResponse = {
          data: {
            role: email === "admin@ulife.com.br" ? "ADMIN" : "USER",
            nome: email === "admin@ulife.com.br" ? "Administrador" : "Usuário Comum",
          },
        };

        alert(`Bem-vindo, ${fakeResponse.data.nome}`);
        setErro("");
        localStorage.setItem("userRole", fakeResponse.data.role);

        if (fakeResponse.data.role === "ADMIN") {
          navigate("/admin");
          window.location.reload();
        } else {
          navigate("/user");
          window.location.reload();
        }
      } else if (email !== "admin@ulife.com.br" && email !== "user@ulife.com.br") {
        setErro("Email não cadastrado");
      } else {
        setErro("Senha incorreta");
      }

      /*
      const response = await axios.post("http://localhost:8080/api/login", {
        email: email,
        senha: password,
      });

      if (response.status === 200) {
        const { token, user } = response.data;
        localStorage.setItem("token", token);
        localStorage.setItem("user", JSON.stringify(user));
        setErro("");
        alert(`Bem-vindo, ${user.fullname}!`);

        if (user.role === "ADMIN") {
          navigate("/admin");
        } else {
          navigate("/user");
        }
      }
      */
    } catch (error) {
      setErro("Erro ao fazer login.");
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

              <label htmlFor="password" className="formLabel">Senha:</label>
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
                <button className="link" onClick={() => navigate("/esqueci-senha")}>
                  Esqueci minha senha
                </button>
                <button className="link" onClick={() => navigate("/signup")}>
                  Ainda não tem conta? Cadastre-se
                </button>
              </div>
            </div>

            <button
              onClick={handleLogin}
              disabled={!email || !password}
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

export default Login;