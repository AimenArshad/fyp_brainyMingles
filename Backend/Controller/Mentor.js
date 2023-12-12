import MentorshipRequest from '../Models/MentorshipRequests.js'
import bcrypt from 'bcrypt';
import Student from '../Models/Student.js';
import SessionRequest from '../Models/SessionRequests.js';
import nodemailer from 'nodemailer';
import Mentors from '../Models/Mentor.js';
import BiddingRequest from '../Models/BiddingRequests.js';
import AcceptedBids from '../Models/AcceptedBids.js';

import AcceptedSessions from '../Models/AcceptedSessions.js';
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
    const mentor_req = await MentorshipRequest.findOne({email})
    const Mentor = await Mentors.findOne({email})

    if (!student && !mentor_req && !Mentor){
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
        budget,
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
      const mentorUsername = username + 'S01';
  
      const MentorshipRequestInstance = new MentorshipRequest({
        name,
        username: mentorUsername,
        email,
        phoneNumber,
        budget,
        password: hashedPassword,
        domains : programmingDomains,
        languages : programmingLanguages,
        gender,
        mode,
        session,
        availability
      });
      await MentorshipRequestInstance.save();
      res.status(201).json({ message: 'Mentor Request Submitted successfully' });

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

const mentorshipRequests = async (req, res) => {
    try {

        const { name, username, email, phoneNumber, budget, password, expertise, skills, preferences } = req.body;
        const mentorUsername = username + 'M02'

        const saltRounds = 10; 
       // Hash the password using bcrypt
        const hashedPassword = await bcrypt.hash(password, saltRounds);

       
        const mentorshipRequest = new MentorshipRequest({
          name,
          username:mentorUsername,
          email,
          phoneNumber,
          password:hashedPassword,
          expertise,
          skills,
          budget,
          preferences: {
            gender: preferences.gender, // Array of gender preferences
            mode: preferences.mode, // Array of mode preferences
            session: preferences.session, // Array of session preferences
          },
          status: 'pending',
        });
    
        // Save the mentorship request to the database
        await mentorshipRequest.save();
    
        res.status(201).json({ message: 'Mentorship request submitted successfully' });


    } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
    }
  };


