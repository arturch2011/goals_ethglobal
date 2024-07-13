import { env } from './env/env.js';
import { app } from './app.js'

app
  .listen({
    host: '0.0.0.0',
    port: env.PORT ?? 3000,
  })
  .then(() => {
    console.log('🚀 HTTP Server Running!')
  })
