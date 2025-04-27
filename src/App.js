function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Teste Canary Deployment</h1>
        <p>Versão: {process.env.REACT_APP_VERSION || '1.0.0'}</p>
      </header>
    </div>
  );
}

export default App;
