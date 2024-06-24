# Worko Backend

## Setup

1. Clone the repository
2. Run `npm install` to install dependencies
3. Create a `.env` file in the root directory with the following content:
    ```
    PORT=3000
    DB_URI=mongodb://localhost:27017/worko
    JWT_SECRET=your_jwt_secret
    ```
4. Run the application using `npm start`
5. To run tests, use `npm test`

## API Endpoints

### /worko/user
- `GET /worko/user` - List all users
- `GET /worko/user/:userId` - Get user details
- `POST /worko/user` - Create user
- `PUT /worko/user/:userId` - Update user
- `PATCH /worko/user/:userId` - Update user
- `DELETE /worko/user/:userId` - Soft delete user

### Authentication
- All endpoints require basic authentication using a JWT token.
