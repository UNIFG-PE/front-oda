import React from 'react';
import './ReservationCard.css';

function ReservationCard({ reservation, onCancel }) {
  // Formatar a data para exibição
  const formatDate = (dateString) => {
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('pt-BR', options);
  };
  
  return (
    <div className="reservation-card">
      <div className="reservation-header">
        <h3>{reservation.room.name}</h3>
        <span className={`reservation-status ${reservation.status.toLowerCase()}`}>
          {reservation.status}
        </span>
      </div>
      
      <div className="reservation-details">
        <div className="detail-item">
          <span className="detail-label">Data:</span>
          <span className="detail-value">{formatDate(reservation.date)}</span>
        </div>
        
        <div className="detail-item">
          <span className="detail-label">Horário:</span>
          <span className="detail-value">{reservation.startTime} - {reservation.endTime}</span>
        </div>
        
        <div className="detail-item">
          <span className="detail-label">Participantes:</span>
          <span className="detail-value">{reservation.participants} pessoas</span>
        </div>
        
        <div className="detail-item">
          <span className="detail-label">Finalidade:</span>
          <span className="detail-value purpose">{reservation.purpose}</span>
        </div>
      </div>
      
      {reservation.status === 'Confirmada' && (
        <button className="cancel-reservation-button" onClick={() => onCancel(reservation.id)}>
          Cancelar Reserva
        </button>
      )}
    </div>
  );
}

export default ReservationCard;
