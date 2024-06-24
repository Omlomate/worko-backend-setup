const userSchema = require('../validators/userValidator');

const validateUser = (req, res, next) => {
  const { error } = userSchema.validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);
  next();
};

module.exports = validateUser;
