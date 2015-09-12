# NotificationSystem
Rough draft for a notification system for teams:

There is a table of users, a table of teams, and a join table of users to teams, which also has flag of whether the user in the team is a leader of the team.

We would like to build a notification system for when a user comments on something. The system will notify the rest of the team members when the comment is public, and only the leader when the comment is private.

# Assumptions:
* We may need to support any notification mechanism(email, sms, push, social media...etc). 
* We need to decide on the mechanism to store the notifications and handle them(real time, batch,..etc)
* Team leaders will always be notified of the comment(s).
* Team members will only be notified of public comments. 
* The comments system is already in place and will store the data in a dedicated comments table. 
  The comments system lets the commentor decide whether the comment is public or private.
* The system for creating teams, team members/leaders and assigning members to team(s) and assigning leader(s) to team(s) is already in place. We will just simulate this system by the tables in the DB. 

# Open questions:
* I am a team member and I comment on something, should I get notified of this comment similarly to my other team members or should I be excluded since I know that I just made the comment?
* Decide on the best platform/technology to use 
* Performance considerations

# Out of scope:
* For this draft/design, editing existing comments does not trigger any notifications.
* For simplicity, we will support generating the notification in a table but will not implement the actual mechanism to push it
