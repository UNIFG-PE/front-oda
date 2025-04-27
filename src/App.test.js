import { render, screen } from '@testing-library/react';
import App from './App';

test('renders ODA header', () => {
  render(<App />);
  const logoElement = screen.getByText('ODA', { selector: 'h1' });
  expect(logoElement).toBeInTheDocument();
});

test('renders navigation links', () => {
  render(<App />);
  const homeLink = screen.getByRole('link', { name: /home/i });
  const reservasLink = screen.getByRole('link', { name: /minhas reservas/i });
  const salasLink = screen.getByRole('link', { name: /salas$/i });

  expect(homeLink).toBeInTheDocument();
  expect(reservasLink).toBeInTheDocument();
  expect(salasLink).toBeInTheDocument();
});
