const User = require('../models/userModel');

const getAllUsers = () => {
  return User.find({ isDeleted: false });
};

const getUserById = (userId) => {
  return User.findById(userId);
};

const createUser = (userData) => {
  const user = new User(userData);
  return user.save();
};

const updateUser = (userId, userData) => {
  return User.findByIdAndUpdate(userId, userData, { new: true });
};

const deleteUser = (userId) => {
  return User.findByIdAndUpdate(userId, { isDeleted: true }, { new: true });
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
};
