import React, { useEffect, useState } from "react";
import { BrowserRouter as Router, Route, Routes} from "react-router-dom";
import { getItem } from "./LocalStorage";
import Login from "./screens/LoginScreen";
import AdminScreen from "./screens/AdminScreen";
import UserScreen from "./screens/UserScreen"; 

function App() {
  const [userRole, setUserRole] = useState(null);

  useEffect(() => {
    const role = getItem("userRole");
    if (role) {
      setUserRole(role);
    }
  }, []);

  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} /> 

        
        {userRole === "ADMIN" && (
          <Route path="/admin" element={<AdminScreen />} />
        )}
        {userRole === "USER" && (
          <Route path="/user" element={<UserScreen />} />
        )}
        
        <Route path="*" element={<Login />} />
      </Routes>
    </Router>
  );
}

export default App;