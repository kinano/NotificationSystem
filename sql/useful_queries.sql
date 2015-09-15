use notification_system;
select * from user_comments;
SELECT * FROM team_users;

-- User 1 comment is public. User 1 is part of team 1 => All team 1 users should get notified except for user 1
-- TEAM 1 and team 4 should get the notification for comment 1
-- 
select * from user_comment_notifications;
call get_pending_notifications;

update user_comment_notifications set sent_at = null where id > 0;