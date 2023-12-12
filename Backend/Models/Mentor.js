import mongoose from 'mongoose'

const mentorSchema = new mongoose.Schema({
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
  budget: {
    type:   Number,
    required: true,
  },
  domains: [
    {
      name: {
        type: String,
        required: true,
      },
      score: {
        type: Number,
        required: true,
      },
    },
  ],
  languages: [
    {
      name: {
        type: String,
        required: true,
      },
      score: {
        type: Number,
        required: true,
      },
    },
  ],
  gender: {
    type: String,
    required: true,
  },
  mode: {
    type: String,
    required: true,
  },
  session: {
    type: String,
    required: true,
  },
  availability: {
    type: String,
    required: true,
  },
});

const Mentors = mongoose.model('Mentors', mentorSchema);

export default  Mentors;
