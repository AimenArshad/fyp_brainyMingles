import mongoose from 'mongoose';

const acceptedBids = new mongoose.Schema({
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

const AcceptedBids = mongoose.model('AcceptedBids', acceptedBids);

export default AcceptedBids;
