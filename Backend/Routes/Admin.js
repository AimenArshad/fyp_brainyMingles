import express from 'express'
const router=express.Router()
import { addAdmin } from '../Controller/Admin.js';


// routes of a admin
router.post('/add-admin',addAdmin)


export default router;