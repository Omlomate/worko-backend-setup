const Joi = require('joi');

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  name: Joi.string().required(),
  age: Joi.number().required(),
  city: Joi.string().required(),
  zipCode: Joi.string().pattern(new RegExp('^[0-9]{5}$')).required()
});

module.exports = userSchema;
