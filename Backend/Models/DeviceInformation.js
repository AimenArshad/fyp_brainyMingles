import mongoose from 'mongoose'

const deviceSchema = new mongoose.Schema({

    email: {
      type: String,
      required: true,
      unique: true,
    },
    fcmToken: {
      type: String
    },
    isActive:{
      type:Boolean,
      required: true,
      default: false,
    }
   
  },{timestamps: true})

  const Device = mongoose.model('Device', deviceSchema);
  export default  Device;