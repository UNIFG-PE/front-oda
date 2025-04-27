import { render, screen } from '@testing-library/react';
import App from './App';

test('renders canary deployment title', () => {
  render(<App />);
  const titleElement = screen.getByText(/teste canary deployment/i);
  expect(titleElement).toBeInTheDocument();
});

test('renders version text', () => {
  render(<App />);
  const versionElement = screen.getByText(/versão:/i);
  expect(versionElement).toBeInTheDocument();
});
