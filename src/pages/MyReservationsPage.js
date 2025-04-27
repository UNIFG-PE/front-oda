import React, { useState } from 'react';
import ReservationCard from '../components/ReservationCard';
import './MyReservationsPage.css';

// Dados mockados para as reservas
const mockReservations = [
  {
    id: 1,
    roomId: 1,
    room: {
      id: 1,
      name: 'Sala Executiva',
      location: 'Bloco A, 2º andar'
    },
    date: '2025-05-15',
    startTime: '09:00',
    endTime: '11:00',
    participants: 8,
    purpose: 'Reunião de planejamento estratégico trimestral',
    status: 'Confirmada'
  },
  {
    id: 2,
    roomId: 3,
    room: {
      id: 3,
      name: 'Sala de Treinamento',
      location: 'Bloco C, 1º andar'
    },
    date: '2025-05-20',
    startTime: '14:00',
    endTime: '17:00',
    participants: 15,
    purpose: 'Treinamento de novos funcionários sobre os procedimentos internos',
    status: 'Confirmada'
  },
  {
    id: 3,
    roomId: 2,
    room: {
      id: 2,
      name: 'Sala Criativa',
      location: 'Bloco B, Térreo'
    },
    date: '2025-05-10',
    startTime: '10:00',
    endTime: '12:00',
    participants: 6,
    purpose: 'Brainstorming para novo projeto de marketing',
    status: 'Cancelada'
  },
  {
    id: 4,
    roomId: 5,
    room: {
      id: 5,
      name: 'Sala Pequena',
      location: 'Bloco B, 2º andar'
    },
    date: '2025-05-25',
    startTime: '11:00',
    endTime: '12:00',
    participants: 3,
    purpose: 'Entrevista com candidato para vaga de desenvolvedor',
    status: 'Pendente'
  }
];

function MyReservationsPage() {
  const [reservations, setReservations] = useState(mockReservations);
  const [filter, setFilter] = useState('todas');
  const [showCancelMessage, setShowCancelMessage] = useState(false);
  
  // Filtrar reservas com base no status selecionado
  const filteredReservations = reservations.filter(reservation => {
    if (filter === 'todas') return true;
    if (filter === 'confirmadas') return reservation.status === 'Confirmada';
    if (filter === 'pendentes') return reservation.status === 'Pendente';
    if (filter === 'canceladas') return reservation.status === 'Cancelada';
    return true;
  });
  
  // Ordenar reservas por data (mais próximas primeiro)
  const sortedReservations = [...filteredReservations].sort((a, b) => {
    return new Date(a.date) - new Date(b.date);
  });
  
  const handleCancelReservation = (reservationId) => {
    // Aqui você enviaria a solicitação de cancelamento para o backend
    
    // Atualizar o estado local
    setReservations(prevReservations => 
      prevReservations.map(res => 
        res.id === reservationId ? { ...res, status: 'Cancelada' } : res
      )
    );
    
    // Mostrar mensagem de confirmação
    setShowCancelMessage(true);
    
    // Esconder a mensagem após 5 segundos
    setTimeout(() => {
      setShowCancelMessage(false);
    }, 5000);
  };
  
  return (
    <div className="my-reservations-page">
      <div className="reservations-header">
        <h1>Minhas Reservas</h1>
        <p>Gerencie suas reservas de salas</p>
      </div>
      
      {showCancelMessage && (
        <div className="cancel-message">
          <p>✅ Reserva cancelada com sucesso!</p>
        </div>
      )}
      
      <div className="filter-tabs">
        <button 
          className={filter === 'todas' ? 'active' : ''} 
          onClick={() => setFilter('todas')}
        >
          Todas
        </button>
        <button 
          className={filter === 'confirmadas' ? 'active' : ''} 
          onClick={() => setFilter('confirmadas')}
        >
          Confirmadas
        </button>
        <button 
          className={filter === 'pendentes' ? 'active' : ''} 
          onClick={() => setFilter('pendentes')}
        >
          Pendentes
        </button>
        <button 
          className={filter === 'canceladas' ? 'active' : ''} 
          onClick={() => setFilter('canceladas')}
        >
          Canceladas
        </button>
      </div>
      
      <div className="reservations-list">
        {sortedReservations.length > 0 ? (
          sortedReservations.map(reservation => (
            <ReservationCard
              key={reservation.id}
              reservation={reservation}
              onCancel={handleCancelReservation}
            />
          ))
        ) : (
          <div className="no-reservations">
            <p>Nenhuma reserva encontrada com o filtro selecionado.</p>
            {filter !== 'todas' && (
              <button className="view-all-button" onClick={() => setFilter('todas')}>
                Ver todas as reservas
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default MyReservationsPage;
