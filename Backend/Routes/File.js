import express from 'express'
const router = express.Router()
import { uploadFile, getFiles, openFile, getFilesByEmail, deleteFile} from '../Controller/File.js';
import authMiddleware  from '../Middlerware/Auth.js';
import multer from 'multer';

const upload = multer({ dest: 'uploads/' });
//authMiddleware
router.post('/upload-file',upload.single('file'),authMiddleware,uploadFile);
router.get('/open-file/:id',authMiddleware,openFile);
router.get('/get-files',authMiddleware,getFiles);
router.get('/get-myfiles',authMiddleware,getFilesByEmail);
router.delete('/delete-file/:id',authMiddleware,deleteFile);
export default router;