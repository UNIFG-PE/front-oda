import React, { useState } from 'react';
import RoomCard from '../components/RoomCard';
import ReservationForm from '../components/ReservationForm';
import './RoomsPage.css';

// Dados mockados para as salas
const mockRooms = [
  {
    id: 1,
    name: 'Sala Executiva',
    location: 'Bloco A, 2º andar',
    description: 'Sala executiva com mesa de reunião para 10 pessoas, projetor e sistema de videoconferência.',
    capacity: 10,
    available: true,
    features: ['Projetor', 'Videoconferência', 'Ar-condicionado', 'Café'],
    image: 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1500&q=80'
  },
  {
    id: 2,
    name: 'Sala Criativa',
    location: 'Bloco B, Térreo',
    description: 'Espaço colaborativo com quadros brancos, puffs e mesas modulares para brainstorming e trabalho em equipe.',
    capacity: 8,
    available: true,
    features: ['Quadro branco', 'Mesas modulares', 'Puffs', 'Wi-Fi'],
    image: 'https://images.unsplash.com/photo-1497215842964-222b430dc094?ixlib=rb-4.0.3&auto=format&fit=crop&w=1500&q=80'
  },
  {
    id: 3,
    name: 'Sala de Treinamento',
    location: 'Bloco C, 1º andar',
    description: 'Sala ampla com configuração em formato de auditório, ideal para treinamentos e apresentações.',
    capacity: 20,
    available: true,
    features: ['Projetor', 'Sistema de som', 'Microfones', 'Ar-condicionado'],
    image: 'https://images.unsplash.com/photo-1517502884422-41eaead166d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1500&q=80'
  },
  {
    id: 4,
    name: 'Sala de Videoconferência',
    location: 'Bloco A, 3º andar',
    description: 'Sala equipada com sistema de videoconferência de alta definição e isolamento acústico.',
    capacity: 6,
    available: false,
    features: ['Videoconferência HD', 'Isolamento acústico', 'Smart TV', 'Ar-condicionado'],
    image: 'https://images.unsplash.com/photo-1516387938699-a93567ec168e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1500&q=80'
  },
  {
    id: 5,
    name: 'Sala Pequena',
    location: 'Bloco B, 2º andar',
    description: 'Sala compacta ideal para reuniões rápidas ou entrevistas com até 4 pessoas.',
    capacity: 4,
    available: true,
    features: ['TV', 'Quadro branco', 'Café', 'Wi-Fi'],
    image: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1500&q=80'
  },
  {
    id: 6,
    name: 'Auditório Principal',
    location: 'Bloco C, Térreo',
    description: 'Auditório com capacidade para 50 pessoas, ideal para eventos, palestras e apresentações.',
    capacity: 50,
    available: true,
    features: ['Projetor', 'Sistema de som', 'Palco', 'Ar-condicionado'],
    image: 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?ixlib=rb-4.0.3&auto=format&fit=crop&w=1500&q=80'
  }
];

function RoomsPage() {
  const [rooms] = useState(mockRooms);
  const [selectedRoom, setSelectedRoom] = useState(null);
  const [showReservationForm, setShowReservationForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [capacityFilter, setCapacityFilter] = useState('');
  const [showSuccessMessage, setShowSuccessMessage] = useState(false);
  
  // Filtrar salas com base na pesquisa e capacidade
  const filteredRooms = rooms.filter(room => {
    const matchesSearch = room.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
                         room.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         room.location.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesCapacity = capacityFilter === '' || room.capacity >= parseInt(capacityFilter);
    
    return matchesSearch && matchesCapacity;
  });
  
  const handleReserveClick = (roomId) => {
    const room = rooms.find(r => r.id === roomId);
    setSelectedRoom(room);
    setShowReservationForm(true);
  };
  
  const handleReservationSubmit = (reservation) => {
    // Aqui você enviaria os dados para o backend
    console.log('Reserva realizada:', reservation);
    
    // Fechar o formulário e mostrar mensagem de sucesso
    setShowReservationForm(false);
    setShowSuccessMessage(true);
    
    // Esconder a mensagem após 5 segundos
    setTimeout(() => {
      setShowSuccessMessage(false);
    }, 5000);
  };
  
  const handleReservationCancel = () => {
    setShowReservationForm(false);
  };
  
  return (
    <div className="rooms-page">
      <div className="rooms-header">
        <h1>Salas Disponíveis</h1>
        <p>Encontre e reserve a sala ideal para sua reunião ou evento</p>
      </div>
      
      <div className="filters">
        <div className="search-bar">
          <input
            type="text"
            placeholder="Buscar por nome, local ou descrição..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        
        <div className="capacity-filter">
          <label htmlFor="capacity">Capacidade mínima:</label>
          <select
            id="capacity"
            value={capacityFilter}
            onChange={(e) => setCapacityFilter(e.target.value)}
          >
            <option value="">Qualquer</option>
            <option value="4">4+ pessoas</option>
            <option value="8">8+ pessoas</option>
            <option value="10">10+ pessoas</option>
            <option value="20">20+ pessoas</option>
          </select>
        </div>
      </div>
      
      {showSuccessMessage && (
        <div className="success-message">
          <p>✅ Reserva realizada com sucesso! Um e-mail de confirmação foi enviado.</p>
        </div>
      )}
      
      <div className="rooms-grid">
        {filteredRooms.length > 0 ? (
          filteredRooms.map(room => (
            <RoomCard
              key={room.id}
              room={room}
              onReserve={handleReserveClick}
            />
          ))
        ) : (
          <div className="no-results">
            <p>Nenhuma sala encontrada com os filtros selecionados.</p>
          </div>
        )}
      </div>
      
      {showReservationForm && selectedRoom && (
        <div className="modal-overlay">
          <ReservationForm
            room={selectedRoom}
            onSubmit={handleReservationSubmit}
            onCancel={handleReservationCancel}
          />
        </div>
      )}
    </div>
  );
}

export default RoomsPage;
