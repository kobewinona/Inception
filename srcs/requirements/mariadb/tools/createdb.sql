CREATE DATABASE wordpress;
CREATE USER 'dklimkin'@'%' IDENTIFIED BY '584628';

GRANT ALL PRIVILEGES ON wordpress.* TO 'dklimkin'@'%';

FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY 'root584628';