import mongoose from 'mongoose'

const mentorshipRequestSchema = new mongoose.Schema({
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
  status: {
    type: String,
    required: true,
  },
  budget: {
    type: String,
    required: true,
  },
  expertise: {
    type: [String],
  },
  skills: {
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

const MentorshipRequest = mongoose.model('MentorshipRequest', mentorshipRequestSchema);

export default  MentorshipRequest;
