create table member (
   member_id int unsigned not null auto_increment,
   member_name varchar(255) not null,
   updated_at TIMESTAMP NOT NULL,
   created_at DATETIME NOT NULL,
   PRIMARY KEY (member_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';
