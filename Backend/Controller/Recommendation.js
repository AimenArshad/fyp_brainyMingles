import Recommendation from '../Models/Recommendations.js';

const fetchRecommendation = async (req,res) => {
    try {
        const { studentId } = req.params;
    
        // Query the Recommendation collection for the specific student
        const recommendation = await Recommendation.findOne({ studentId });
    
        if (!recommendation) {
          return res.status(404).json({ message: 'Recommendation not found for the student.' });
        }
    
        const filteredMentors = recommendation.mentors.map((mentor) => {
            const { name, email, budget, phoneNumber, domains, languages, gender, mode, session, availability } = mentor.mentorObject;
            return {
              name,
              email,
              gender,
              budget
            };
          });
        // Send the populated recommendation data to the frontend
        res.json({ mentors: filteredMentors});
        console.log(filteredMentors)
    
      } catch (error) {
        console.error('Error displaying recommended mentors:', error);
        res.status(500).json({ message: 'Server error' });
      }
};

export {fetchRecommendation}