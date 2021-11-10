module.exports = {
    ENV: process.env.NODE_ENV || "development",
    PORT: process.env.PORT || "8000",
    URL: process.env.BASE_URL || "http://localhost:8000",
    MONGODB_URI:
      process.env.MONGODB_URI ||
      "mongodb+srv://raj:406ecjar@cluster0-jkggb.mongodb.net/secblock",
    EXPIRY_TIME: process.env.EXPIRY_TIME || "60",
    JWT_SECRET: process.env.JWT_SECRET || "BUSY SOLUIONS ARE ALWAYS PROTECTED",
  };
  