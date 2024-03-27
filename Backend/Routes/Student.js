import express from 'express'
const router=express.Router()
import { verifyEmail,verifyOTP, createSessionRequest,findMentors, getMyDetails, makeABid, iamFypStudent, getFypRecommendations, gotMyMember} from '../Controller/Student.js'
import authMiddleware  from '../Middlerware/Auth.js';
import { fetchRecommendation } from '../Controller/Recommendation.js';
import multer from 'multer'; 

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// routes of a student
router.post('/sendOtp',verifyEmail)
router.post('/add-student',verifyOTP)
router.post('/session-request',authMiddleware,createSessionRequest)
router.get('/find-mentors',findMentors)
router.get('/mydetails',authMiddleware,getMyDetails)
router.post('/bid-request',authMiddleware,makeABid)

router.get('/:studentId/displayRecommendations',authMiddleware,fetchRecommendation)


// //document
// router.post('/create-folder',authMiddleware,createBucket)
// router.get('/get-folders',authMiddleware,getBuckets)
// router.get('/fetch-doc',authMiddleware,getBucketContents)
// router.post('/upload-files',upload.single('file'),authMiddleware,uploadFileToS3)


router.post('/fypstudent',authMiddleware,iamFypStudent)
router.get('/getfyprecommendations',authMiddleware,getFypRecommendations)
router.delete('/got-my-member',authMiddleware,gotMyMember)

export default router;