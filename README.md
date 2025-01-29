# README

# Ruby on Rails Dockerized Project

## 📌 Overview
This project sets up a **Ruby on Rails** application inside **Docker** with **PostgreSQL** as the database and **NGINX** as a reverse proxy.

---
## ⚙️ Prerequisites
Ensure you have the following installed:
- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Make** (Optional, but recommended for automation)

---
## 🏗️ Build and Run the Project
Follow these steps to set up and start the application:

### **1️⃣ Clone the Repository**
```sh
 git clone <your-repository-url>
 cd <project-folder>
```

### **2️⃣ Set Up Environment Variables**
Create a **`.env`** file in the root directory:
```env
POSTGRES_USER=rails_user
POSTGRES_PASSWORD=securepassword
POSTGRES_DB=rails_dev
```

### **3️⃣ Build and Run the Containers**
```sh
docker-compose up -d --build
```
✅ **This will:**
- Build the **Rails app** inside a Docker container.
- Start the **PostgreSQL database**.
- Start **NGINX as a reverse proxy**.

### **4️⃣ Initialize the Database**
Once the containers are running, create and migrate the database:
```sh
docker-compose run --rm app bundle exec rails db:create db:migrate
```

### **5️⃣ Access the Application**
- Open **http://localhost:3000** in your browser.
- Logs can be viewed using:
  ```sh
  docker-compose logs -f app
  ```

---
## 🔍 Troubleshooting Common Issues

### **1️⃣ Rails Container Keeps Restarting**
Run:
```sh
docker-compose logs -f app
```
Possible issues:
- **`Could not locate Gemfile`** → Ensure `Gemfile` exists and is copied correctly in `Dockerfile`.
- **`server.pid already exists`** → Modify `entrypoint.sh` to remove the file:
  ```sh
  rm -f /app/tmp/pids/server.pid
  ```

### **2️⃣ PostgreSQL Connection Issues (`PG::ConnectionBad`)**
- Ensure `config/database.yml` has:
  ```yaml
  default: &default
    adapter: postgresql
    host: db
    username: <%= ENV['POSTGRES_USER'] %>
    password: <%= ENV['POSTGRES_PASSWORD'] %>
  ```
- Restart the database:
  ```sh
  docker-compose restart db
  ```

### **3️⃣ Reset the Entire Setup**
If nothing works, **reset and rebuild everything**:
```sh
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

---
## 📖 Technical Decisions & Assumptions

### **1️⃣ Containerization & Orchestration**
- **Docker Compose** is used to manage multiple containers (Rails, PostgreSQL, NGINX).
- The **Dockerfile** installs Ruby dependencies and runs the Rails app.

### **2️⃣ PostgreSQL as the Database**
- **Reason**: PostgreSQL is a scalable and reliable choice for production environments.
- **Configuration**: Database credentials are stored in `.env` and referenced in `config/database.yml`.

### **3️⃣ NGINX as a Reverse Proxy**
- Used to **route traffic** to the Rails app and serve static files.
- Configured to **listen on port 80** and forward requests to Rails.

### **4️⃣ Development Workflow Inside Docker**
- Mounted volumes (`volumes` in `docker-compose.yml`) allow code changes to reflect **without rebuilding the container**.
- **Live reload** works by watching files inside the container.

### **5️⃣ Security & Best Practices**
- **Secrets & Credentials**: Environment variables are managed in **`.env`** (not committed to Git).
- **Production-Ready Dockerfile**:
  - Uses **multi-stage builds** (if needed) to optimize image size.
  - Exposes only necessary ports (3000 for Rails, 80 for NGINX).

---
## 🎯 Future Improvements
- **Add CI/CD integration** using GitHub Actions.
- **Optimize image size** by using an Alpine-based Ruby image.
- **Configure a logging system** for better observability.

---
## 📜 License
This project is open-source. Feel free to modify and contribute! 🚀

