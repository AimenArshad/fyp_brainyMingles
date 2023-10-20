import MentorshipRequest from '../Models/MentorshipRequests.js'
import Mentor from '../Models/Mentor.js';
import Faculty from '../Models/Faculty.js'
import bcrypt from 'bcrypt';
import nodemailer from 'nodemailer';
  
  const getmentorshipRequests = async (req, res) => {

    try {
        const mentorshipRequests = await MentorshipRequest.find();
        res.status(200).json(mentorshipRequests);
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching mentorship requests' });
      }

  }

 
const addFaculty = async (req, res) => {
    try {
      const { name, email, password } = req.body;

      const saltRounds = 10; 
      // Hash the password using bcrypt
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      // Create a new user instance
      const newUser = new Faculty({
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




  const approveMentors = async (req, res) => {

        const {email} = req.body;
        console.log(email)
      
        try {
          const mentorshipRequest = await MentorshipRequest.findOne({email});
      
          if (!mentorshipRequest) {
            return res.status(404).json({ error: 'Mentorship request not found' });
          }
      
            // Create a new mentor document from the mentorship request data
            const mentorData = {
              name: mentorshipRequest.name,
              username: mentorshipRequest.username,
              email: mentorshipRequest.email,
              phoneNumber: mentorshipRequest.phoneNumber,
              password: mentorshipRequest.password,
              expertise: mentorshipRequest.expertise,
              skills: mentorshipRequest.skills,
              budget:mentorshipRequest.budget,
              preferences: {
                gender: mentorshipRequest.preferences.gender, // Array of gender preferences
                mode: mentorshipRequest.preferences.mode, // Array of mode preferences
                session: mentorshipRequest.preferences.session, // Array of session preferences
              },
            };
      
            // Save the mentor to the database
            const mentor = new Mentor(mentorData);
            await mentor.save();
      

          // Remove the mentorship request from the database
          await MentorshipRequest.deleteOne({ email: email });
          
          res.status(200).json({ message: `Mentorship request accepted successfully` });
      
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching mentorship requests' });
      }

  }


  const rejectMentors = async (req, res) => {

    const {email} = req.body;
      
    try {
      const mentorshipRequest = await MentorshipRequest.findOne({email});
  
      if (!mentorshipRequest) {
        return res.status(404).json({ error: 'Mentorship request not found' });
      }
  
      // Remove the mentorship request from the database
      await MentorshipRequest.deleteOne({ email: email });
      
      res.status(200).json({ message: `Mentorship request rejected successfully` });
  
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while fetching mentorship requests' });
  }
  }

  export {getmentorshipRequests,approveMentors,addFaculty,rejectMentors}