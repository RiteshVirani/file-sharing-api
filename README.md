# file-sharing-api
# README

This README would normally document whatever steps are necessary to get the
application up and running.

This is a Rails API-only application that allows authenticated users to upload, manage, and share large files securely.

Features:
* ✅ User authentication (Bcrypt + Manual API Token)
* ✅ Secure file upload (Active Storage)
* ✅ File size limit up to 1GB
* ✅ Users can only see and manage their own files
* ✅ Generate short public URLs for file sharing
* ✅ Delete uploaded files

Setup and Installation:
* Clone the Repository
* Install Dependencies - Make sure you have Ruby (3.2+), Rails (7+), and PostgreSQL installed. Then, install the required gems: bundle install
* Set Up Database - Configure your database in config/database.yml - then run: rails db:create db:migrate
* Set Up Active Storage (for file uploads) - rails active_storage:install | rails db:migrate
* Run the Server - rails s
