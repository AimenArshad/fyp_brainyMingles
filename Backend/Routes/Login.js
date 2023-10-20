import express from 'express'
const router=express.Router()
import { loginUser} from '../Controller/Login.js'


// routes of a login
router.post('/login',loginUser)


export default router;