import express from 'express'
const router=express.Router()
import { verifyEmail,verifyOTP,acceptSessionRequest,  rejectSessionRequest, studentsessionRequests} from '../Controller/Mentor.js'
import authMiddleware from '../Middlerware/Auth.js'

// routes of a mentor
router.post('/request',verifyOTP)
router.post('/sendOtp',verifyEmail)


router.get('/get-session-request',authMiddleware,studentsessionRequests)
router.post('/accept-sessionrequest',authMiddleware,acceptSessionRequest)
router.post('/reject-sessionrequest',authMiddleware,rejectSessionRequest)

export default router;