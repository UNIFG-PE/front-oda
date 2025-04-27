import React, { useState } from 'react';
import './App.css';
import Header from './components/Header';
import Footer from './components/Footer';
import HomePage from './pages/HomePage';
import RoomsPage from './pages/RoomsPage';
import MyReservationsPage from './pages/MyReservationsPage';

function App() {
  const [currentPage, setCurrentPage] = useState('home');

  // Simular um sistema de rotas simples
  const renderPage = () => {
    switch (currentPage) {
      case 'home':
        return <HomePage />;
      case 'salas':
        return <RoomsPage />;
      case 'reservas':
        return <MyReservationsPage />;
      default:
        return <HomePage />;
    }
  };

  // Interceptar cliques em links para simular navegação
  React.useEffect(() => {
    const handleNavigation = (event) => {
      // Verificar se o clique foi em um link interno
      if (event.target.tagName === 'A' && !event.target.getAttribute('href').startsWith('http')) {
        event.preventDefault();
        const path = event.target.getAttribute('href');

        // Atualizar a página atual com base no caminho
        if (path === '/') setCurrentPage('home');
        else if (path === '/salas') setCurrentPage('salas');
        else if (path === '/reservas') setCurrentPage('reservas');
      }
    };

    // Adicionar listener para capturar cliques
    document.addEventListener('click', handleNavigation);

    // Limpar listener quando o componente for desmontado
    return () => {
      document.removeEventListener('click', handleNavigation);
    };
  }, []);

  return (
    <div className="App">
      <Header />
      <main className="main-content">
        {renderPage()}
      </main>
      <Footer />
    </div>
  );
}

export default App;
