import Student from "../Models/Student.js";
import Mentors from "../Models/Mentor.js";
import Admin from "../Models/Admin.js";
import Faculty from "../Models/Faculty.js";
import bcrypt from 'bcrypt';
import jwt from'jsonwebtoken';
const loginUser = async (req, res) => {
    try {
      const { email, password } = req.body;
  
      // Try to find the user in each relevant collection
      const student = await Student.findOne({ email });
      const mentor = await Mentors.findOne({ email });
      const admin = await Admin.findOne({ email });
      const faculty = await Faculty.findOne({ email });
  
      // Check if the user exists in any of the collections
      const user = student || mentor || admin || faculty;
  
      if (!user) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }
  
      // Verify the password using bcrypt
      const isMatch = await bcrypt.compare(password, user.password);
  
      if (!isMatch) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }
  
      // Determine the user's role based on the collection where they were found
      let role;
      if (student) role = 'student';
      else if (mentor) role = 'mentor';
      else if (admin) role = 'admin';
      else if (faculty) role = 'faculty';

       let token
        try{
  
          token=jwt.sign({email:user.email},"Secret");
  
        }catch(err){
  
          res.send(err)
        }

  
      res.status(200).json({ role, email,token });
    } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
    }
  };
  

export{loginUser}