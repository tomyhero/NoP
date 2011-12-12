create table paste (
   code varchar(255) NOT NULL,
   body text NOT NULL,
   created_at DATETIME NOT NULL,
   PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARACTER SET = 'utf8';
