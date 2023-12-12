import mongoose from "mongoose";

const recommendationSchema = new mongoose.Schema({
  studentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Student', // Reference to the Student model
    required: true,
  },
  mentors: [{
    type: Object,
    required: true,
  }],
});

const Recommendation = mongoose.model('Recommendation', recommendationSchema);

export default Recommendation;
