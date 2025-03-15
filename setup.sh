#!/bin/bash

echo "Setting up Zumba Management System..."

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo "MySQL is not installed. Please install MySQL first."
    exit 1
fi

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Maven is not installed. Please install Maven first."
    exit 1
fi

# Create database and tables
echo "Creating database and tables..."
echo "Please enter your MySQL root password:"
mysql -u root -p < src/main/resources/database.sql

if [ $? -eq 0 ]; then
    echo "Database setup completed successfully!"
else
    echo "Error setting up database. Please check your MySQL credentials and try again."
    exit 1
fi

# Build the project
echo "Building the project with Maven..."
mvn clean package

if [ $? -eq 0 ]; then
    echo "Project built successfully!"
    echo "WAR file created at: target/zumba-management.war"
    echo ""
    echo "Next steps:"
    echo "1. Deploy the WAR file to your Tomcat server"
    echo "2. Access the application at: http://localhost:8080/zumba-management"
    echo ""
    echo "Default admin credentials:"
    echo "Username: admin"
    echo "Password: admin123"
else
    echo "Error building the project. Please check the Maven output above."
    exit 1
fi

echo ""
echo "Setup complete! Thank you for using Zumba Management System."
