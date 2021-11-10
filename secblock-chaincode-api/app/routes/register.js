const express = require('express');

const registerController = require('../controllers/users/register');

const router = express.Router();

router.get('/register', registerController.register);

module.exports  =  router;