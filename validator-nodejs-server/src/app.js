import fastify from 'fastify';

import { validateImageRoutes } from './http/controllers/validate-image/route.js';

const app = fastify({
    logger: true
});

app.register(validateImageRoutes)

export { app }