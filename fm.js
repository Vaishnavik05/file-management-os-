const express = require('express');
const { exec } = require('child_process');
const cors = require('cors');
const path = require('path');
const app = express();
const PORT = 3000;
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));
app.post('/file-manager', (req, res) => {
  const { action, params } = req.body;
  let command = `./fm.sh ${action}`;
  if (params && Object.keys(params).length) {
    command += ' ' + Object.values(params).join(' ');
  }
  exec(command, { cwd: __dirname }, (error, stdout, stderr) => {
    if (error) {
      res.status(500).json({ message: `Error: ${stderr}` });
    } else {
      res.json({ message: stdout || 'Action completed successfully' });
    }
  });
});
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'fm.html'));
});
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
