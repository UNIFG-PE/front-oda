import React from 'react';
import './Footer.css';

function Footer() {
  const year = new Date().getFullYear();
  
  return (
    <footer className="footer">
      <div className="footer-content">
        <p>&copy; {year} ODA - Online Desk Allocation. Todos os direitos reservados.</p>
        <p className="version">Versão: {process.env.REACT_APP_VERSION || '1.0.0'}</p>
      </div>
    </footer>
  );
}

export default Footer;
