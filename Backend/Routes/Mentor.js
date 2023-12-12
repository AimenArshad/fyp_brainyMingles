import express from 'express'
const router=express.Router()
import { verifyEmail,verifyOTP,acceptSessionRequest,  rejectSessionRequest, studentsessionRequests, studentsBiddingRequests, acceptBiddingRequest, rejectBiddingRequest, mySingleSessions, rejectAcceptedSessions} from '../Controller/Mentor.js'
import authMiddleware from '../Middlerware/Auth.js'
import BiddingRequest from '../Models/BiddingRequests.js'

// routes of a mentor
router.post('/request',verifyOTP)
router.post('/sendOtp',verifyEmail)


router.get('/get-session-request',authMiddleware,studentsessionRequests)
router.post('/accept-sessionrequest',authMiddleware,acceptSessionRequest)
router.post('/reject-sessionrequest',authMiddleware,rejectSessionRequest)
router.get('/get-my-singlesessions',authMiddleware,mySingleSessions)
router.post('/reject-accpeted-session-request',authMiddleware,rejectAcceptedSessions)


router.get('/get-bidding-request',authMiddleware,studentsBiddingRequests)
router.post('/accept-bidding-request',authMiddleware,acceptBiddingRequest)
router.post('/reject-bidding-request',authMiddleware,rejectBiddingRequest)

export default router;