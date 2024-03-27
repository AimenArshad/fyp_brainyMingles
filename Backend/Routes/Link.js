import express from 'express'
const router = express.Router()
import { uploadLink, getLinks, getLinksByEmail, deleteLink} from '../Controller/Link.js';
import authMiddleware  from '../Middlerware/Auth.js';

//authMiddleware
router.post('/upload-link',authMiddleware,uploadLink);
router.get('/get-links',authMiddleware,getLinks);
router.get('/get-mylinks',authMiddleware,getLinksByEmail);
router.delete('/delete-link/:id',authMiddleware,deleteLink);
export default router;