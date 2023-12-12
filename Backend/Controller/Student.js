import SessionRequest from '../Models/SessionRequests.js';
import Student from '../Models/Student.js'
import bcrypt from 'bcrypt';
import Mentors from '../Models/Mentor.js';
import nodemailer from 'nodemailer';
import BiddingRequest from '../Models/BiddingRequests.js';
import Recommendation from '../Models/Recommendations.js'
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
    const checkOTP = tempOtp
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
        gender,
        mode,
        session,
        availability,
        otp
      } = req.body;
  
      if (otp != checkOTP) {
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
        domains: programmingDomains,
        languages: programmingLanguages,
        gender,
        mode,
        session,
        availability
        
      });
      await student.save();
      res.status(201).json({ message: 'Student registered successfully' });

      if (res.statusCode === 201){

        console.log("StudentRegisteredSuccessfully")
        const studentDataJson = JSON.stringify(student);
        const mentorsFromDB = await Mentors.find();
        const mentorsDataJson = JSON.stringify(mentorsFromDB);
        console.log(mentorsDataJson)
        const pythonProcess = spawn('python', ['AI_model/mentor_recommendation.py', studentDataJson, mentorsDataJson]);

        pythonProcess.stdout.on('data', async (data) => {
          try {
            const recommendations = JSON.parse(data);
        
            console.log(recommendations)
            for (const studentId in recommendations) {
              if (Object.hasOwnProperty.call(recommendations, studentId)) {
                const recommendedMentors = recommendations[studentId];
            
                // Save recommendations to the database
                await saveRecommendationsToDatabase(studentId, recommendedMentors);
              }
            }
        
          } catch (error) {
            console.error('Error parsing Python output:', error);
          }
        });
        


      }
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
    const { mentorEmail, sessions } = req.body;
    const studentEmail = req.body.email;
    console.log(studentEmail);
    console.log(sessions);

    // Find the existing session request for the mentor
    let existingSessionRequest = await SessionRequest.findOne({ mentorEmail });

    // If there's no existing session request, create a new one
    if (!existingSessionRequest) {
      existingSessionRequest = new SessionRequest({
        mentorEmail,
        sessionRequests: [],
      });
    }

    // Check if the student email already exists in the existing session requests
    const existingStudentRequestIndex = existingSessionRequest.sessionRequests.findIndex(
      (request) => request.studentEmail === studentEmail
    );

    if (existingStudentRequestIndex !== -1) {
      // Check if the user has reached the session limit (3 sessions)
      const sessionLimit = existingSessionRequest.sessionRequests[existingStudentRequestIndex].sessionLimit;
      if (sessionLimit >= 3) {
        // User has reached the session limit
        return res.status(400).json({ message: 'You have reached your free session limit' });
      }

      // Iterate through the new session requests
      for (const newRequest of sessions) {
        const { sessionType, time, topic } = newRequest;

        // Check if the user has already requested a session for this topic
        const topicExists = existingSessionRequest.sessionRequests[existingStudentRequestIndex].sessions.some(
          (session) => session.topic === topic
        );

        if (!topicExists) {
          // Add the new session to the existing student's request
          existingSessionRequest.sessionRequests[existingStudentRequestIndex].sessions.push({
            sessionType,
            time,
            topic,
          });

          // Increment the session limit
          existingSessionRequest.sessionRequests[existingStudentRequestIndex].sessionLimit += 1;
        }
      }

      // Save the updated session request to the database
      await existingSessionRequest.save();
    } else {
      // If the student email doesn't exist, create a new student request
      existingSessionRequest.sessionRequests.push({
        studentEmail,
        sessionLimit: 1, // Initialize the session limit to 1 for a new user
        sessions,
      });

      // Save the new session request to the database
      await existingSessionRequest.save();
    }

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
      const students = await Student.findOne({email});
      res.status(200).json(students);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'An error occurred while fetching student details' });
    }
  }



  //Make a bid
  const makeABid = async (req, res) => {
  try {
    const { mentorEmail, budget, sessionType, course } = req.body;
    const studentEmail=req.body.email
    console.log(mentorEmail)
    console.log(budget)

    // Check if mentor already exists
    let biddingRequest = await BiddingRequest.findOne({ mentorEmail });

    if (!biddingRequest) {
      // If mentor doesn't exist, create a new one
      biddingRequest = new BiddingRequest({
        mentorEmail,
        biddingRequests: [{ studentEmail, bids: [{ budget, sessionType, course }] }],
      });
    } else {
      // Check if student has already requested for the same course
      const existingStudent = biddingRequest.biddingRequests.find(
        (request) => request.studentEmail === studentEmail
      );

      if (existingStudent) {
        const existingCourse = existingStudent.bids.find((bid) => bid.course === course);

        if (existingCourse) {
          return res.status(400).json({ message: 'You have already requested this mentor for this course.' });
        }

        existingStudent.bids.push({ budget, sessionType, course });
      } else {
        biddingRequest.biddingRequests.push({ studentEmail, bids: [{ budget, sessionType, course }] });
      }
    }

    // Save the updated bidding request
    await biddingRequest.save();

    res.status(200).json({ message: 'Bid request successful.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
  }

  const saveRecommendationsToDatabase = async (studentId, recommendedMentors) => {
    try {
      // Fetch the student data from the database using the Student model
      const student = await Student.findById(studentId);
  
      // Check if the student exists
      if (!student) {
        console.error(`Student with ID ${studentId} not found.`);
        return;
      }
  
      // Fetch the mentor objects from the Mentor table based on the recommended mentor IDs
      const mentors = await Mentors.find({ _id: { $in: recommendedMentors } });
  
      // Save recommendations to the database with the entire mentor objects
      const recommendation = new Recommendation({
        studentId: studentId,
        mentors: mentors.map(mentor => ({
          mentorObject: mentor,
        })),
      });
  
      await recommendation.save();
      console.log(`Recommendations for student ${studentId} saved to database`);
  
    } catch (error) {
      console.error('Error saving recommendations to database:', error);
    }
  };
  

  export {verifyEmail,verifyOTP,createSessionRequest,findMentors,getMyDetails,makeABid}