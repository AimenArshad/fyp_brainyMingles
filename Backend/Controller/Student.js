import SessionRequest from '../Models/SessionRequests.js';
import Student from '../Models/Student.js'
import bcrypt from 'bcrypt';
import Mentors from '../Models/Mentor.js';
import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  service: 'Gmail',
  auth: {
    user: 'aimenarshad371@gmail.com',
    pass: 'gkhb xbhj cukp dwnr',
  },
});

var tempOtp=''
const verifyEmail = async (req, res) => {
  try {
    const {email} = req.body

    const student = await Student.findOne({ email });
    if (!student){
    const otp = generateOTP();
    tempOtp = otp
    sendOTP(email, otp, res); // Pass 'res' as a parameter
    }
    else{
      console.log("Email Already Registered.")
      res.send('Email already Registered')
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};



const generateOTP = () => {
  const otp = `${Math.floor(1000 + Math.random() * 9000)}`;
  return otp;
};

const sendOTP = (email, otp, res) => {
  try {
    const mailOptions = {
      from: 'aimenarshad371@gmail.com',
      to: email,
      subject: 'Registration Confirmation',
      text: `Your code for successful registration is ${otp}.`,
    };
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error(error);
      } else {
        console.log('Email sent: ' + info.response);
        res.send('Email Sent')
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};

const verifyOTP = async (req, res) => {
  try {
    const CheckOTP = tempOtp
    // Check if the provided OTP matches the stored OTP
    try {
      const {
        name,
        username,
        email,
        phoneNumber,
        password,
        programmingDomains,
        programmingLanguages,
        challenges,
        preferences,
        otp
      } = req.body;
  
      console.log(name+username+email+phoneNumber+password)
      console.log(programmingDomains)
      console.log(programmingLanguages)
      console.log(challenges)
      console.log(preferences)
      console.log(otp)
      console.log(CheckOTP)
      if (otp != CheckOTP) {
        return res.status(400).json({ message: 'Invalid OTP' });
      }

      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      const studentUsername = username + 'S01';
  
      const student = new Student({
        name,
        username: studentUsername,
        email,
        phoneNumber,
        password: hashedPassword,
        programmingDomains,
        programmingLanguages,
        challenges,
        preferences: {
          gender: preferences.gender,
          mode: preferences.mode,
          session: preferences.session,
        }
      });
      await student.save();
      res.status(201).json({ message: 'Student registered successfully' });

    // Clear the stored OTP after it has been used
      tempOtp = '';

  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
  }catch(error){
    console.error(error);
  }
};

  
  const createSessionRequest = async (req, res) => {
    try {
      const { mentorEmail, sessionRequests } = req.body;
      const studentEmail=req.body.email;
      console.log(studentEmail)

      console.log(sessionRequests)
      // Find the existing session request for the mentor
      let existingSessionRequest = await SessionRequest.findOne({ mentorEmail });
  
      // If there's no existing session request, create a new one
      if (!existingSessionRequest) {
        existingSessionRequest = new SessionRequest({
          mentorEmail,
          sessionRequests: [],
        });
      }
  
      // Iterate through the new session requests
      for (const newRequest of sessionRequests) {
        const { studentEmail, sessionType, time, topic } = newRequest;
  
        // Check if the student email already exists in the existing session requests
        const existingStudentRequest = existingSessionRequest.sessionRequests.find(
          (request) => request.studentEmail === studentEmail
        );
  
        if (existingStudentRequest) {
          // Increment the session limit for the existing student
          if (existingStudentRequest.sessionLimit) {
            existingStudentRequest.sessionLimit += 1;
          } else {
            existingStudentRequest.sessionLimit = 1;
          }
  
          // Check if the session limit is not exceeded
          if (existingStudentRequest.sessionLimit > 3) {
            // The session limit is exceeded for this student, return an error message
            return res.status(400).json({ error: 'Session request limit reached for this student' });
          }
  
          // Add the new session to the existing student's request
          existingStudentRequest.sessions.push({ sessionType, time, topic });
        } else {
          // If the student email doesn't exist, create a new student request
          existingSessionRequest.sessionRequests.push({
            studentEmail,
            sessionLimit: 1, // Initialize the session limit for the new student
            sessions: [{ sessionType, time, topic }],
          });
        }
      }
  
      // Save the updated session request to the database
      await existingSessionRequest.save();
  
      res.status(201).json({ message: 'Session request updated successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
    }
  };
  
  
  
  
  const findMentors = async (req, res) => {
    try {
      const mentors = await Mentors.find().select('name email expertise budget');
      res.status(200).json(mentors);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'An error occurred while fetching mentorship requests' });
    }
  }

  const getMyDetails = async (req, res) => {

    try {
      const email=req.body.email;
      console.log(email)
      const mentors = await Student.findOne({email});
      res.status(200).json(mentors);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'An error occurred while fetching mentorship requests' });
    }
  }
  export {verifyEmail,verifyOTP,createSessionRequest,findMentors,getMyDetails}