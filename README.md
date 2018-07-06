# Google-Sheet-Real-time-Chage-Tracker-Using-Ballerina-Lang
This is a real time Google sheet user tracking Application developed using Ballerina Lang


The initial idea is to track users when they begin editing the document and
notifying the document owner that they are working on it at that moment
via a mail.

Benefits from this project is , the owner have the ability, to view
collaborators work when they begin working on the sheet and the owner
should not have to be watch out the document always.

## Implementation
Original Design requires Google Drive API v3 , Google Analytics API ,
Gmail API v1 and Google Sheets API v4.

Note: Corresponding Ballerina Lang packages for Google Analytics and
Google Drive(Not supported for the Ballerina 0.975 version) are not
currently available in the Ballerina Central.

So the current Implementation only contain Gmail and Gsheets APIs only.
