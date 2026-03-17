/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	This code defines a `RoleModuleModel` class that provides methods for managing role-module relationships in a database.
**/
import { connect } from '../config/db/connect.js';

class RoleModuleModel {
    constructor(id, moduleFk, roleFk) {
        this.id = id;
        this.moduleFk = moduleFk;
        this.roleFk = roleFk;
    }

    async showRoleModule(res) {
        try {
            let sqlQuery = "SELECT rm.*, m.Modules_name, r.Roles_name FROM role_modules rm LEFT JOIN modules m ON rm.Modules_fk = m.Modules_id LEFT JOIN roles r ON rm.Roles_fk = r.Roles_id";
            const [result] = await connect.query(sqlQuery);
            res.status(200).json(result);
        } catch (error) {
            res.status(500).json({ error: "Error fetching role modules", details: error.message });
        }
    }

    async showRoleModuleById(res, req) {
        try {
            const [result] = await connect.query('SELECT rm.*, m.Modules_name, r.Roles_name FROM role_modules rm LEFT JOIN modules m ON rm.Modules_fk = m.Modules_id LEFT JOIN roles r ON rm.Roles_fk = r.Roles_id WHERE rm.RoleModules_id = ?', [req.params.id]);
            if (result.length === 0) return res.status(404).json({ error: "Role Module not found" });
            res.status(200).json(result[0]);
        } catch (error) {
            res.status(500).json({ error: "Error fetching role module", details: error.message });
        }
    }

    async showRoleModuleByRoleId(res, req) {
        try {
            const [result] = await connect.query('SELECT rm.*, m.Modules_name, r.Roles_name FROM role_modules rm LEFT JOIN modules m ON rm.Modules_fk = m.Modules_id LEFT JOIN roles r ON rm.Roles_fk = r.Roles_id WHERE rm.Roles_fk = ?', [req.params.roleId]);
            res.status(200).json(result);
        } catch (error) {
            res.status(500).json({ error: "Error fetching role modules", details: error.message });
        }
    }

    async addRoleModule(req, res) {
        try {
            const { moduleFk, roleFk } = req.body;
            if (!moduleFk || !roleFk) {
                return res.status(400).json({ error: "Missing required fields" });
            }
            let sqlQuery = "INSERT INTO role_modules (Modules_fk, Roles_fk) VALUES (?,?)";
            const [result] = await connect.query(sqlQuery, [moduleFk, roleFk]);
            res.status(201).json({
                data: [{ id: result.insertId, moduleFk, roleFk }],
                status: 201
            });
        } catch (error) {
            res.status(500).json({ error: "Error adding role module", details: error.message });
        }
    }

    async updateRoleModule(req, res) {
        try {
            const { moduleFk, roleFk } = req.body;
            if (!moduleFk || !roleFk) {
                return res.status(400).json({ error: "Missing required fields" });
            }
            let sqlQuery = "UPDATE role_modules SET Modules_fk=?, Roles_fk=?, updated_at=? WHERE RoleModules_id=?";
            const updated_at = new Date().toLocaleString("en-CA", { timeZone: "America/Bogota" }).replace(",", "").replace("/", "-").replace("/", "-");
            const [result] = await connect.query(sqlQuery, [moduleFk, roleFk, updated_at, req.params.id]);
            if (result.affectedRows === 0) return res.status(404).json({ error: "Role Module not found" });
            res.status(200).json({
                data: [{ moduleFk, roleFk, updated_at }],
                status: 200,
                updated: result.affectedRows
            });
        } catch (error) {
            res.status(500).json({ error: "Error updating role module", details: error.message });
        }
    }

    async deleteRoleModule(req, res) {
        try {
            let sqlQuery = "DELETE FROM role_modules WHERE RoleModules_id = ?";
            const [result] = await connect.query(sqlQuery, [req.params.id]);
            if (result.affectedRows === 0) return res.status(404).json({ error: "Role Module not found" });
            res.status(200).json({
                data: [],
                status: 200,
                deleted: result.affectedRows
            });
        } catch (error) {
            res.status(500).json({ error: "Error deleting role module", details: error.message });
        }
    }
}

export default RoleModuleModel;
