document.getElementById('loginForm').addEventListener('submit', async function(event) {
    event.preventDefault();
  
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
  
    try {
      const response = await fetch('http://localhost:5000/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      });
  
      const data = await response.json();
  
      if (response.ok) {
        localStorage.setItem('token', data.token);
        window.location.href = 'dashboard.html';
      } else {
        document.getElementById('errorMessage').textContent = data.message || 'Credenciales incorrectas';
      }
    } catch (error) {
      console.error('Error:', error);
      document.getElementById('errorMessage').textContent = 'Error al iniciar sesión';
    }
  });