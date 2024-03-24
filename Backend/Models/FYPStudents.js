import mongoose from 'mongoose';

const fypStudentSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true
  },
  cgpa: {
    type: String,
    required: true
  },
  department: {
    type: String,
    required: true
  },
  skills: {
    type: [String], // Array of strings
    required: true
  },
  requirements: {
    type: [String], // Array of strings
    required: true
  },
  idea: {
    type: String,
    required: true
  }
});

const FypStudent = mongoose.model('FypStudent', fypStudentSchema);

export default FypStudent;
