const nodeCron = require("node-cron");
const qrcode = require("qrcode-terminal");
const { Client, LocalAuth } = require("whatsapp-web.js");
const { MessageMedia } = require("whatsapp-web.js");
const dotenv = require("dotenv");
dotenv.config();

var sleep = require("system-sleep");

require("log-timestamp")(function () {
  return "[" + new Date() + "] \n %s";
});

var sql = require("mssql");

// var config = {
//   user: "sa",
//   password: "djisamsoe",
//   server: "192.168.150.103",
//   database: "nodejs",
//   options: {
//     encrypt: false,
//     enableArithAbort: true,
//     trustServerCertificate: false,
//   },
// };

var config = {
  user: process.env.DB_ID,
  password: process.env.DB_PASS,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: false,
    enableArithAbort: true,
    trustServerCertificate: false,
  },
};

const client = new Client({
  puppeteer: {
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  },
  authStrategy: new LocalAuth(),
});

client.on("qr", (qr) => {
  qrcode.generate(qr, { small: true });
});

client.on("ready", () => {
  console.log("Client is ready!");
  // Schedule a job to run every two minutes
  const job = nodeCron.schedule("* * * * *", whatsappBlast);
});
client.initialize();

function randomIntFromInterval(min, max) {
  // min and max included
  return Math.floor(Math.random() * (max - min + 1) + min);
}

async function whatsappBlast() {
  prepose = "+62";

  sql.connect(config, function (err) {
    if (err) console.log(err);

    // create Request object
    var request = new sql.Request();
    var limit = 0;
    request.query(
      "select value from settings where id='NODEJS_WA_LIMIT'",
      function (err, res) {
        limit = res.recordset[0].value;
      }
    );

    request.query(
      `select * from whatsapp_js where status=0 and onprocess=1`,
      function (err, res) {
        if (res && res.rowsAffected[0] > 0) {
          console.log("previous process is still running..");
          return;
        } else {
          // query to the database and get the records
          request
            .query(
              `UPDATE whatsapp_js SET onprocess = 1 where id in (select TOP ${limit} id from whatsapp_js where status=0 and onprocess=0 order by priority,id)`
            )
            .then((result) => {
              console.log("Updated Rows to OnProcess 1= ");
              console.log(result.rowsAffected);
            });

          request.query(
            `select * from whatsapp_js where status=0 and onprocess=1 order by priority,id`,
            function (err, recordset) {
              if (err) console.log(err);
              console.log("Get Rows=");
              console.log(recordset.rowsAffected);
              recordset.recordset.forEach((element) => {
                phone_number = element.phone_number;
                text = element.message;
                number = prepose.concat(phone_number.substring(1));
                chatId = number.substring(1) + "@c.us";
                console.log(`Send to ${chatId} = ${number} = ${text}`);

                if (
                  element.attachment &&
                  element.attachment_location &&
                  element.attachment_type
                ) {
                  media = "";
                  // if (element.attachment_location == "url") {
                  //   media = await MessageMedia.fromUrl(
                  //     "https://via.placeholder.com/350x150.png"
                  //   );
                  // }
                  if (element.attachment_location == "base64") {
                    media = new MessageMedia(
                      element.attachment_type,
                      element.attachment
                    );
                    send_media = client.sendMessage(chatId, media);
                    send_media.then(function (result) {
                      send = client.sendMessage(chatId, text);
                    });
                  }
                  if (element.attachment_location == "local") {
                    media = MessageMedia.fromFilePath(element.attachment);
                    if (element.attachment_type == "img") {
                      send_media = client.sendMessage(chatId, media);
                      send_media.then(function (result) {
                        send = client.sendMessage(chatId, text);
                      });
                    } else {
                      send_media = client.sendMessage(chatId, media, {
                        caption: text,
                        attachment: media,
                        sendMediaAsDocument: true,
                      });
                    }
                  }
                } else {
                  send = client.sendMessage(chatId, text);
                }
                now = new Date();
                console.log(now);
                request
                  .query(
                    `UPDATE whatsapp_js SET status = 1, onprocess=2, update_date= GETDATE() WHERE id = ${element.id}`
                  )
                  .then((result) => {
                    console.log("Updated Rows to Finished State= ");
                    console.log(result.rowsAffected);
                  });
                sleep(randomIntFromInterval(3, 6) * 1000);
              });
            }
          );
        }
      }
    );
  });
}
