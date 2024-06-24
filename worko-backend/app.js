const path = require('path'); // Import the path module
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
const express = require('express');
const app = express();
const connectDB = require('./config/dbConfig');
const userRoutes = require('./routes/userRoutes');
const authMiddleware = require('./middlewares/authMiddleware');

const port = process.env.PORT || 3000;

connectDB();
app.use(express.json());
app.use(authMiddleware);
app.use('/worko/user', userRoutes);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

module.exports = app;
