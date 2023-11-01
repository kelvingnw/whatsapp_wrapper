const qrcode = require("qrcode-terminal");

if (fs.existsSync(SESSION_FILE_PATH)) {
  sessionData = require(SESSION_FILE_PATH);
}

// Use the saved values
const client = new Client({
  authStrategy: new LegacySessionAuth({
    session: sessionData,
  }),
});

client.on("qr", (qr) => {
  qrcode.generate(qr, { small: true });
});

// Save session values to the file upon successful auth
client.on("authenticated", (session) => {
  sessionData = session;
  fs.writeFile(SESSION_FILE_PATH, JSON.stringify(session), (err) => {
    if (err) {
      console.error(err);
    }
  });
});

client.on("ready", () => {
  console.log("Client is ready!");

  const readline = require("readline");
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  // Number where you want to send the message.
  number = "+628819751892";

  // Your message.
  text = "Hey boy";

  // Getting chatId from the number.
  // we have to delete "+" from the beginning and add "@c.us" at the end of the number.
  //   const chatId = number.substring(1) + "@c.us";
  prepose = "+62";

  var cron = require("node-cron");

  cron.schedule("* * * * *", () => {
    number = prepose.concat(number);
    chatId = number.substring(1) + "@c.us";
    console.log(`Send to ${chatId} = ${number} = ${text}`);
    client.sendMessage(chatId, text);
  });

  // // const prompt = require("prompt-sync")({ sigint: true });

  // number = prompt("Send to which Phone Number? ");
  // text = prompt("Send what Message? ");
  // // Sending message.
});

client.initialize();
