import express from 'express'
const router=express.Router()
import { verifyEmail,verifyOTP, createSessionRequest, findMentors, getMyDetails, makeABid} from '../Controller/Student.js'
import authMiddleware  from '../Middlerware/Auth.js';

// routes of a student
router.post('/sendOtp',verifyEmail)
router.post('/add-student',verifyOTP)
router.post('/session-request',authMiddleware,createSessionRequest)
router.get('/find-mentors',findMentors)
router.get('/mydetails',authMiddleware,getMyDetails)
router.post('/bid-request',authMiddleware,makeABid)


export default router;