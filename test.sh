#!/bin/bash

echo "Running tests for Zumba Management System..."

# Function to test database connection
test_database() {
    echo "Testing database connection..."
    if mysql -u root -p -e "USE zumba_db; SELECT 1;" &> /dev/null; then
        echo "✓ Database connection successful"
        return 0
    else
        echo "✗ Database connection failed"
        return 1
    fi
}

# Function to test table existence
test_tables() {
    echo "Testing database tables..."
    local tables=("admin" "users" "batch" "participant")
    local success=true

    for table in "${tables[@]}"; do
        if mysql -u root -p -e "USE zumba_db; DESCRIBE ${table};" &> /dev/null; then
            echo "✓ Table '${table}' exists"
        else
            echo "✗ Table '${table}' not found"
            success=false
        fi
    done

    if [ "$success" = true ]; then
        return 0
    else
        return 1
    fi
}

# Function to test admin account
test_admin_account() {
    echo "Testing admin account..."
    if mysql -u root -p -e "USE zumba_db; SELECT * FROM admin WHERE username='admin';" &> /dev/null; then
        echo "✓ Admin account exists"
        return 0
    else
        echo "✗ Admin account not found"
        return 1
    fi
}

# Function to test sample data
test_sample_data() {
    echo "Testing sample batch data..."
    if mysql -u root -p -e "USE zumba_db; SELECT * FROM batch LIMIT 1;" &> /dev/null; then
        echo "✓ Sample batch data exists"
        return 0
    else
        echo "✗ Sample batch data not found"
        return 1
    fi
}

# Function to check Maven build
test_maven_build() {
    echo "Testing Maven build..."
    if mvn clean package &> /dev/null; then
        echo "✓ Maven build successful"
        if [ -f "target/zumba-management.war" ]; then
            echo "✓ WAR file generated successfully"
            return 0
        else
            echo "✗ WAR file not found"
            return 1
        fi
    else
        echo "✗ Maven build failed"
        return 1
    fi
}

# Main test execution
echo "Starting tests..."
echo "----------------"

# Make setup script executable
chmod +x setup.sh
echo "✓ Made setup script executable"

# Run all tests
test_database
db_result=$?

test_tables
tables_result=$?

test_admin_account
admin_result=$?

test_sample_data
data_result=$?

test_maven_build
build_result=$?

echo "----------------"
echo "Test Summary:"
echo "----------------"
[ $db_result -eq 0 ] && echo "Database Connection: PASS" || echo "Database Connection: FAIL"
[ $tables_result -eq 0 ] && echo "Database Tables: PASS" || echo "Database Tables: FAIL"
[ $admin_result -eq 0 ] && echo "Admin Account: PASS" || echo "Admin Account: FAIL"
[ $data_result -eq 0 ] && echo "Sample Data: PASS" || echo "Sample Data: FAIL"
[ $build_result -eq 0 ] && echo "Maven Build: PASS" || echo "Maven Build: FAIL"

# Check if all tests passed
if [ $db_result -eq 0 ] && [ $tables_result -eq 0 ] && [ $admin_result -eq 0 ] && [ $data_result -eq 0 ] && [ $build_result -eq 0 ]; then
    echo "----------------"
    echo "✓ All tests passed!"
    echo ""
    echo "Next steps:"
    echo "1. Deploy the WAR file (target/zumba-management.war) to Tomcat"
    echo "2. Access the application at: http://localhost:8080/zumba-management"
    echo "3. Login with admin credentials:"
    echo "   Username: admin"
    echo "   Password: admin123"
    exit 0
else
    echo "----------------"
    echo "✗ Some tests failed. Please check the errors above."
    exit 1
fi
