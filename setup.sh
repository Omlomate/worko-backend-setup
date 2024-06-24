#!/bin/bash

# Create project directories
mkdir -p worko-backend/{controllers,services,daos,models,dtos,middlewares,validators,routes,tests,config}

# Create initial files with some content
touch worko-backend/.env
touch worko-backend/app.js
touch worko-backend/package.json
touch worko-backend/README.md

# Create controllers/userController.js
cat <<EOL > worko-backend/controllers/userController.js
const userService = require('../services/userService');
const UserDto = require('../dtos/userDto');

const getUsers = async (req, res) => {
  const users = await userService.getAllUsers();
  res.send(users.map(user => new UserDto(user)));
};

const getUserById = async (req, res) => {
  const user = await userService.getUserById(req.params.userId);
  if (!user) return res.status(404).send('User not found');
  res.send(new UserDto(user));
};

const createUser = async (req, res) => {
  const user = await userService.createUser(req.body);
  res.send(new UserDto(user));
};

const updateUser = async (req, res) => {
  const user = await userService.updateUser(req.params.userId, req.body);
  if (!user) return res.status(404).send('User not found');
  res.send(new UserDto(user));
};

const deleteUser = async (req, res) => {
  const user = await userService.deleteUser(req.params.userId);
  if (!user) return res.status(404).send('User not found');
  res.send(new UserDto(user));
};

module.exports = {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
};
EOL

# Create services/userService.js
cat <<EOL > worko-backend/services/userService.js
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
EOL

# Create daos/userDao.js
cat <<EOL > worko-backend/daos/userDao.js
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
EOL

# Create models/userModel.js
cat <<EOL > worko-backend/models/userModel.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  age: { type: Number, required: true },
  city: { type: String, required: true },
  zipCode: { type: String, required: true },
  isDeleted: { type: Boolean, default: false }
});

module.exports = mongoose.model('User', userSchema);
EOL

# Create dtos/userDto.js
cat <<EOL > worko-backend/dtos/userDto.js
class UserDto {
  constructor(user) {
    this.id = user._id;
    this.email = user.email;
    this.name = user.name;
    this.age = user.age;
    this.city = user.city;
    this.zipCode = user.zipCode;
  }
}

module.exports = UserDto;
EOL

# Create middlewares/authMiddleware.js
cat <<EOL > worko-backend/middlewares/authMiddleware.js
const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) return res.status(401).send('Access Denied');
  
  const token = authHeader.split(' ')[1];
  if (!token) return res.status(401).send('Access Denied');

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified;
    next();
  } catch (err) {
    res.status(400).send('Invalid Token');
  }
};

module.exports = authMiddleware;
EOL

# Create middlewares/validationMiddleware.js
cat <<EOL > worko-backend/middlewares/validationMiddleware.js
const userSchema = require('../validators/userValidator');

const validateUser = (req, res, next) => {
  const { error } = userSchema.validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);
  next();
};

module.exports = validateUser;
EOL

# Create validators/userValidator.js
cat <<EOL > worko-backend/validators/userValidator.js
const Joi = require('joi');

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  name: Joi.string().required(),
  age: Joi.number().required(),
  city: Joi.string().required(),
  zipCode: Joi.string().pattern(new RegExp('^[0-9]{5}$')).required()
});

module.exports = userSchema;
EOL

# Create routes/userRoutes.js
cat <<EOL > worko-backend/routes/userRoutes.js
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
EOL

# Create tests/userController.test.js
cat <<EOL > worko-backend/tests/userController.test.js
const request = require('supertest');
const app = require('../app');
const mongoose = require('mongoose');

describe('User API', () => {
  beforeAll(async () => {
    await mongoose.connect(process.env.DB_URI, { useNewUrlParser: true, useUnifiedTopology: true });
  });

  afterAll(async () => {
    await mongoose.disconnect();
  });

  it('should create a new user', async () => {
    const response = await request(app)
      .post('/worko/user')
      .send({
        email: 'test@example.com',
        name: 'Test User',
        age: 25,
        city: 'Test City',
        zipCode: '12345'
      });
    expect(response.status).toBe(200);
    expect(response.body.email).toBe('test@example.com');
  });

  // Additional tests for other endpoints can be added similarly
});
EOL

# Create config/dbConfig.js
cat <<EOL > worko-backend/config/dbConfig.js
require('dotenv').config();
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.DB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB connected');
  } catch (err) {
    console.error('MongoDB connection error:', err);
    process.exit(1);
  }
};

module.exports = connectDB;
EOL

# Create app.js
cat <<EOL > worko-backend/app.js
require('dotenv').config();
const express = require('express');
const connectDB = require('./config/dbConfig');
const userRoutes = require('./routes/userRoutes');
const authMiddleware = require('./middlewares/authMiddleware');

const app = express();
const port = process.env.PORT || 3000;

connectDB();
app.use(express.json());
app.use(authMiddleware);
app.use('/worko/user', userRoutes);

app.listen(port, () => {
  console.log(\`Server running on port \${port}\`);
});

module.exports = app;
EOL

# Create README.md
cat <<EOL > worko-backend/README.md
# Worko Backend

## Setup

1. Clone the repository
2. Run \`npm install\` to install dependencies
3. Create a \`.env\` file in the root directory with the following content:
    \`\`\`
    PORT=3000
    DB_URI=mongodb://localhost:27017/worko
    JWT_SECRET=your_jwt_secret
    \`\`\`
4. Run the application using \`npm start\`
5. To run tests, use \`npm test\`

## API Endpoints

### /worko/user
- \`GET /worko/user\` - List all users
- \`GET /worko/user/:userId\` - Get user details
- \`POST /worko/user\` - Create user
- \`PUT /worko/user/:userId\` - Update user
- \`PATCH /worko/user/:userId\` - Update user
- \`DELETE /worko/user/:userId\` - Soft delete user

### Authentication
- All endpoints require basic authentication using a JWT token.
EOL

# Initialize npm and install dependencies
cd worko-backend
npm init -y
npm install express mongoose joi dotenv bcryptjs jsonwebtoken jest supertest --save
npm install nodemon --save-dev
