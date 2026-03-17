/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	This file defines the routes for module management.
**/
import { Router } from 'express';
import { showModule, showModuleId, addModule, updateModule, deleteModule } from '../controllers/module.controller.js';
import { verifyToken } from '../middleware/authMiddleware.js';

const router = Router();
const apiName = '/module';

router.route(apiName)
    .get(verifyToken, showModule)  // Get all modules
    .post(verifyToken, addModule); // Add module

router.route(`${apiName}/:id`)
    .get(verifyToken, showModuleId)  // Get module by Id
    .put(verifyToken, updateModule)  // Update module by Id
    .delete(verifyToken, deleteModule); // Delete module by Id

export default router;
