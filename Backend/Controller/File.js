import File from '../Models/Files.js';
import fs from 'fs';

const uploadFile = async (req, res) => {
    try {
        const file = req.file;
        const data = fs.readFileSync(file.path); 
        const email = req.body.email;
        const { course, topic } = req.body; 
        console.log(`email${email}`)
        console.log(req.body)
        const newFile = new File({ name: file.originalname, data: data, uploadedBy: email, course, topic });
        await newFile.save();
        res.status(200).json({ message: 'File uploaded successfully' });
      } catch (error) {
        console.error('Error uploading file:', error);
        res.status(500).json({ error: 'Failed to upload file' });
      }
  };

const getFiles = async (req, res) => {
  try {
    const files = await File.find();
    res.status(200).json(files);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

const openFile = async (req, res) =>{
  try {
    const file = await File.findById(req.params.id);
    if (!file) {
      return res.status(404).json({ error: 'File not found' });
    }
    res.json({ name: file.name, data: file.data.toString('base64') });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

const getFilesByEmail = async (req, res) => {
  try {
    const email  = req.body.email;
    console.log(email)
    const files = await File.find({ uploadedBy: email });
    res.status(200).json(files);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

const deleteFile = async (req, res) => {
  const fileId = req.params.id;

  try {
    const file = await File.findById(fileId);

    if (!file) {
      return res.status(404).json({ error: 'File not found' });
    }
    await file.deleteOne();
    res.status(200).json({ message: 'File deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while deleting the file' });
  }
}

export {uploadFile, getFiles, openFile, getFilesByEmail, deleteFile}