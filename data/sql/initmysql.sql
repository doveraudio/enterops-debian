ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;