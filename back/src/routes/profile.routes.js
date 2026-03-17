/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	This file defines the routes for profile management.
**/
import { Router } from 'express';
import { showProfile, showProfileId, showProfileByUserId, addProfile, updateProfile, deleteProfile } from '../controllers/profile.controller.js';
import { verifyToken } from '../middleware/authMiddleware.js';

const router = Router();
const apiName = '/profile';

router.route(apiName)
    .get(verifyToken, showProfile)  // Get all profiles
    .post(verifyToken, addProfile); // Add profile

router.route(`${apiName}/:id`)
    .get(verifyToken, showProfileId)  // Get profile by Id
    .put(verifyToken, updateProfile)  // Update profile by Id
    .delete(verifyToken, deleteProfile); // Delete profile by Id

router.route(`${apiName}/user/:userId`)
    .get(verifyToken, showProfileByUserId);  // Get profile by User Id

export default router;
