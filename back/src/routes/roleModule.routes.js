/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	This file defines the routes for role-module relationship management.
**/
import { Router } from 'express';
import { showRoleModule, showRoleModuleId, showRoleModuleByRoleId, addRoleModule, updateRoleModule, deleteRoleModule } from '../controllers/roleModule.controller.js';
import { verifyToken } from '../middleware/authMiddleware.js';

const router = Router();
const apiName = '/roleModule';

router.route(apiName)
    .get(verifyToken, showRoleModule)  // Get all role modules
    .post(verifyToken, addRoleModule); // Add role module

router.route(`${apiName}/:id`)
    .get(verifyToken, showRoleModuleId)  // Get role module by Id
    .put(verifyToken, updateRoleModule)  // Update role module by Id
    .delete(verifyToken, deleteRoleModule); // Delete role module by Id

router.route(`${apiName}/role/:roleId`)
    .get(verifyToken, showRoleModuleByRoleId);  // Get modules by Role Id

export default router;
