import express from 'express'
const router=express.Router()
import { verifyEmail,verifyOTP,acceptSessionRequest,  rejectSessionRequest, studentsessionRequests} from '../Controller/Mentor.js'


// routes of a mentor
router.post('/request',verifyOTP)
router.post('/sendOtp',verifyEmail)


router.get('/get-session-request',studentsessionRequests)
router.post('/accept-sessionrequest',acceptSessionRequest)
router.post('/reject-sessionrequest',rejectSessionRequest)

export default router;