import express from 'express'
const router=express.Router()
import { createUser, getUser,loginUser} from '../Controller/User.js'


// routes of a user 
router.get('/get',getUser)
router.post('/add',createUser)
router.post('/login',loginUser)



export default router;