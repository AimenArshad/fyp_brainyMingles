import MentorshipRequest from '../Models/MentorshipRequests.js'
import Mentor from '../Models/Mentor.js';
import Faculty from '../Models/Faculty.js'
import bcrypt from 'bcrypt';
import nodemailer from 'nodemailer';
import { spawn } from 'child_process';
import Recommendation from '../Models/Recommendations.js';
  
  
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
          domains: mentorshipRequest.domains,
          languages: mentorshipRequest.languages,
          budget:mentorshipRequest.budget,
          gender: mentorshipRequest.gender, // Array of gender preferences
          mode: mentorshipRequest.mode, // Array of mode preferences
          session: mentorshipRequest.session, // Array of session preferences
          availability: mentorshipRequest.availability
          
        };
  
        // Save the mentor to the database
        const mentor = new Mentor(mentorData);
        await mentor.save();
  

      // Remove the mentorship request from the database
      await MentorshipRequest.deleteOne({ email: email });
      
      res.status(200).json({ message: `Mentorship request accepted successfully` });
      if(res.statusCode === 200){
        console.log("Mentorship request accepted successfully")
        const mentorsFromDB = await Mentor.find();
        const mentorsDataJson = JSON.stringify(mentorsFromDB);
        const studentFromDB = await Student.find();
        const studentDataJson = JSON.stringify(studentFromDB);
        const pythonProcess = spawn('python', ['AI_model/mentor_recommendation2.py', studentDataJson, mentorsDataJson]);
        pythonProcess.stdout.on('data', (data) => {
          try {
            const jsonString = data.toString().trim(); // Trim any extra whitespaces
            console.log('Data received from Python script:', jsonString);
    
            const recommendations = JSON.parse(jsonString);
            console.log(recommendations);
            for (const studentId in recommendations) {
              const newRecommendations = recommendations[studentId];
              updateRecommendations(studentId, newRecommendations);
          }
    
        } catch (error) {
            console.error('Error parsing or updating recommendations:', error.message);
        }
        
      });
    }
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

  const updateRecommendations = async (studentId, recommendationIds) => {
    try {
      // Find the student in the recommendation table
      const existingRecommendation = await Recommendation.findOne({ studentId });

      if (existingRecommendation) {
          // StudentId exists, update the recommendations
          const mentors = await Mentor.find({ _id: { $in: recommendationIds } });
          existingRecommendation.mentors = mentors.map(mentor => ({mentorObject: mentor}));
          await existingRecommendation.save();
          console.log(`Recommendations for ${studentId} updated:`, existingRecommendation.mentors);
      } else {
          // StudentId doesn't exist, create a new recommendation entry
          const mentors = await Mentor.find({ _id: { $in: recommendationIds } });
          const newRecommendation = new Recommendation({
              studentId,
              mentors: mentors.map(mentor => ({mentorObject: mentor}))
          });
          await newRecommendation.save();
          console.log(`New recommendations added for ${studentId}:`, newRecommendation.mentors);
      }
  } catch (error) {
      console.error(`Error updating recommendations for ${studentId}:`, error.message);
  }
}

  export {getmentorshipRequests,approveMentors,addFaculty,rejectMentors}