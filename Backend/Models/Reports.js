import mongoose from 'mongoose';

const reportSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true
  },
  reportCount: {
    type: Number,
    default: 0
  },
  reports: [{
    reportedBy: {
      type: String,
      required: true
    },
    reason: {
      type: String,
      required: true
    }
  }]
});

const Report = mongoose.model('Report', reportSchema);

export default Report;