const studentsessionRequests = async (req, res) => {
try{
    const mentorEmail = req.body.email; // Assuming the mentor's email is in the request's user object
    console.log(mentorEmail)
    // Find the session requests for the mentor
    const sessionRequests = await SessionRequest.findOne({ mentorEmail });
    console.log(sessionRequests)
    if (!sessionRequests) {
      return res.status(404).json({ error: 'No session requests found for this mentor' });
    }

    const requestsData = [];

    for (const request of sessionRequests.sessionRequests) {
      // Fetch student name from the Student schema based on student email
      const student = await Student.findOne({ email: request.studentEmail });

      if (!student) {
        return res.status(404).json({ error: 'Student not found' });
      }

      // Create an array to store all sessions for this student
      const sessionsData = [];

      for (const session of request.sessions) {
        sessionsData.push({
          sessionType: session.sessionType,
          time: session.time,
          topic: session.topic,
        });
      }

      // Add student's data and their sessions to the response
      requestsData.push({
        studentName: student.name,
        studentEmail: request.studentEmail,
        sessions: sessionsData,
      });
    }

    res.status(200).json(requestsData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
}


const acceptSessionRequest = async (req, res) => {
  // try {
  //   const { studentEmail, sessionType, topic, time } = req.body;
  //      const mentorEmail=req.body.email;
  //   // Find the session request for the mentor
  //   let existingSessionRequest = await SessionRequest.findOne({ mentorEmail });

  //   if (existingSessionRequest) {
  //     // Find the student request in the session request based on studentEmail
  //     const sessionRequest = existingSessionRequest.sessionRequests.find(
  //       (request) => request.studentEmail === studentEmail
  //     );

  //     if (sessionRequest) {
  //       // Remove the session detail requested based on sessionType, topic, and time
  //       sessionRequest.sessions = sessionRequest.sessions.filter(
  //         (session) =>
  //           session.sessionType !== sessionType ||
  //           session.topic !== topic ||
  //           session.time !== time
  //       );

  //       // Save the changes to the database
  //       await existingSessionRequest.save();

  //       res.status(200).json({ message: 'Session request accepted successfully' });
  //     } else {
  //       res.status(404).json({ message: 'No session request found for the student' });
  //     }
  //   } else {
  //     res.status(404).json({ message: 'No session request found for the mentor' });
  //   }
  // } catch (error) {
  //   console.error(error);
  //   res.status(500).send('Server error');
  // }

    try {
      const { studentEmail, sessionType, topic, time } = req.body;
      const mentorEmail = req.body.email;
  
      // Find the session request for the mentor
      let existingSessionRequest = await SessionRequest.findOne({ mentorEmail });
  
      if (existingSessionRequest) {
        // Find the student request in the session request based on studentEmail
        const sessionRequest = existingSessionRequest.sessionRequests.find(
          (request) => request.studentEmail === studentEmail
        );
  
        if (sessionRequest) {
          // Remove the session detail requested based on sessionType, topic, and time
          const acceptedSession = {
            sessionType,
            time,
            topic,
          };
  
          // Save the accepted session to the AcceptedSessions schema
          let acceptedSessions = await AcceptedSessions.findOne({ mentorEmail });
  
          if (!acceptedSessions) {
            acceptedSessions = new AcceptedSessions({
              mentorEmail,
              sessionRequests: [],
            });
          }
  
          // Find the student request in the accepted session
          const acceptedSessionRequest = acceptedSessions.sessionRequests.find(
            (request) => request.studentEmail === studentEmail
          );
  
          if (acceptedSessionRequest) {
            acceptedSessionRequest.sessions.push(acceptedSession);
          } else {
            acceptedSessions.sessionRequests.push({
              studentEmail,
              sessions: [acceptedSession],
            });
          }
  
          // Save the changes to the AcceptedSessions schema
          await acceptedSessions.save();
  
          // Remove the session detail from the session request
          sessionRequest.sessions = sessionRequest.sessions.filter(
            (session) =>
              session.sessionType !== sessionType ||
              session.topic !== topic ||
              session.time !== time
          );
  
          // Save the changes to the SessionRequest schema
          await existingSessionRequest.save();
  
          res.status(200).json({ message: 'Session request accepted successfully' });
        } else {
          res.status(404).json({ message: 'No session request found for the student' });
        }
      } else {
        res.status(404).json({ message: 'No session request found for the mentor' });
      }
    } catch (error) {
      console.error(error);
      res.status(500).send('Server error');
    }
  };
  





// Create a new route for handling session request rejection
const rejectSessionRequest  = async (req, res) => {
  try {
    const {  studentEmail, sessionType, topic, time } = req.body;
      const mentorEmail=req.body.email;
      console.log(mentorEmail)
    // Find the session request for the mentor
    let existingSessionRequest = await SessionRequest.findOne({ mentorEmail });

    if (existingSessionRequest) {
      // Find the student request in the session request based on studentEmail
      const sessionRequest = existingSessionRequest.sessionRequests.find(
        (request) => request.studentEmail === studentEmail
      );

      if (sessionRequest) {
        // Remove the session detail requested based on sessionType, topic, and time
        sessionRequest.sessions = sessionRequest.sessions.filter(
          (session) =>
            session.sessionType !== sessionType ||
            session.topic !== topic ||
            session.time !== time
        );

        // Save the changes to the database
        await existingSessionRequest.save();

        res.status(200).json({ message: 'Session request rejected successfully' });
      } else {
        res.status(404).json({ message: 'No session request found for the student' });
      }
    } else {
      res.status(404).json({ message: 'No session request found for the mentor' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};





const studentsBiddingRequests = async (req, res) => {
  try {
    const mentorEmail = req.body.email; // Assuming the mentor's email is in the request's user object
    console.log(mentorEmail);

    // Find the bidding requests for the mentor
    const biddingRequests = await BiddingRequest.findOne({ mentorEmail });
    console.log(biddingRequests);

    if (!biddingRequests) {
      return res.status(404).json({ error: 'No bidding requests found for this mentor' });
    }

    const requestsData = [];

    for (const request of biddingRequests.biddingRequests) {
      // Fetch student name from the Student schema based on student email
      const student = await Student.findOne({ email: request.studentEmail });

      if (!student) {
        return res.status(404).json({ error: 'Student not found' });
      }

      // Create an array to store all bids for this student
      const bidsData = [];

      for (const bid of request.bids) {
        bidsData.push({
          budget: bid.budget,
          sessionType: bid.sessionType,
          course: bid.course,
        });
      }

      // Add student's data and their bids to the response
      requestsData.push({
        studentName: student.name,
        studentEmail: request.studentEmail,
        bids: bidsData,
      });
    }

    res.status(200).json(requestsData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};




const acceptBiddingRequest = async (req, res) => {
  try {
    const { studentEmail, sessionType, budget, course } = req.body;
    const mentorEmail = req.body.email;

    // Find the bidding request for the mentor
    let existingBiddingRequest = await BiddingRequest.findOne({ mentorEmail });

    if (existingBiddingRequest) {
      // Find the student request in the bidding request based on studentEmail
      const biddingRequest = existingBiddingRequest.biddingRequests.find(
        (request) => request.studentEmail === studentEmail
      );

      console.log(biddingRequest)
      if (biddingRequest) {
        // Remove the bid requested based on sessionType, budget, and course
        biddingRequest.bids = biddingRequest.bids.filter(
          (bid) =>
            bid.sessionType !== sessionType ||
            bid.budget !== budget ||
            bid.course !== course
        );

        // If the student has no bids, remove the student request
        if (biddingRequest.bids.length === 0) {
          existingBiddingRequest.biddingRequests = existingBiddingRequest.biddingRequests.filter(
            (request) => request.studentEmail !== studentEmail
          );
        }

        // If the mentor has no more bidding requests, remove the mentor record
        if (existingBiddingRequest.biddingRequests.length === 0) {
          await BiddingRequest.findOneAndRemove({ mentorEmail });
        } 
          // Save the changes to the database
        await existingBiddingRequest.save();

        
        // Check if the mentor already exists in the AcceptedBids schema
        let existingAcceptedBids = await AcceptedBids.findOne({ mentorEmail });

        if (!existingAcceptedBids) {
          // If the mentor does not exist, create a new document in the AcceptedBids schema
          existingAcceptedBids = new AcceptedBids({
            mentorEmail,
            biddingRequests: [],
          });
        }

        // Check if the student already exists in the AcceptedBids schema
        const existingStudentRequest = existingAcceptedBids.biddingRequests.find(
          (request) => request.studentEmail === studentEmail
        );

        if (existingStudentRequest) {
          // If the student already exists, check if the course is different
          //const existingBid = existingStudentRequest.bids.find((bid) => bid.course === course);

          // if (existingBid) {
          //   // If the course is the same, do not add a new record
          //   return res.status(400).json({ message: 'Bidding request already accepted for the same course' });
         // } else {
            // If the course is different, push the new bid into the existing student request
            existingStudentRequest.bids.push({
              budget,
              sessionType,
              course,
            });
          
      }else {
          // If the student does not exist, add a new student request with the bid
          existingAcceptedBids.biddingRequests.push({
            studentEmail,
            bids: [
              {
                budget,
                sessionType,
                course,
              },
            ],
          });
        }

        // Save the changes to the AcceptedBids schema
        await existingAcceptedBids.save();
        res.status(200).json({ message: 'Bidding request accepted successfully' });


      } else {
        res.status(404).json({ message: 'No bidding request found for the student' });
      }
    } else {
      res.status(404).json({ message: 'No bidding request found for the mentor' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};




const rejectBiddingRequest = async (req, res) => {
  try {
    const { studentEmail, sessionType, budget, course } = req.body;
    const mentorEmail = req.body.email;

    // Find the bidding request for the mentor
    let existingBiddingRequest = await BiddingRequest.findOne({ mentorEmail });

    if (existingBiddingRequest) {
      // Find the student request in the bidding request based on studentEmail
      const biddingRequest = existingBiddingRequest.biddingRequests.find(
        (request) => request.studentEmail === studentEmail
      );

      if (biddingRequest) {
        // Remove the bid requested based on sessionType, budget, and course
        biddingRequest.bids = biddingRequest.bids.filter(
          (bid) =>
            bid.sessionType !== sessionType ||
            bid.budget !== budget ||
            bid.course !== course
        );

        // If the student has no bids, remove the student request
        if (biddingRequest.bids.length === 0) {
          existingBiddingRequest.biddingRequests = existingBiddingRequest.biddingRequests.filter(
            (request) => request.studentEmail !== studentEmail
          );
        }

        // If the mentor has no more bidding requests, remove the mentor record
        if (existingBiddingRequest.biddingRequests.length === 0) {
          await BiddingRequest.findOneAndRemove({ mentorEmail });
        } 
          // Save the changes to the database
          await existingBiddingRequest.save();
        

        res.status(200).json({ message: 'Bidding request accepted successfully' });
      } else {
        res.status(404).json({ message: 'No bidding request found for the student' });
      }
    } else {
      res.status(404).json({ message: 'No bidding request found for the mentor' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};


const mySingleSessions = async (req, res) => {
  try{
    const mentorEmail = req.body.email; // Assuming the mentor's email is in the request's user object
    console.log(mentorEmail)
    // Find the session requests for the mentor
    const sessionRequests = await AcceptedSessions.findOne({ mentorEmail });
    console.log(sessionRequests)
    if (!sessionRequests) {
      return res.status(404).json({ error: 'No session requests found for this mentor' });
    }
  
    const requestsData = [];
  
    for (const request of sessionRequests.sessionRequests) {
      // Fetch student name from the Student schema based on student email
      const student = await Student.findOne({ email: request.studentEmail });
  
      if (!student) {
        return res.status(404).json({ error: 'Student not found' });
      }
  
      // Create an array to store all sessions for this student
      const sessionsData = [];
  
      for (const session of request.sessions) {
        sessionsData.push({
          sessionType: session.sessionType,
          time: session.time,
          topic: session.topic,
        });
      }
  
      // Add student's data and their sessions to the response
      requestsData.push({
        studentName: student.name,
        studentEmail: request.studentEmail,
        sessions: sessionsData,
      });
    }
  
    res.status(200).json(requestsData);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
  }

  
const rejectAcceptedSessions  = async (req, res) => {

  try {
    const {  studentEmail, sessionType, topic, time } = req.body;
      const mentorEmail=req.body.email;
      console.log(mentorEmail)
    // Find the session request for the mentor
    let existingSessionRequest = await AcceptedSessions.findOne({ mentorEmail });

    if (existingSessionRequest) {
      // Find the student request in the session request based on studentEmail
      const sessionRequest = existingSessionRequest.sessionRequests.find(
        (request) => request.studentEmail === studentEmail
      );

      if (sessionRequest) {
        // Remove the session detail requested based on sessionType, topic, and time
        sessionRequest.sessions = sessionRequest.sessions.filter(
          (session) =>
            session.sessionType !== sessionType ||
            session.topic !== topic ||
            session.time !== time
        );

        // Save the changes to the database
        await existingSessionRequest.save();

        res.status(200).json({ message: 'Session request rejected successfully' });
      } else {
        res.status(404).json({ message: 'No session request found for the student' });
      }
    } else {
      res.status(404).json({ message: 'No session request found for the mentor' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};




  export {verifyEmail,verifyOTP,studentsessionRequests,acceptSessionRequest,rejectSessionRequest,studentsBiddingRequests,
  acceptBiddingRequest,rejectBiddingRequest,rejectAcceptedSessions,mySingleSessions}