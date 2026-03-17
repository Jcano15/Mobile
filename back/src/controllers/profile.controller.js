/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Controller for profile-related operations - NODEJS
**/
import ProfileModel from '../models/profile.model.js';

export const showProfile = async (req, res) => {
    try {
        const profileModel = new ProfileModel();
        profileModel.showProfile(res);
    } catch (error) {
        res.status(500).json({ error: "Error fetching profiles", details: error.message });
    }
};

export const showProfileId = async (req, res) => {
    try {
        const profileModel = new ProfileModel();
        profileModel.showProfileById(res, req);
    } catch (error) {
        res.status(500).json({ error: "Error fetching profile", details: error.message });
    }
};

export const showProfileByUserId = async (req, res) => {
    try {
        const profileModel = new ProfileModel();
        profileModel.showProfileByUserId(res, req);
    } catch (error) {
        res.status(500).json({ error: "Error fetching profile", details: error.message });
    }
};

export const addProfile = async (req, res) => {
    try {
        const profileModel = new ProfileModel();
        profileModel.addProfile(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error adding profile", details: error.message });
    }
};

export const updateProfile = async (req, res) => {
    try {
        const profileModel = new ProfileModel();
        profileModel.updateProfile(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error updating profile", details: error.message });
    }
};

export const deleteProfile = async (req, res) => {
    try {
        const profileModel = new ProfileModel();
        profileModel.deleteProfile(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error deleting profile", details: error.message });
    }
};
