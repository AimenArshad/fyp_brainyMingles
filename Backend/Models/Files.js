import mongoose from 'mongoose'

const fileSchema = new mongoose.Schema({
    name: {
      type: String,
      required: true,
    },
    course: {
      type: String,
      required: true,
    },
    topic: {
      type: String,
      required: true,
    },
    data:{
        type: Buffer,
        required: true,
    },
    uploadedBy:{
        type: String,
        required:true,
    }
  },{timestamps: true})

  const File = mongoose.model('File', fileSchema);
  export default  File;