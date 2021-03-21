--
-- create docker users
--

CREATE DATABASE IF NOT EXISTS `vpsman`;
GRANT ALL ON `vpsman`.* TO 'spider'@'%';
