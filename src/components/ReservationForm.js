import React, { useState } from 'react';
import './ReservationForm.css';

function ReservationForm({ room, onSubmit, onCancel }) {
  const [date, setDate] = useState('');
  const [startTime, setStartTime] = useState('');
  const [endTime, setEndTime] = useState('');
  const [participants, setParticipants] = useState(1);
  const [purpose, setPurpose] = useState('');
  
  const handleSubmit = (e) => {
    e.preventDefault();
    
    const reservation = {
      roomId: room.id,
      date,
      startTime,
      endTime,
      participants,
      purpose
    };
    
    onSubmit(reservation);
  };
  
  // Obter a data de hoje no formato YYYY-MM-DD para o min do input de data
  const today = new Date().toISOString().split('T')[0];
  
  return (
    <div className="reservation-form-container">
      <div className="reservation-form-header">
        <h2>Reservar Sala: {room.name}</h2>
        <button className="close-button" onClick={onCancel}>&times;</button>
      </div>
      
      <form className="reservation-form" onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="date">Data</label>
          <input
            type="date"
            id="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
            min={today}
            required
          />
        </div>
        
        <div className="form-row">
          <div className="form-group">
            <label htmlFor="startTime">Hora de Início</label>
            <input
              type="time"
              id="startTime"
              value={startTime}
              onChange={(e) => setStartTime(e.target.value)}
              required
            />
          </div>
          
          <div className="form-group">
            <label htmlFor="endTime">Hora de Término</label>
            <input
              type="time"
              id="endTime"
              value={endTime}
              onChange={(e) => setEndTime(e.target.value)}
              required
            />
          </div>
        </div>
        
        <div className="form-group">
          <label htmlFor="participants">Número de Participantes</label>
          <input
            type="number"
            id="participants"
            value={participants}
            onChange={(e) => setParticipants(parseInt(e.target.value))}
            min="1"
            max={room.capacity}
            required
          />
          <small>Máximo: {room.capacity} pessoas</small>
        </div>
        
        <div className="form-group">
          <label htmlFor="purpose">Finalidade da Reserva</label>
          <textarea
            id="purpose"
            value={purpose}
            onChange={(e) => setPurpose(e.target.value)}
            placeholder="Descreva brevemente o propósito da reunião"
            required
          />
        </div>
        
        <div className="form-actions">
          <button type="button" className="cancel-button" onClick={onCancel}>Cancelar</button>
          <button type="submit" className="submit-button">Confirmar Reserva</button>
        </div>
      </form>
    </div>
  );
}

export default ReservationForm;
