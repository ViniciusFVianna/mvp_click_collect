import cors from 'cors';
import express from 'express';
import indexRoutes from './routes/index-routes.js';
import { errorHandler } from './middlewares/error-handler.js';

const app = express();

app.disable('x-powered-by');
app.use(cors());
app.use(express.json({ limit: '100kb' }));
app.use(express.urlencoded({ extended: true }));
app.use('/', indexRoutes);
app.use(errorHandler);

export default app;
