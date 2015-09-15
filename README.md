# NotificationSystem
Rough draft for a notification system for teams. 
This is a fork from Gianluca Guarini's repo: https://github.com/GianlucaGuarini/nodejs-MySQL-push-notifications-demo

There is a table of users, a table of teams, and a join table of users to teams, which also has flag of whether the user in the team is a leader of the team.

We would like to build a notification system for when a user comments on something. The system will notify the rest of the team members when the comment is public, and only the leader when the comment is private.

# Big Thanks
This repo is a customized fork of the following repo https://github.com/GianlucaGuarini/nodejs-MySQL-push-notifications-demo

# Assumptions:
* We may need to support any notification mechanism(email, sms, push, social media...etc). 
* Team leaders will always be notified of the comment(s).
* Team members will only be notified of public comments. 
* The comments system is already in place and will store the data in a dedicated comments table. 
  The comments system lets the commentor decide whether the comment is public or private.
* The system for creating teams, team members/leaders and assigning members to team(s) and assigning leader(s) to team(s) is already in place. We will just simulate this system by the tables in the DB. 

# Platform:
* I decided to use Node.JS to fetch the notifications from the DB and display them in realtime on connected clients given how ubiquitous node.js is. 
* I am using socket.io and mysql modules. 

# Out of scope:
* For this draft/design, editing existing comments does not trigger any notifications.
* For simplicity, we will support generating the notification in a table but will not implement the actual mechanism to push it

# How can I test this code?
* Install Node.js on your machine https://nodejs.org/en/download/
* Install the following modules:
** Socket.io: ```npm install socket.io```
** mysql: ```npm install mysql```
* Configure a MySQL database on your local machine
* Run [the following script](sql/create_db.sql) as root on your MySQL database
  Note that a new user will be created on the database: notification_sys
* Run the Node.js server: ``` node server.js```
* Navigate to the following URL: http://localhost:8000/NotificationSystem
The web page will display the comments that have pending notifications.
* The current design only displays the notifications on the connected clients/browsers. I will fine tune to play with notifying users soon. 
