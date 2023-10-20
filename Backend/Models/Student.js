import mongoose from 'mongoose'

const studentSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  username: {
    type: String,
    unique: true,
    required: true,
  },
  email: {
    type: String,
    unique: true,
    required: true,
  },
  phoneNumber: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  programmingDomains: {
    type: [String],
  },
  programmingLanguages: {
    type: [String],
  },
  challenges: {
    type: [String
    ],
  },
  preferences: {
    gender: {
      type: [String],
    },
    mode: {
      type: [String],
    },
    session: {
      type: [String],
    },
  },
});

const Student = mongoose.model('Student', studentSchema);

export default  Student;