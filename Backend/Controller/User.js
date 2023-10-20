//import bcrypt from 'bcryptjs';
//import jwt from'jsonwebtoken';
import User from "../Models/User.js";

//*******************Login*************************

const loginUser = async (req, res) => {
    try {
      console.log(req.body.email)
      const { email, password} = req.body;
      
      const users = await User.findOne({ email});
      console.log(users)
      if (users.length==0) {
        res.send('Invalid credentials');
      } else {
        // const isMatch = await bcrypt.compare(password, users.password);
        //   if (!isMatch) {
        //       return res.status(400).json({ error: "Invalid credentials" });
        //   }
  
        // let token
        // try{
  
        //   token=jwt.sign({_id:users._id},"Secret");
  
        // }catch(err){
  
        //   res.send(err)
        // }

       // res.header('Authorization', `Bearer ${token}`);
        res.status(200).json({email});
      }
    } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
    }
  };


  
const getUser = async (req, res) => {
  try {
    const users = await User.find({});
    if (users.length === 0) {
      res.status(404).json({ message: 'No users found' });
    } else {
      // Assuming you want to send the user data
      res.status(200).json(users);
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};



const createUser = async (req, res) => {
  try {
    // Assuming you have request data in the body
    const { name, email, password } = req.body;

    // Create a new user instance
    const newUser = new User({
      name,
      email,
      password,
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

  export { getUser,createUser,loginUser}