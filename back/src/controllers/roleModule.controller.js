/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Controller for role-module relationship operations - NODEJS
**/
import RoleModuleModel from '../models/roleModule.model.js';

export const showRoleModule = async (req, res) => {
    try {
        const roleModuleModel = new RoleModuleModel();
        roleModuleModel.showRoleModule(res);
    } catch (error) {
        res.status(500).json({ error: "Error fetching role modules", details: error.message });
    }
};

export const showRoleModuleId = async (req, res) => {
    try {
        const roleModuleModel = new RoleModuleModel();
        roleModuleModel.showRoleModuleById(res, req);
    } catch (error) {
        res.status(500).json({ error: "Error fetching role module", details: error.message });
    }
};

export const showRoleModuleByRoleId = async (req, res) => {
    try {
        const roleModuleModel = new RoleModuleModel();
        roleModuleModel.showRoleModuleByRoleId(res, req);
    } catch (error) {
        res.status(500).json({ error: "Error fetching role modules", details: error.message });
    }
};

export const addRoleModule = async (req, res) => {
    try {
        const roleModuleModel = new RoleModuleModel();
        roleModuleModel.addRoleModule(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error adding role module", details: error.message });
    }
};

export const updateRoleModule = async (req, res) => {
    try {
        const roleModuleModel = new RoleModuleModel();
        roleModuleModel.updateRoleModule(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error updating role module", details: error.message });
    }
};

export const deleteRoleModule = async (req, res) => {
    try {
        const roleModuleModel = new RoleModuleModel();
        roleModuleModel.deleteRoleModule(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error deleting role module", details: error.message });
    }
};
