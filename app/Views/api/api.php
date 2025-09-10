<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>API Documentation</title>
    <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@3.51.0/swagger-ui.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            background-color: #f5f5f5;
        }
        #swagger-ui {
            padding: 20px;
        }
        .header {
            background-color: #1b1b1b;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 {
            margin: 0;
            font-size: 1.5rem;
        }
        .auth-container {
            max-width: 400px;
            margin: 20px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .auth-container h2 { margin-top: 0; color: #333; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn { background-color: #4CAF50; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; font-size: 16px; width: 100%; }
        .btn:hover { background-color: #45a049; }
        .message { padding: 10px; margin: 10px 0; border-radius: 4px; display: none; }
        .error { background-color: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }
        .success { background-color: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
        .token-display { margin-top: 20px; padding: 10px; background-color: #f5f5f5; border-radius: 4px; word-break: break-all; display: none; }

        /* Isolated Swagger UI via iframe */
        .swagger-frame-wrap { height: 70vh; max-width: 1200px; margin: 20px auto; }
        #swagger-frame { width: 100%; height: 100%; border: 0; background: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
<div class="header">
    <h1>API Documentation</h1>
</div>

<div class="auth-container">
    <h2>Authentication</h2>
    <div id="error-message" class="message error"></div>
    <div id="success-message" class="message success"></div>

    <form id="auth-form">
        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required placeholder="sysadmin@viaanix.com">
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="btn">Authenticate</button>
    </form>

    <div id="token-display" class="token-display">
        <strong>Token:</strong> <span id="token-value"></span>
    </div>
</div>

<div class="swagger-frame-wrap">
    <iframe id="swagger-frame" src="/api/v2/docs"></iframe>
</div>

<script>
    document.getElementById('auth-form').addEventListener('submit', function(e) {
        e.preventDefault();

        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        document.getElementById('error-message').style.display = 'none';
        document.getElementById('success-message').style.display = 'none';

        fetch('/api/v2/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        })
        .then(r => r.json())
        .then(data => {
            if (data.success && data.token) {
                const successElement = document.getElementById('success-message');
                successElement.textContent = 'Authentication successful!';
                successElement.style.display = 'block';

                document.getElementById('token-value').textContent = data.token;
                document.getElementById('token-display').style.display = 'block';

                // Reload iframe with token so its requests include Authorization header
                const frame = document.getElementById('swagger-frame');
                frame.src = '/api/v2/docs?token=' + encodeURIComponent(data.token);
            } else {
                throw new Error(data.message || 'Authentication failed');
            }
        })
        .catch(err => {
            const errorElement = document.getElementById('error-message');
            errorElement.textContent = err.message;
            errorElement.style.display = 'block';
        });
    });
</script>
</body>
</html>