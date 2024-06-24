const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const validateUser = require('../middlewares/validationMiddleware');

router.get('/', userController.getUsers);
router.get('/:userId', userController.getUserById);
router.post('/', validateUser, userController.createUser);
router.put('/:userId', validateUser, userController.updateUser);
router.patch('/:userId', validateUser, userController.updateUser);
router.delete('/:userId', userController.deleteUser);

module.exports = router;
