import React from 'react';
import './RoomCard.css';

function RoomCard({ room, onReserve }) {
  return (
    <div className="room-card">
      <div className="room-image">
        <img src={room.image || `https://via.placeholder.com/300x200?text=${room.name}`} alt={room.name} />
        <span className="room-capacity">{room.capacity} pessoas</span>
      </div>
      <div className="room-info">
        <h3>{room.name}</h3>
        <p className="room-location">{room.location}</p>
        <p className="room-description">{room.description}</p>
        <div className="room-features">
          {room.features.map((feature, index) => (
            <span key={index} className="feature">{feature}</span>
          ))}
        </div>
      </div>
      <button 
        className="reserve-button" 
        onClick={() => onReserve(room.id)}
        disabled={!room.available}
      >
        {room.available ? 'Reservar' : 'Indisponível'}
      </button>
    </div>
  );
}

export default RoomCard;
