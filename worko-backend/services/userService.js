const userDao = require('../daos/userDao');

const getAllUsers = () => {
  return userDao.getAllUsers();
};

const getUserById = (userId) => {
  return userDao.getUserById(userId);
};

const createUser = (userData) => {
  return userDao.createUser(userData);
};

const updateUser = (userId, userData) => {
  return userDao.updateUser(userId, userData);
};

const deleteUser = (userId) => {
  return userDao.deleteUser(userId);
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
};
