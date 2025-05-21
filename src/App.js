import { BrowserRouter as Router, Route, Routes, Navigate } from "react-router-dom";
import { getItem } from "./LocalStorage";
import Login from "./screens/LoginScreen";
import AdminScreen from "./screens/AdminScreen";
import UserScreen from "./screens/UserScreen"; 
import ForgotPassword from "./screens/ForgotPasswordScreen";
import VerificarCodigo from "./screens/VerificarCodigoScreen";
import RedefinirSenha from "./screens/ResetPasswordScreen";

function ProtectedAdmin() {
  const role = getItem("userRole");
  if (role !== "ADMIN") {
    return <Navigate to="/login" replace />;
  }
  return <AdminScreen />;
}

function ProtectedUser() {
  const role = getItem("userRole");
  if (role !== "USER") {
    return <Navigate to="/login" replace />;
  }
  return <UserScreen />;
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/esqueci-senha" element={<ForgotPassword />} />
        <Route path="/admin" element={<ProtectedAdmin />} />
        <Route path="/user" element={<ProtectedUser />} />
        <Route path="*" element={<Navigate to="/login" replace />} />
        <Route path="/verificar-codigo" element={<VerificarCodigo />} />
        <Route path="/redefinir-senha" element={<RedefinirSenha />} />
      </Routes>
    </Router>
  );
}

export default App;
