import mongoose from 'mongoose';

const acceptedSessionRequestSchema = new mongoose.Schema({
  mentorEmail: {
    type: String,
    required: true,
  },
  sessionRequests: [
    {
      studentEmail: {
        type: String,
        required: true,
      },
      sessions: [
        {
          sessionType: {
            type: String,
            required: true,
          },
          time: {
            type: String,
            required: true,
          },
          topic: {
            type: String,
            required: true,
          },
        },
      ],
    },
  ],
});

const AcceptedSessions = mongoose.model('AcceptedSessions', acceptedSessionRequestSchema);

export default AcceptedSessions;
