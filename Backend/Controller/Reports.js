import Report from "../Models/Reports.js";

import AcceptedBids from "../Models/AcceptedBids.js";
import AcceptedSessions from "../Models/AcceptedSessions.js";
import Mentor from "../Models/Mentor.js";
import Student from "../Models/Student.js";
import Device from "../Models/DeviceInformation.js";
import Recommendation from "../Models/Recommendations.js";
import BiddingRequest from "../Models/BiddingRequests.js";
import SessionRequest from "../Models/SessionRequests.js";
import File from "../Models/Files.js";
import Link from "../Models/Link.js";
import BlockedUsers from "../Models/BlockedUsers.js";
import { updateRecommendations } from "./Faculty.js";


const uploadReport = async (req, res) => {
    try {
        const { reportedEmail, reason } = req.body;
        let reportedUser = await Report.findOne({ email: reportedEmail });
    
        if (reportedUser) {
          const reporterEmail = req.body.email;
          reportedUser.reports.push({ reportedBy: reporterEmail, reason });
          reportedUser.reportCount += 1;
          await reportedUser.save();
          res.status(200);
        } else {
          const newReportedUser = new Report({
            email: reportedEmail,
            reportCount: 1,
            reports: [{ reportedBy: req.body.email, reason }]
          });
          await newReportedUser.save();
          res.status(200);
        }
    
        console.log('Report uploaded successfully');
      } catch (error) {
        console.error('Error uploading report:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
  };

  const getAllReports = async (req, res) => {
    try {
      const allReports = await Report.find();
      res.status(200).json(allReports);
    } catch (error) {
      console.error('Error fetching reports:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  const deleteReport = async (req, res) => {
    try {
      console.log("hello");
      const reportId  = req.params.id; 
      console.log(reportId)
      const deletedReport = await Report.findByIdAndDelete(reportId);
  
      
      if (!deletedReport) {
        return res.status(404).json({ error: "Report not found" });
      }

      const mentor = await Mentor.findOne({ email: deletedReport.email });
      if (mentor) {
        console.log("mentor")
        const { _id: id } = mentor;
        await AcceptedBids.deleteOne({ mentorEmail: deletedReport.email });
        await AcceptedSessions.deleteOne({ mentorEmail: deletedReport.email });
        await BiddingRequest.deleteOne({ mentorEmail: deletedReport.email });
        await SessionRequest.deleteOne({ mentorEmail: deletedReport.email });
        await Report.updateMany(
          { "reports.reportedBy": deletedReport.email },
          { $pull: { reports: { reportedBy: deletedReport.email } } }
        );
        await File.deleteMany({ uploadedBy: deletedReport.email });
        await Link.deleteMany({ uploadedBy: deletedReport.email });
        const deletedMentor = await Mentor.findByIdAndDelete(id);
        if(deletedMentor){
            console.log("Mentor deleted Successfully")
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

      } else {
        const student = await Student.findOne({ email: deletedReport.email });
        if (student) {
          console.log("student")
          const { _id: id } = student;
          await AcceptedBids.updateMany(
            { "biddingRequests.studentEmail": deletedReport.email },
            { $pull: { biddingRequests: { studentEmail: deletedReport.email } } }
          );
          await Report.updateMany(
            { "reports.reportedBy": deletedReport.email },
            { $pull: { reports: { reportedBy: deletedReport.email } } }
          );
          await AcceptedSessions.updateMany(
            { "sessionRequests.studentEmail": deletedReport.email },
            { $pull: { sessionRequests: { studentEmail: deletedReport.email } } }
          );
          await BiddingRequest.updateMany(
            { "biddingRequests.studentEmail": deletedReport.email },
            { $pull: { biddingRequests: { studentEmail: deletedReport.email } } }
          );
          await SessionRequest.updateMany(
            { "sessionRequests.studentEmail": deletedReport.email },
            { $pull: { sessionRequests: { studentEmail: deletedReport.email } } }
          );
          await Recommendation.deleteOne({ studentId: id });
          await Student.findByIdAndDelete(id);
        }
        await Device.deleteOne({ email: deletedReport.email });
        const newBlockedUser = new BlockedUsers({ email: deletedReport.email });
        await newBlockedUser.save();
      }
  
      res.status(200).json({ message: "Report deleted successfully" });
    } catch (error) {
      console.error("Error deleting report:", error);
      res.status(500).json({ error: "Internal Server Error" });
    }
  };
  
  
  export {uploadReport, getAllReports, deleteReport}