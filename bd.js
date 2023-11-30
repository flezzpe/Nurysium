const express = require("express");
const bodyParser = require("body-parser");

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

app.post("/check_version", (req, res) => {
  const clientVersion = req.body.version;

  const serverVersion = "1.0.0"; 
  const isVersionValid = clientVersion === serverVersion;

  if (isVersionValid) {
    res.json({ status: "ok", message: "vdver" });
  } else {
    res.json({ status: "error", message: "nupd" });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
