import express from 'express'
const router=express.Router()
import authMiddleware from '../Middlerware/Auth.js'
import { uploadReport,getAllReports, deleteReport} from '../Controller/Reports.js'

router.post('/upload-report',authMiddleware,uploadReport)
router.get('/get-reports',authMiddleware,getAllReports)
router.post('/block-report/:id',authMiddleware,deleteReport)

export default router;