import ballerina/config;
import ballerina/log;
import wso2/gsheets4;
import ballerina/io;
import ballerina/http;
import ballerina/task;
import ballerina/math;
import ballerina/runtime;
import wso2/gmail;

//Timer to check Spredsheet updates
task:Timer? timer;
int count;
int initialValuecount = 0;
boolean isSentNotification = false;

documentation{A valid access token with gmail and google sheets access.}
string accessToken = config:getAsString("ACCESS_TOKEN");

documentation{The client ID for your application.}
string clientId = config:getAsString("CLIENT_ID");

documentation{The client secret for your application.}
string clientSecret = config:getAsString("CLIENT_SECRET");

documentation{A valid refreshToken with gmail and google sheets access.}
string refreshToken = config:getAsString("REFRESH_TOKEN");

documentation{Spreadsheet id of the reference google sheet.}
string spreadsheetId = config:getAsString("SPREADSHEET_ID");

documentation{Sheet name of the reference googlle sheet.}
string sheetName = config:getAsString("SHEET_NAME");

documentation{Sender email address.}
string senderEmail = config:getAsString("SENDER");

documentation{The user's email address.}
string userId = config:getAsString("USER_ID");


endpoint gsheets4:Client spreadsheetClient {
    clientConfig: {
        auth: {
            accessToken: accessToken,
            refreshToken: refreshToken,
            clientId: clientId,
            clientSecret: clientSecret
        }
    }
};

endpoint gmail:Client gmailEP {
    clientConfig:{
        auth:{
            accessToken:accessToken,
            clientId:clientId,
            clientSecret:clientSecret,
            refreshToken:refreshToken
        }
    }
};

endpoint http:Client gmailClient  {
    url: "http://localhost:9090/"
};

function main(string... args) {

    io:println("Spread Sheet Watcher Begin");
    (function() returns error?) onTriggerFunction = getSheetDetails;
    function(error) onErrorFunction = cleanupError;
    string[][] valuesIntials = getCustomerDetailsFromGSheet();
    initialValuecount = lengthof valuesIntials;
    timer = new task:Timer(onTriggerFunction, onErrorFunction,
        500, delay = 0);
    timer.start();

    runtime:sleep(100000000); // Temp. workaround to stop the process from exiting.
}

function getSheetDetails() {
    //Retrieve the customer details from spreadsheet.
    string[][] values = getCustomerDetailsFromGSheet();
    int i = 0;

    if(lengthof  values != initialValuecount){
        io:println("doc has changed");
        initialValuecount = lengthof values;
        //Send Notification
        sendNotification();
        runtime:sleep(2000);
    }

    //Iterate through each customer details and send customized email.
    foreach value in values {
        //Skip the first row as it contains header values.
        if (i > 0) {
            string productName = value[0];
            string CutomerName = value[1];
            //string customerEmail = value[2];
            string subject = "Thank You for Downloading " + productName;
            //io:println(productName + " : "+ CutomerName);

        }
        i = i + 1;
    }
}

function sendNotification() {

    string [][] values = getCustomerDetailsFromGSheet();
    gmail:MessageRequest messageRequest;
    messageRequest.recipient = "nadeeshan@wso2.com";
    messageRequest.sender = "gimhanadesilva.15@cse.mrt.ac.lk";

    messageRequest.subject = "File Change Detected";
    messageRequest.messageBody = "File Change Detected By ngimhana...See Changes";
    //Set the content type of the mail as TEXT_PLAIN or TEXT_HTML.
    messageRequest.contentType = gmail:TEXT_PLAIN;
    //Send the message.
    var sendMessageResponse = gmailEP -> sendMessage(userId, messageRequest);

    match sendMessageResponse {
        (string, string) sendStatus => {
            //If successful, returns the message ID and thread ID.
            string messageId;
            string threadId;
            (messageId, threadId) = sendStatus;
            io:println("Sent Message ID: " + messageId);
            io:println("Sent Thread ID: " + threadId);
        }

        //Unsuccessful attempts return a Gmail error.
        gmail:GmailError e => io:println(e);
    }
}



function getCustomerDetailsFromGSheet() returns (string[][]) {
    //Read all the values from the sheet.
    string[][] values = check spreadsheetClient->getSheetValues(spreadsheetId, sheetName, "", "");

    //log:printInfo("Retrieved customer details from spreadsheet id:" + spreadsheetId + " ;sheet name: "
    //        + sheetName);
    return values;
}



function cleanup() returns error? {
    count = count + 1;
    io:println("Cleaning up...");
    io:println(count);

    if (math:randomInRange(0, 10) == 5) {
        error e = { message: "Cleanup error" };
        return e;
    }

    if (count >= 10) {
        timer.stop();
        //io:println("Stopped timer");
    }
    return ();
}

function cleanupError(error e) {
    //io:print("[ERROR] cleanup failed");
    //io:println(e);
}


