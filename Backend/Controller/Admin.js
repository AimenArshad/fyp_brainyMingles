import Admin from "../Models/Admin.js";
import bcrypt from 'bcrypt';

const addAdmin = async (req, res) => {
    try {
      const { name, email, password } = req.body;

      const saltRounds = 10; 
      // Hash the password using bcrypt
      const hashedPassword = await bcrypt.hash(password, saltRounds);

  
      // Create a new user instance
      const newUser = new Admin({
        name,
        email,
        password:hashedPassword,
      });
  
      // Save the user to the database
      const savedUser = await newUser.save();
  
      // Return the saved user as a JSON response
      res.status(201).json(savedUser);
    } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
    }
  };

  export {addAdmin}