import SessionRequest from '../Models/SessionRequests.js';
import Student from '../Models/Student.js'
import bcrypt from 'bcrypt';
import { spawn } from 'child_process';
import Mentors from '../Models/Mentor.js';
import nodemailer from 'nodemailer';
import BiddingRequest from '../Models/BiddingRequests.js';
import Recommendation from '../Models/Recommendations.js'
import FypStudent from '../Models/FYPStudents.js';
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
    console.log(mentorEmail)
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
        if (topicExists) {
          return res.status(400).json({ message: 'Failed, duplicates' });
        }
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
    res.status(201).json({ message: 'Session request created successfully' });

  } catch (error) {
    console.error(error);
    res.status(500).send('Server error');
  }
};

  
  
  const findMentors = async (req, res) => {
    try {
      const mentors = await Mentors.find().select('name email expertise budget');
      console.log(mentors)
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
  


//   //Document

//   import AWS from 'aws-sdk';

// // Configure AWS SDK with your credentials
// AWS.config.update({
//   accessKeyId: 'AKIAU6GDZV4MDBX47FNI',
//   secretAccessKey: '/2Gkuc38aeBBy3ZvOts/tNbe+CKt7Lo/u0zXyXFk',
//   region: 'us-east-1'
// });

// const s3 = new AWS.S3();

// // correct-bucket name
// const createBucket = (req, res) => {
//   const bucketName = req.body.bucketName; // Assuming the bucket name is sent in the request body

//   // Create the bucket
//   s3.headBucket({ Bucket: bucketName }, (err, data) => {
//     if (err && err.code === 'NotFound') {
//       // Bucket does not exist, proceed with creation
//       s3.createBucket({ Bucket: bucketName }, (err, data) => {
//         if (err) {
//           console.error('Error creating bucket:', err);
//           res.status(500).json({ error: 'Failed to create bucket' });
//         } else {
//           console.log('Bucket created successfully:', data.Location);
          
//           // Create a new bucket document in MongoDB
//           const newBucket = new Bucket({ name: bucketName });
//           newBucket.save()
//             .then(() => {
//               console.log('Bucket document saved in MongoDB');
//               res.status(201).json({ message: 'Bucket created successfully', location: data.Location });
//             })
//             .catch(error => {
//               console.error('Error saving bucket document:', error);
//               res.status(500).json({ error: 'Failed to save bucket document' });
//             });
//         }
//       });
//     } else if (err) {
//       // Other error occurred
//       console.error('Error checking bucket existence:', err);
//       res.status(500).json({ error: 'Failed to check bucket existence' });
//     } else {
//       // Bucket already exists
//       console.log('Bucket already exists:', bucketName);
//       res.status(200).json({ message: 'Bucket already exists', location: bucketName });
//     }
//   });
// };

// // corrected upload file
// const uploadFileToS3 = (req, res) => {
//   const bucketName = req.body.bucketName;
//   console.log(bucketName) // Assuming the bucket name is sent in the request body
//   const file = req.file; // Assuming the file is uploaded using multer middleware

//   if (!bucketName) {
//     return res.status(400).json({ error: 'Bucket name is required' });
//   }

//   // Check if the bucket exists
//   s3.headBucket({ Bucket: bucketName }, (err, data) => {
//     if (err && err.code === 'NotFound') {
//       // Bucket does not exist, return error
//       return res.status(404).json({ error: 'Bucket does not exist' });
//     } else if (err) {
//       // Other error occurred
//       console.error('Error checking bucket existence:', err);
//       return res.status(500).json({ error: 'Failed to check bucket existence' });
//     }

//     // If the bucket exists, upload the file
//     const params = {
//       Bucket: bucketName,
//       Key: file.originalname, // Set the key (filename) in S3 to be the same as the original filename
//       Body: file.buffer // Set the file data
//     };

//     s3.upload(params, (err, data) => {
//       if (err) {
//         console.error('Error uploading file to S3:', err);
//         return res.status(500).json({ error: 'Failed to upload file to S3' });
//       }

//       console.log('File uploaded successfully to:', data.Location);

//       // Update the MongoDB bucket document with the file information
//       Bucket.findOneAndUpdate(
//         { name: bucketName },
//         { $push: { files: { fileName: file.originalname, fileLocation: data.Location } } },
//         { new: true }
//       )
//         .then(updatedBucket => {
//           console.log('File added to bucket:', updatedBucket);
//           res.status(201).json({ message: 'File uploaded successfully', location: data.Location });
//         })
//         .catch(error => {
//           console.error('Error updating bucket document:', error);
//           res.status(500).json({ error: 'Failed to update bucket document' });
//         });
//     });
//   });
// };


// // const getDocs = async (req, res) => {
// //   const bucketName = req.query.bucketName; // Get the bucket name from query parameter

// //   if (!bucketName) {
// //     return res.status(400).json({ error: 'Bucket name is required' });
// //   }

// //   try {
// //     const documents = await fetchDocumentsFromBucket(bucketName);
// //     res.status(200).json({ documents });
// //   } catch (error) {
// //     console.error('Error fetching documents:', error);
// //     res.status(500).json({ error: 'Failed to fetch documents from bucket' });
// //   }
// // }

// // const fetchDocumentsFromBucket = (bucketName) => {
// //   return new Promise((resolve, reject) => {
// //     const params = {
// //       Bucket: bucketName
// //     };

// //     s3.listObjectsV2(params, (err, data) => {
// //       if (err) {
// //         console.error('Error fetching documents from bucket:', err);
// //         reject(err);
// //       } else {
// //         const documents = data.Contents.map(obj => obj.Key);
// //         resolve(documents);
// //       }
// //     });
// //   });
// // };

// const getBuckets = async (req, res) => {
//   try {
//     // Query MongoDB to find all buckets
//     const buckets = await Bucket.find({}, 'name'); // Only retrieve the bucketName field
//     console.log(buckets)
//     // Extract bucket names from the retrieved buckets
//     const bucketNames = buckets.map(bucket => bucket.name);

//     // Return the list of bucket names in the response
//     res.status(200).json(bucketNames);
//   } catch (error) {
//     // Handle any errors that occur during the database query
//     console.error('Error fetching buckets:', error);
//     res.status(500).json({ error: 'Failed to fetch buckets' });
//   }
// }


// const getBucketContents = async (bucketName) => {
//   try {
//     // Find the bucket document by name
//     const bucket = await Bucket.findOne({ name: bucketName });

//     if (!bucket) {
//       throw new Error('Bucket not found');
//     }

//     // Return the files array of the bucket
//     return bucket.files;
//   } catch (error) {
//     throw error;
//   }
// };


import FypRecommendation from '../Models/FYPRecommendations.js';

// //fyp
// const iamFypStudent = async (req, res) => {
//   try {
//     const { email, cgpa, department, skills, requirements, idea } = req.body;
  
//     // Check if the email already exists
//     const existingStudent = await FypStudent.findOne({ email });
//     if (existingStudent) {
//       return res.status(400).json({ error: 'Student with this email already exists' });
//     }
  
//     // Create a new FypStudent instance
//     const fypStudent = new FypStudent({
//       email,
//       cgpa,
//       department,
//       skills,
//       requirements,
//       idea
//     });
  
//     // Save the new FypStudent to the database
//     const savedStudent = await fypStudent.save();
//     res.status(201).json(savedStudent); // Send the saved student data as response
  
//     if (res.statusCode === 201) {
//       console.log("Fyp Student saved successfully")
//       const fypStudentsFromDB = await FypStudent.find();
//       const fypStudentsDataJson = JSON.stringify(fypStudentsFromDB);
      
//       const pythonProcess = spawn('python', ['AI_model/fyp_recommendations.py', fypStudentsDataJson]);
  
//       console.log("Returned back");
//       pythonProcess.stdout.on('data', async (data) => {
//           try {
//               const recommended_users = JSON.parse(data.toString());
//               console.log('Received JSON data:', recommended_users);
              
//               for (const [email, members] of Object.entries(recommended_users)) {
//                 // Check if the email already exists in FypRecommendation
//                 const existingRecommendation = await FypRecommendation.findOne({ email });
//                 if (existingRecommendation) {
//                     // Initialize existing members to an empty array if null
//                     existingRecommendation.members = existingRecommendation.members || [];
            
//                     // Update the existing document by adding only new member objects
//                     members.forEach(newMember => {
//                         if (!existingRecommendation.members.some(existingMember => existingMember.email === newMember.email)) {
//                             existingRecommendation.members.push(newMember);
//                         }
//                     });
//                     await existingRecommendation.save();
//                     console.log(`Updated FypRecommendation for email ${email}`);
//                 } else {
//                     // Create a new FypRecommendation instance
//                     const fypRecommendation = new FypRecommendation({
//                         email,
//                         members
//                     });
                    
//                     // Save the new FypRecommendation to the database
//                     const savedRecommendation = await fypRecommendation.save();
//                     console.log('Saved recommendation:', savedRecommendation);
//                 }
//             }
            
//           } catch (error) {
//               console.error('Error parsing Python output:', error);
//           }
//       });
  
//       pythonProcess.stderr.on('data', (data) => {
//           console.error('Python process encountered an error:', data.toString());
//       });
  
//       pythonProcess.on('close', (code) => {
//           console.log(`Python process closed with code ${code}`);
//       });
//   }
  
  
//   } catch (error) {
//     console.error('Error adding FypStudent:', error);
//     res.status(500).json({ error: 'Internal Server Error' });
//   }
//   }

const iamFypStudent = async (req, res) => {
  try {
    const { email, cgpa, department, skills, requirements, idea } = req.body;
  
    // Check if the email already exists
    const existingStudent = await FypStudent.findOne({ email });
    if (existingStudent) {
      return res.status(400).json({ error: 'Student with this email already exists' });
    }
  
    // Create a new FypStudent instance
    const fypStudent = new FypStudent({
      email,
      cgpa,
      department,
      skills,
      requirements,
      idea
    });
  
    // Save the new FypStudent to the database
    const savedStudent = await fypStudent.save();
    res.status(201).json(savedStudent); // Send the saved student data as response
  
    if (res.statusCode === 201) {
      console.log("Fyp Student saved successfully")
      const fypStudentsFromDB = await FypStudent.find();
      const fypStudentsDataJson = JSON.stringify(fypStudentsFromDB);
      
      const pythonProcess = spawn('python', ['AI_model/fyp_recommendations.py', fypStudentsDataJson]);
  
      console.log("Returned back");
      pythonProcess.stdout.on('data', async (data) => {
          try {
              const recommended_users = JSON.parse(data.toString());
              console.log('Received JSON data:', recommended_users);
              
              if (recommended_users) { // Add null check
                for (const [email, members] of Object.entries(recommended_users)) {
                  // Check if the email already exists in FypRecommendation
                  const existingRecommendation = await FypRecommendation.findOne({ email });
                  if (existingRecommendation) {
                      // Initialize existing members to an empty array if null
                      existingRecommendation.members = existingRecommendation.members || [];
              
                      // Update the existing document by adding only new member objects
                      if (Array.isArray(members) && members.length > 0) {// Add null check
                        members.forEach(newMember => {
                          if (!existingRecommendation.members.some(existingMember => existingMember.email === newMember.email)) {
                            existingRecommendation.members.push(newMember);
                          }
                        });
                      }
                      await existingRecommendation.save();
                      console.log(`Updated FypRecommendation for email ${email}`);
                  } else {
                      // Create a new FypRecommendation instance
                      const fypRecommendation = new FypRecommendation({
                          email,
                          members
                      });
                      
                      // Save the new FypRecommendation to the database
                      const savedRecommendation = await fypRecommendation.save();
                      console.log('Saved recommendation:', savedRecommendation);
                  }
                }
              }
              
          } catch (error) {
              console.error('Error parsing Python output:', error);
          }
      });
  
      pythonProcess.stderr.on('data', (data) => {
          console.error('Python process encountered an error:', data.toString());
      });
  
      pythonProcess.on('close', (code) => {
          console.log(`Python process closed with code ${code}`);
      });
    }
  } catch (error) {
    console.error('Error adding FypStudent:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};




  const getFypRecommendations = async (req, res) => {
    try {
        const { email } = req.body;
        
        // Check if the email is provided
        if (!email) {
            return res.status(400).json({ error: 'Email is required' });
        }

        // Find the FypRecommendation document for the provided email
        const recommendation = await FypRecommendation.findOne({ email }).populate('members');

        // Check if the recommendation exists
        if (!recommendation) {
            return res.status(404).json({ error: 'Recommendation not found for the provided email' });
        }

        // Retrieve cgpa and department for each member using the email
        const data = [];
        if (recommendation.members !== null && recommendation.members.length > 0) {
        for (const member of recommendation.members) {
          
            // Find the FypStudent document for the member's email
            const fypStudent = await FypStudent.findOne({ email: member.email });

            // Check if the FypStudent document exists
            if (fypStudent) {
                // Add cgpa and department to the member data
                const memberData = {
                    email: member.email,
                    cgpa: fypStudent.cgpa,
                    department: fypStudent.department,
                    skills: member.skills,
                    requirements: member.requirements,
                    idea: member.idea
                };
                data.push(memberData);
            } else {
                console.error(`FypStudent not found for email ${member.email}`);
            }
          }
        }
        console.log(data)
        // Return the filtered recommendations
        res.status(200).json(data);

    } catch (error) {
        console.error('Error getting recommendations:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
}

// route to delete 
const gotMyMember = async (req, res) => {
  try {
    const { email } = req.body;
    console.log(email);

    // Delete user from FypRecommendation schema
    await FypRecommendation.findOneAndDelete({ email });

    // Delete user from FypStudent schema
    await FypStudent.findOneAndDelete({ email });

    // Iterate through members array in FypRecommendation schema and remove member.email object if it matches the email
    const recommendations = await FypRecommendation.find();
    for (const recommendation of recommendations) {
      // Check if recommendation.members is not null
      if (recommendation.members) {
        const updatedMembers = recommendation.members.filter(member => member.email !== email);
        await FypRecommendation.findByIdAndUpdate(recommendation._id, { members: updatedMembers });
      }
    }

    res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};


export {verifyEmail,verifyOTP,createSessionRequest,findMentors,getMyDetails,makeABid,
iamFypStudent,getFypRecommendations,gotMyMember}