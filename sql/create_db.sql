SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;
use notification_system;

DROP TABLE IF EXISTS `teams`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `team_users`;
DROP TABLE IF EXISTS `user_comments`;

CREATE TABLE `users` (
	`id` int(10) NOT NULL auto_increment,
	`first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    `username` varchar(100) NOT NULL ,
	`email` varchar(100) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `users_username_uidx` (`username`),
    UNIQUE KEY `users_email_uidx` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `teams` (
	`id` int(10) NOT NULL auto_increment,
	`name` varchar(100) NOT NULL,
    `description` varchar(1000) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `teams_name_uidx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `team_users` (
	`team` int(10) NOT NULL,
    `user` int(10) NOT NULL,
    `leader` boolean default false,
    PRIMARY KEY (`team`, `user`),
    FOREIGN KEY (team) 
        REFERENCES teams(id)
        ON DELETE CASCADE,
    FOREIGN KEY (user) 
        REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_comments` (
	`id` int(10) NOT NULL auto_increment, 
    `user` int(10) NOT NULL,
    `comment` text NOT NULL,
    `public` bool default true,
    `created_at` timestamp default CURRENT_TIMESTAMP,
    `notification_sent_at` timestamp default null,
    PRIMARY KEY (`id`),
    FOREIGN KEY (user) 
        REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

delimiter $
DROP PROCEDURE `get_pending_notifications`$
CREATE PROCEDURE `get_pending_notifications`()
BEGIN
	select
		comments.id "comment_id",
        comments.comment "comment",
		commentors.id "commentor_user_id",
        commentors.first_name "commentor_first_name",
        commentors.last_name "commentor_last_name",
        commentors.email "commentor_email",
        commentor_teams.id "commentor_team_id",
        commentor_teams.name "commentor_team_name",
        case when
			comments.public = 1 
		then 'Y' else 'N'
		end AS "is_public",
        recipients.id "recipient_user_id",
        recipients.first_name "recipient_first_name",
        recipients.last_name "recipient_last_name",
        recipients.email "recipient_email",
		case when 
			recipient_team_users.leader = 1 
		then 'Y' else 'N'
        end AS "is_recipient_team_leader",
        -- Notify the recipient ONLY if the recipient is a team leader OR if the comment is public:
        case when	
			recipient_team_users.leader = 1 OR comments.public = 1
        then
			'Y'
		else
			'N'
        end AS "notify_recipient"
	from
		users commentors
			inner join
		user_comments comments
			on
		commentors.id = comments.user
			inner join
		team_users commentor_team_users
			on
		commentor_team_users.user = commentors.id 
			inner join
		teams commentor_teams 
			on
		commentor_team_users.team = commentor_teams.id
			inner join
		teams recipient_teams
			on
		recipient_teams.id = commentor_teams.id
			inner join
		team_users recipient_team_users 
			on
		recipient_team_users.team = commentor_teams.id
			inner join
		users recipients 
			on
		recipients.id = recipient_team_users.user  
			and
		-- Exclude the commentor:
        commentors.id <> recipients.id
	where	
		comments.notification_sent_at is null
	order by
		comments.id;
END
$

delimiter ;
grant all on *.* to 'notification_sys'@'localhost' identified by 'Password123';
-- ----------------------------
--  Records of `users`
-- ----------------------------
BEGIN;

	INSERT INTO `users`(
		first_name,
		last_name,
		username,
		email
	) VALUES (
		'Kinan',
		'Faham',
		'kinan',
		'k@theSilentCamera.com'
	);
    
	INSERT INTO `users`(
		first_name,
		last_name,
		username,
		email
	) VALUES (
		'Mike',
		'Sullivan',
		'mike',
		'mike@theSilentCamera.com'
	);

	INSERT INTO `users`(
		first_name,
		last_name,
		username,
		email
	) VALUES (
		'Kevin',
		'Smith',
		'kevin',
		'kevin@theSilentCamera.com'
	);

	INSERT INTO `users`(
		first_name,
		last_name,
		username,
		email
	) VALUES (
		'John',
		'Lambda',
		'john',
		'john@theSilentCamera.com'
	);

	INSERT INTO `teams`(
		`name`,
		`description`
    )
    values(
		'Team 1',
        'First team'
        
    );

	INSERT INTO `teams`(
		`name`,
		`description`
    )
    values(
		'Team 2',
        'Second team'
        
    );

	INSERT INTO team_users(
		team,
        user,
        leader
	)
    values(
		1,
        1,
        false
    );
    
    INSERT INTO team_users(
		team,
        user,
        leader
	)
    values(
		1,
        2,
        false
    );
    
    INSERT INTO team_users(
		team,
        user,
        leader
	)
    values(
		2,
        3,
        false
    );    

    INSERT INTO team_users(
		team,
        user,
        leader
	)
    values(
		2,
        4,
        true
    );

	INSERT INTO team_users(
		team,
        user,
        leader
	)
    values(
		1,
        4,
        true
    );
    
    insert into `user_comments`(
		user,
        `comment`,
        public
    )
    values(
		1,
        'This is a public comment made by user 1',
        true
    );
    
    insert into `user_comments`(
		user,
        `comment`,
        public
    )
    values(
		3,
        'This is a private comment made by user 3',
        false
    );
    
	insert into `user_comments`(
		user,
        `comment`,
        public
    )
    values(
		1,
        'This is a private comment made by user 1',
        false
    );
    
	insert into `user_comments`(
		user,
        `comment`,
        public
    )
    values(
		1,
        'This is ANOTHER private comment made by user 1!!!',
        false
    );
    
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
