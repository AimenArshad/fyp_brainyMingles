import express from 'express';
import mongoose from 'mongoose';
import bodyParser from "body-parser";

const  app = express();
import cors from "cors";

mongoose.connect("mongodb+srv://muqadisa:miqi0000@cluster0.o7abwna.mongodb.net/BM")
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));


  app.use(express.static("public"));
  app.use(express.json()); //important for recieving api calls
  app.use(cors())


//Routes  
 import router from './Routes/User.js'
 import studentRoute from './Routes/Student.js'
 import mentorRoute from './Routes/Mentor.js'
 import facultyRoute from './Routes/Faculty.js'
 import adminRoute from './Routes/Admin.js'
 import  loginRoute from './Routes/Login.js'
    app.use('/api/user',router)
    app.use('/api/student',studentRoute)
    app.use('/api/faculty',facultyRoute)
    app.use('/api/mentor',mentorRoute)
    app.use('/api/admin',adminRoute)
    app.use('/api',loginRoute)


app.listen(4200, () => {
  console.log("Server started on port 4200");
});