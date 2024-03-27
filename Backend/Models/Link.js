import mongoose from 'mongoose'
const linkSchema = new mongoose.Schema({
  url: {
    type: String,
    required: true,
    trim: true,
    validate: {
      validator: (value) => {
        return /^(ftp|http|https):\/\/[^ "]+$/.test(value);
      },
      message: 'Invalid URL format',
    },
  },
  altText: {
    type: String,
    required: true,
    trim: true,
  },
  course: {
    type: String,
    required: true,
    trim: true,
  },
  topic: {
    type: String,
    required: true,
    trim: true,
  },
  uploadedBy: {
    type: String, // Reference to the User model
    required: true,
  },
}, { timestamps: true });

const Link = mongoose.model('Link', linkSchema);
export default  Link;
