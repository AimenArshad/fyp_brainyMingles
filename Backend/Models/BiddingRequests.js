import mongoose from 'mongoose';

const biddingRequestSchema = new mongoose.Schema({
  mentorEmail: {
    type: String,
    required: true,
  },
  biddingRequests: [
    {
      studentEmail: {
        type: String,
        required: true,
      },
     
      bids: [
        {
          budget: {
            type: String,
            required: true,
          },
          sessionType: {
            type: String,
            required: true,
          },
          course: {
            type: String,
            required: true,
          },
        },
      ],
    },
  ],
});

const BiddingRequest = mongoose.model('BiddingRequest', biddingRequestSchema);

export default BiddingRequest;
