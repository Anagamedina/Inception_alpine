*This project has been created as part of the 42 curriculum by anamedin.*

# 📖 USER_DOC - User Documentation

This guide explains how to use and manage the Inception infrastructure stack.

## 1. Services Provided
The stack provides a complete and secure web environment:
- **Nginx**: The entry point, serving as a Reverse Proxy with TLS 1.3 encryption.
- **WordPress**: The website engine running on PHP-FPM.
- **MariaDB**: The relational database for content storage.
- **Bonus Services**: Includes Redis (Cache), FTP Server (File management), Adminer (Database UI), Netdata (Monitoring), and a Static Site (C++ Webserver).

## 2. Start and Stop the Project
All management is done through the `Makefile` at the root:
- **To Start**: Run `make`. This builds and launches everything automatically.
- **To Stop**: Run `make down` to stop services, or `make clean` to stop and remove containers.
- **To Reset**: Run `make fclean` to remove everything, including data volumes and secrets.

## 3. Access the Website and Administration Panel
Once the project is running:
- **Main Website**: [https://anamedin.42.fr](https://anamedin.42.fr)
- **WordPress Admin**: [https://anamedin.42.fr/wp-admin](https://anamedin.42.fr/wp-admin)
- **Adminer (DB Management)**: [https://anamedin.42.fr/adminer](https://anamedin.42.fr/adminer)

## 4. Locate and Manage Credentials
For security, passwords are generated randomly during the first run. You can find them in:
- The `./srcs/secrets/` directory on the host machine.
- Files like `db_password.txt`, `wp_admin_password.txt`, and `ftp_password.txt` contain the actual credentials.

## 5. Check Service Status (Defense & Inspection Guide)
To verify that the infrastructure is running perfectly, follow these steps:

### ✅ General Status
Run `docker ps` in the terminal. All containers should show a status of `Up` and `(healthy)`.

### 🗄️ MariaDB (Database)
- **Enter**: `docker exec -it mariadb mariadb -u root -p`
- **Verify**: Run `SHOW DATABASES;` and `USE inception; SHOW TABLES;`. You should see the WordPress tables.

### 📝 WordPress (WP-CLI)
- **Enter**: `docker exec -it wordpress sh`
- **Verify**: Run `wp user list --allow-root` to see registered users and `wp plugin list --allow-root` to check Redis status.

### 📁 FTP (File Transfer)
- **Check Connection (List Files)**: From your VM, run `apk add curl` if needed, then list the files to verify credentials:
  ```bash
  curl -v ftp://colleague:your_password@localhost:2121/
  ```
- **Upload a Test File**: Create a file and upload it to the server:
  ```bash
  echo "Inception FTP Test 2026" > test_ftp.txt
  curl -v -T test_ftp.txt ftp://colleague:your_password@localhost:2121/
  ```
- **Verify**: Confirm the file reached the WordPress container:
  ```bash
  docker exec -it wordpress ls -l /var/www/html/wordpress/test_ftp.txt
  ```

### ⚡ Redis (Cache)
- **Enter**: `docker exec -it redis redis-cli`
- **Verify**: Run `ping` (should return `PONG`) and `monitor` to see real-time cache activity.

### 🔒 Nginx (Web Server)
- **Verify**: `docker exec -it nginx nginx -t` to check config syntax and `ls -l /etc/nginx/ssl/` to verify certificates.

---
*This project was developed with the assistance of AI for documentation structuring and translation.*
