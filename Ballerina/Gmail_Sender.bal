import ballerina/http;
import ballerina/log;
import ballerina/config;
import wso2/gmail;
import ballerina/io;


//endpoint gmail:Client gmailEP {
//    clientConfig:{
//        auth:{
//            accessToken:accessToken,
//            clientId:clientId,
//            clientSecret:clientSecret,
//            refreshToken:refreshToken
//        }
//    }
//};

// Calculator REST service
@http:ServiceConfig { basePath: "/" }


// By default, Ballerina assumes that the service is to be exposed via HTTP/1.1.
service<http:Service> email bind { port: 9090 } {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }

    // All resources are invoked with arguments of server connector and request.
    sendEmail(endpoint caller, http:Request req) {
        http:Response res = new;
        // A util method that can be used to set a string payload.
        //string operationReq = check req.getTextPayload();
        //match operationReq{
        //    string txt => sendNotification(txt);
        //    error err => io:println(err);
        //}

        sendNotification();
        // Sends the response back to the caller.
        caller->respond(res) but {
                error e => log:printError("Error sending response", err = e)
        };
    }

}


//function sendNotification() {
//    gmail:MessageRequest messageRequest;
//    messageRequest.recipient = "ngimhana94@gmail.com";
//    messageRequest.sender = "gimhanadesilva.15@cse.mrt.ac.lk";
//
//    messageRequest.subject = "File Change Detected";
//    messageRequest.messageBody = "File Change Detected...See Changes "  ;
//    //Set the content type of the mail as TEXT_PLAIN or TEXT_HTML.
//    messageRequest.contentType = gmail:TEXT_PLAIN;
//    //Send the message.
//    var sendMessageResponse = gmailEP -> sendMessage(userId, messageRequest);
//
//    match sendMessageResponse {
//        (string, string) sendStatus => {
//            //If successful, returns the message ID and thread ID.
//            string messageId;
//            string threadId;
//            (messageId, threadId) = sendStatus;
//            io:println("Sent Message ID: " + messageId);
//            io:println("Sent Thread ID: " + threadId);
//        }
//
//        //Unsuccessful attempts return a Gmail error.
//        gmail:GmailError e => io:println(e);
//    }
//}
//
