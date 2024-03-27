import mongoose from 'mongoose'

const blockedUserSchema = new mongoose.Schema({
    email: {
      type: String,
      required: true,
      unique: true,
    }
   
  },{timestamps: true})

  const BlockedUsers = mongoose.model('BlockedUsers', blockedUserSchema);
  export default  BlockedUsers;