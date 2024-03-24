import mongoose from "mongoose";

const fyprecommendationSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  members: [{
    type: Object,  //fypstudent objects
    required: true,
  }],
});

const FypRecommendation = mongoose.model('FypRecommendation', fyprecommendationSchema);

export default FypRecommendation;
