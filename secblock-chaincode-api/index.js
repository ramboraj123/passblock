const mongoose = require("mongoose");
const config = require("./config");
const xss = require("xss-clean");
const helmet = require("helmet");
const mongoSanitize = require("express-mongo-sanitize");
const Root = require("./app/controllers/users/root");

const restify = require("restify"),
  server = restify.createServer({
    name: "secblock API",
    version: "1.0.0",
  }),
  cors = require("./cors");

server.pre(cors);

server.use(restify.plugins.throttle({ burst: 100, rate: 20, ip: true }));

server.use(
  restify.plugins.bodyParser({
    mapParams: false,
    maxBodySize: 1024 * 1024 * 2,
    // requestBodyOnGet: true,
    urlencoded: { extended: false },
  })
);

//server.use(restify.json({ limit: "10kb" })); // body limit is 10

server.use(xss());
server.use(helmet());
server.use(mongoSanitize());

server.use(restify.plugins.queryParser({ mapParams: false }));



server.listen(config.PORT, async () => {
  await mongoose.connect(config.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });

  //await Root();
});


const db = mongoose.connection;

db.on("error", (err) => {
  console.log(err);
});

db.once("open", () => {
  require("./app/routes")(server);
  console.log(`Server started on port ${config.PORT}`);
});
