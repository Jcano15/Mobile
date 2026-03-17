/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Controller for module-related operations - NODEJS
**/
import ModuleModel from '../models/module.model.js';

export const showModule = async (req, res) => {
    try {
        const moduleModel = new ModuleModel();
        moduleModel.showModule(res);
    } catch (error) {
        res.status(500).json({ error: "Error fetching modules", details: error.message });
    }
};

export const showModuleId = async (req, res) => {
    try {
        const moduleModel = new ModuleModel();
        moduleModel.showModuleById(res, req);
    } catch (error) {
        res.status(500).json({ error: "Error fetching module", details: error.message });
    }
};

export const addModule = async (req, res) => {
    try {
        const moduleModel = new ModuleModel();
        moduleModel.addModule(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error adding module", details: error.message });
    }
};

export const updateModule = async (req, res) => {
    try {
        const moduleModel = new ModuleModel();
        moduleModel.updateModule(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error updating module", details: error.message });
    }
};

export const deleteModule = async (req, res) => {
    try {
        const moduleModel = new ModuleModel();
        moduleModel.deleteModule(req, res);
    } catch (error) {
        res.status(500).json({ error: "Error deleting module", details: error.message });
    }
};
