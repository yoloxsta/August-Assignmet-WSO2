-- Initialize databases for WSO2 products

-- API Manager Databases
CREATE DATABASE IF NOT EXISTS apim_db CHARACTER SET latin1 COLLATE latin1_swedish_ci;
CREATE DATABASE IF NOT EXISTS um_db CHARACTER SET latin1 COLLATE latin1_swedish_ci;
CREATE DATABASE IF NOT EXISTS reg_db CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Identity Server Databases
CREATE DATABASE IF NOT EXISTS is_db CHARACTER SET latin1 COLLATE latin1_swedish_ci;
CREATE DATABASE IF NOT EXISTS is_um_db CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Micro Integrator Database
CREATE DATABASE IF NOT EXISTS mi_db CHARACTER SET latin1 COLLATE latin1_swedish_ci;

-- Grant privileges to wso2carbon user
GRANT ALL PRIVILEGES ON apim_db.* TO 'wso2carbon'@'%';
GRANT ALL PRIVILEGES ON um_db.* TO 'wso2carbon'@'%';
GRANT ALL PRIVILEGES ON reg_db.* TO 'wso2carbon'@'%';
GRANT ALL PRIVILEGES ON is_db.* TO 'wso2carbon'@'%';
GRANT ALL PRIVILEGES ON is_um_db.* TO 'wso2carbon'@'%';
GRANT ALL PRIVILEGES ON mi_db.* TO 'wso2carbon'@'%';

FLUSH PRIVILEGES;
