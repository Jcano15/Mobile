/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	This code defines a `ProfileModel` class that provides methods for managing profiles in a database.
**/
import { connect } from '../config/db/connect.js';

class ProfileModel {
  constructor(id, email, name, photo, userId) {
    this.id = id;
    this.email = email;
    this.name = name;
    this.photo = photo;
    this.userId = userId;
  }

  async showProfile(res) {
    try {
      let sqlQuery = "SELECT * FROM profiles";
      const [result] = await connect.query(sqlQuery);
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({ error: "Error fetching profiles", details: error.message });
    }
  }

  async showProfileById(res, req) {
    try {
      const [result] = await connect.query('SELECT * FROM profiles WHERE Profile_id = ?', [req.params.id]);
      if (result.length === 0) return res.status(404).json({ error: "Profile not found" });
      res.status(200).json(result[0]);
    } catch (error) {
      res.status(500).json({ error: "Error fetching profile", details: error.message });
    }
  }

  async showProfileByUserId(res, req) {
    try {
      const [result] = await connect.query('SELECT * FROM profiles WHERE User_id_fk = ?', [req.params.userId]);
      if (result.length === 0) return res.status(404).json({ error: "Profile not found" });
      res.status(200).json(result[0]);
    } catch (error) {
      res.status(500).json({ error: "Error fetching profile", details: error.message });
    }
  }

  async addProfile(req, res) {
    try {
      const { email, name, photo, userId } = req.body;
      if (!email || !name || !userId) {
        return res.status(400).json({ error: "Missing required fields" });
      }
      let sqlQuery = "INSERT INTO profiles (Profile_email, Profile_name, Profile_photo, User_id_fk) VALUES (?,?,?,?)";
      const [result] = await connect.query(sqlQuery, [email, name, photo || null, userId]);
      res.status(201).json({
        data: [{ id: result.insertId, email, name, photo, userId }],
        status: 201
      });
    } catch (error) {
      res.status(500).json({ error: "Error adding profile", details: error.message });
    }
  }

  async updateProfile(req, res) {
    try {
      const { email, name, photo } = req.body;
      if (!email || !name) {
        return res.status(400).json({ error: "Missing required fields" });
      }
      let sqlQuery = "UPDATE profiles SET Profile_email=?, Profile_name=?, Profile_photo=?, updated_at=? WHERE Profile_id=?";
      const updated_at = new Date().toLocaleString("en-CA", { timeZone: "America/Bogota" }).replace(",", "").replace("/", "-").replace("/", "-");
      const [result] = await connect.query(sqlQuery, [email, name, photo || null, updated_at, req.params.id]);
      if (result.affectedRows === 0) return res.status(404).json({ error: "Profile not found" });
      res.status(200).json({
        data: [{ email, name, photo, updated_at }],
        status: 200,
        updated: result.affectedRows
      });
    } catch (error) {
      res.status(500).json({ error: "Error updating profile", details: error.message });
    }
  }

  async deleteProfile(req, res) {
    try {
      let sqlQuery = "DELETE FROM profiles WHERE Profile_id = ?";
      const [result] = await connect.query(sqlQuery, [req.params.id]);
      if (result.affectedRows === 0) return res.status(404).json({ error: "Profile not found" });
      res.status(200).json({
        data: [],
        status: 200,
        deleted: result.affectedRows
      });
    } catch (error) {
      res.status(500).json({ error: "Error deleting profile", details: error.message });
    }
  }
}

export default ProfileModel;
