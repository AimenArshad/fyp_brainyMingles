import mongoose from 'mongoose';

const sessionRequestSchema = new mongoose.Schema({
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
      sessionLimit: {
        type: Number, // You can set an appropriate data type for the limit (e.g., Number)
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

const SessionRequest = mongoose.model('SessionRequest', sessionRequestSchema);

export default SessionRequest;
