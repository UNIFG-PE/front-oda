import React from 'react';
import './HomePage.css';

function HomePage() {
  return (
    <div className="home-page">
      <section className="hero">
        <div className="hero-content">
          <h1>Bem-vindo ao ODA</h1>
          <p>Sistema de reserva de salas online para sua empresa</p>
          <a href="/salas" className="cta-button">Reservar uma Sala</a>
        </div>
      </section>
      
      <section className="features">
        <h2>Como funciona</h2>
        <div className="features-grid">
          <div className="feature-card">
            <div className="feature-icon">🔍</div>
            <h3>Encontre</h3>
            <p>Navegue pelas salas disponíveis e encontre a ideal para sua reunião</p>
          </div>
          
          <div className="feature-card">
            <div className="feature-icon">📅</div>
            <h3>Reserve</h3>
            <p>Escolha a data, horário e confirme sua reserva em poucos cliques</p>
          </div>
          
          <div className="feature-card">
            <div className="feature-icon">✅</div>
            <h3>Utilize</h3>
            <p>Receba a confirmação e utilize a sala no horário reservado</p>
          </div>
        </div>
      </section>
      
      <section className="stats">
        <div className="stat-item">
          <span className="stat-number">15+</span>
          <span className="stat-label">Salas Disponíveis</span>
        </div>
        
        <div className="stat-item">
          <span className="stat-number">500+</span>
          <span className="stat-label">Reservas Mensais</span>
        </div>
        
        <div className="stat-item">
          <span className="stat-number">98%</span>
          <span className="stat-label">Satisfação</span>
        </div>
      </section>
    </div>
  );
}

export default HomePage;
