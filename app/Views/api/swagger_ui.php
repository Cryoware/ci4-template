<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Swagger UI</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.29.0/swagger-ui.css">
  <style>
    html, body { margin: 0; padding: 0; height: 100%; }
    #swagger-ui { height: 100%; }
  </style>
</head>
<body>
  <div id="swagger-ui"></div>

  <script src="https://unpkg.com/swagger-ui-dist@5.29.0/swagger-ui-bundle.js"></script>
  <script>
    // Read token from query string (same-origin, controlled page)
    const params = new URLSearchParams(window.location.search);
    const token = params.get('token');

    SwaggerUIBundle({
      url: '/api/v2/swagger.yaml',
      dom_id: '#swagger-ui',
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.presets.standalone
      ],
      requestInterceptor: (req) => {
        if (token) req.headers.Authorization = 'Bearer ' + token;
        return req;
      }
    });
  </script>
</body>
</html>
