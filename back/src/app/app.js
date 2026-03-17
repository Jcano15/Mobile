/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Application setup for the API - NODEJS
**/
import express from 'express';
import cors from 'cors';
import userRoutes from '../routes/user.routes.js';
import userStatusRoutes from '../routes/userStatus.routes.js';
import roleRoutes from '../routes/role.routes.js';
import userApiRoutes from '../routes/apiUser.routes.js';
import profileRoutes from '../routes/profile.routes.js';
import moduleRoutes from '../routes/module.routes.js';
import roleModuleRoutes from '../routes/roleModule.routes.js';

// Create an instance of the Express application
const app = express();
// Enable CORS for all origins
app.use(cors());
// Define the base path for the API
const NAME_API = '/api_v1';
// Middleware to handle JSON
app.use(express.json());

// Routes for the API
app.use(NAME_API, userRoutes);
app.use(NAME_API, userStatusRoutes);
app.use(NAME_API, roleRoutes);
app.use(NAME_API, userApiRoutes);
app.use(NAME_API, profileRoutes);
app.use(NAME_API, moduleRoutes);
app.use(NAME_API, roleModuleRoutes);

// Health check route for debugging
app.get(`${NAME_API}/health`, (req, res) => {
  res.status(200).json({ status: 'OK', message: 'API is working' });
});


// Handle 404 errors for undefined routes
app.use((req, res, next) => {
  res.status(404).json({
    message: 'Endpoint losses 404, not found'
  });
});

export default app;