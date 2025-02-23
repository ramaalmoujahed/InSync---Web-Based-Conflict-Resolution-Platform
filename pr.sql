CREATE DATABASE INSYNC,
USE INSYNC,

CREATE TABLE IF NOT EXISTS user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,  -- Foreign Key referencing department table
    role_id INT,  -- Foreign Key referencing role table
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    avatar_url VARCHAR(255),
    notification_preferences VARCHAR(255), 
    security_settings VARCHAR(255), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_department_id FOREIGN KEY (department_id) REFERENCES department(department_id),
    CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES role(role_id)
);
CREATE TABLE IF NOT EXISTS department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
);
CREATE TABLE IF NOT EXISTS role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name ENUM('employee', 'manager', 'supervisor') NOT NULL,
);
CREATE TABLE IF NOT EXISTS permission (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(255) UNIQUE NOT NULL,
    
);
--junction table كسر العلاقة
CREATE TABLE IF NOT EXISTS role_permission (
    role_id INT, 
    permission_id INT, 
    PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES role(role_id) ON DELETE CASCADE,
    CONSTRAINT fk_permission FOREIGN KEY (permission_id) REFERENCES permission(permission_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS conflict_report (
    conflict_report_id INT AUTO_INCREMENT PRIMARY KEY,
    created_by INT NOT NULL, -- User who created the conflict report
    department_id INT, -- Foreign Key referencing department table
    conflict_title VARCHAR(255) NOT NULL,
    conflict_description TEXT NOT NULL,
    priority_level ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL DEFAULT 'Medium', -- Priority level of the report
    status ENUM('Pending', 'In Progress', 'Resolved') DEFAULT 'Pending',
    files VARCHAR(255) DEFAULT NULL, -- Optional column for file attachments, nullable
 date_reported TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
     progress_status VARCHAR(255) DEFAULT NULL, -- Optional column to describe the progress status

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES user(user_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE IF NOT EXISTS document (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    created_by INT NOT NULL, -- Foreign Key referencing the user who created the document
    assigned_to INT, -- Foreign Key referencing the user to whom the document is assigned (if applicable)
    document_type_id INT, -- Foreign Key referencing document_type table
    department_id INT, -- Foreign Key referencing department table
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    file_type ENUM('Excel', 'TXT', 'PDF', 'DOC', 'DOCX', 'CSV', 'Other') NOT NULL, -- New column to specify file type
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES user(user_id), -- Establishes that each document is created by exactly one user
    FOREIGN KEY (assigned_to) REFERENCES user(user_id), -- Optional: Assigns document to another user if needed
    FOREIGN KEY (document_type_id) REFERENCES document_type(document_type_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);
 
CREATE TABLE IF NOT EXISTS document_type (
    document_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name ENUM('employee_document', 'supervisor_report', 'manager_report') NOT NULL,
    description VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS notification (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'low',
    status ENUM('unread', 'read') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--كسر علاقة
CREATE TABLE IF NOT EXISTS user_notification (
    user_id INT, -- Foreign Key referencing user table
    notification_id INT, -- Foreign Key referencing notification table
    PRIMARY KEY (user_id, notification_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (notification_id) REFERENCES notification(notification_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS survey (
    survey_id INT AUTO_INCREMENT PRIMARY KEY,
    created_by INT NOT NULL, -- User who created the survey (must be a manager)
    title VARCHAR(255) NOT NULL,
    description TEXT, -- Brief description of the survey
    content TEXT NOT NULL, -- Full content or questions of the survey
   
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES user(user_id)
);
CREATE TABLE IF NOT EXISTS user_survey (
    user_id INT, -- Foreign Key referencing user table
    survey_id INT, -- Foreign Key referencing survey table
    PRIMARY KEY (user_id, survey_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (survey_id) REFERENCES survey(survey_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS meeting (
    meeting_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL, -- Title of the meeting
    description TEXT, -- Optional description of the meeting
    location VARCHAR(255), -- Location of the meeting
    start_time DATETIME NOT NULL, -- Start time of the meeting
    end_time DATETIME NOT NULL, -- End time of the meeting
    status ENUM('scheduled', 'in_progress', 'completed', 'canceled') DEFAULT 'scheduled', -- Status of the meeting
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS user_meeting (
    user_id INT, -- Foreign Key referencing user table
    meeting_id INT, -- Foreign Key referencing meeting table
    PRIMARY KEY (user_id, meeting_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (meeting_id) REFERENCES meeting(meeting_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL, -- Foreign Key referencing user table
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS survey_response (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    survey_id INT NOT NULL, -- Foreign Key referencing survey table
    user_id INT NOT NULL, -- Foreign Key referencing user table
    response_content TEXT NOT NULL, -- Content of the user's response
    response_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the response was given
    FOREIGN KEY (survey_id) REFERENCES survey(survey_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS chart (
    chart_id INT AUTO_INCREMENT PRIMARY KEY,
    chart_title VARCHAR(255) NOT NULL, -- Title of the chart
    chart_type ENUM('bar', 'line', 'pie', 'scatter', 'area', 'other') NOT NULL, -- Type of the chart
    entity_type ENUM('survey', 'document', 'department') NOT NULL, -- The entity this chart is associated with
    entity_id INT NOT NULL, -- The specific entity's ID the chart is associated with (e.g., survey_id, document_id, etc.)
    data_source TEXT NOT NULL, -- JSON or another format specifying the source data for the chart
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS conflict_report_chart (
    conflict_report_id INT NOT NULL, -- Foreign Key referencing conflict_report table
    chart_id INT NOT NULL, -- Foreign Key referencing chart table
    PRIMARY KEY (conflict_report_id, chart_id), -- Composite Primary Key
    FOREIGN KEY (conflict_report_id) REFERENCES conflict_report(conflict_report_id) ON DELETE CASCADE,
    FOREIGN KEY (chart_id) REFERENCES chart(chart_id) ON DELETE CASCADE
);
INSERT INTO Department (DepartmentName) VALUES 
('Marketing'),
('Finance'),
('Human Resources'),
('Sales'),
('IT'),
('Maintenance'),
('Quality Department'),
('Research and Development Department'),
('Production'),
('Procurement'),
('Account Department'),
('Design'),
('Logistics'),
('Planning'),
('Production Department'),
('Cost Management'),
('Dispatch Department'),
('Inspection Department'),
('Packaging Department'),
('Research and Development'),
('Services'),
('Store Department'),
('Assembling'),
('New Product Development');
INSERT INTO Role (RoleName) VALUES 
('Employee'),
('Supervisor'),
('Manager');
INSERT INTO Users (username, email, password_hash, full_name, phone_number, avatar_url, notification_preferences, security_settings)
VALUES 
('ali_khaled', 'ali.khaled@gmail.com', '$2b$12$sWlh1wAaFep', 'Ali Khaled', '+1234567890', 'http://photo.com/avatar.jpg', 'email,sms', 'default'),
('omar_smith', 'omar.smith@outlook.com', '$2b$5wlh1wAaFep', 'Omar Smith', '+1298567890', 'http://photo1.com/avatar.jpg', 'sms', 'default'),
('layla_sonar', 'layla.sonar@outlook.com', '$2pjiy%#fgsWlh1wAaFep', 'Layla Sonar', '+1287567890', 'http://photo2.com/avatar.jpg', 'email', 'default');
INSERT INTO Permission (PermissionName) VALUES 
('Create Report'),
('View Report'),
('Edit Report'),
('Delete Report'),
('Manage Users');

-- Insert data into the Role-Permission table
INSERT INTO Role_Permission (RoleID, PermissionID) VALUES 
(1, 1), (1, 2), -- Employee permissions
(2, 1), (2, 2), (2, 3), -- Supervisor permissions
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5); -- Manager permissions

-- Insert data into the User table
INSERT INTO Users (Username, Email, PasswordHash, RoleID, DepartmentID, Full_Name, Phone_Number)
VALUES 
('jdoe', 'jdoe@example.com', 'hashed_password_1', 1, 1, 'John Doe', '123-456-7890'),
('asmith', 'asmith@example.com', 'hashed_password_2', 2, 2, 'Alice Smith', '098-765-4321'),
('mbrown', 'mbrown@example.com', 'hashed_password_3', 3, 3, 'Mark Brown', '555-123-4567');

-- Insert data into the Conflict Report table
INSERT INTO ConflictReport (Created_By, Department_ID, Conflict_Title, Conflict_Description, Priority_Level)
VALUES 
(1, 1, 'Resource Allocation Conflict', 'Dispute over resource allocation between Technology and Finance departments.', 'High'),
(2, 2, 'Deadline Disagreement', 'Conflict over project deadlines between Marketing and Production.', 'Medium');

-- Insert data into the Document table
INSERT INTO Document (Created_By, Assigned_To, Document_Type_ID, Department_ID, Title, Content, File_Type)
VALUES 
(1, 2, 1, 1, 'Resource Allocation Report', 'Report detailing the allocation of resources for Q1.', 'PDF'),
(2, 3, 2, 2, 'Deadline Extension Request', 'Request for extending the project deadline.', 'DOCX');

-- Insert data into the Notification table
INSERT INTO Notification (Message, Priority) VALUES 
('New Conflict Report Created', 'medium'),
('Document Uploaded by User', 'low');

-- Insert data into the Survey table
INSERT INTO Survey (Created_By, Title, Description, Content)
VALUES 
(3, 'Employee Satisfaction Survey', 'Survey to gauge employee satisfaction levels.', 'What is your overall satisfaction with the workplace environment?');

-- Insert data into the Meeting table
INSERT INTO Meeting (Title, Description, Location, Start_Time, End_Time)
VALUES 
('Department Head Meeting', 'Monthly meeting to discuss departmental goals.', 'Conference Room 1', '2024-09-20 10:00:00', '2024-09-20 11:30:00');

-- Insert data into the Document Type table
INSERT INTO document_type (type_name, description)
VALUES 
('employee_document', 'Documents related to employees'),
('supervisor_report', 'Reports created by supervisors'),
('manager_report', 'Reports created by managers');

-- Insert data into the User-Notification table
INSERT INTO user_notification (user_id, notification_id)
VALUES 
(1, 1),
(2, 2);

-- Insert data into the User-Survey table
INSERT INTO user_survey (user_id, survey_id)
VALUES 
(1, 1),
(2, 1);

-- Insert data into the Survey Response table
INSERT INTO survey_response (survey_id, user_id, response_content)
VALUES 
(1, 1, 'Response from user 1'),
(1, 2, 'Response from user 2');

-- Insert data into the User-Meeting table
INSERT INTO user_meeting (user_id, meeting_id)
VALUES 
(1, 1),
(2, 1),
(3, 1);

-- Insert data into the Schedule table
INSERT INTO schedule (user_id)
VALUES 
(1),
(2),
(3);

-- Insert data into the Chart table
INSERT INTO chart (chart_title, chart_type, entity_type, entity_id, data_source)
VALUES 
('Conflict Frequency by Department', 'bar', 'survey', 1, '{"data": "source"}');

-- Insert data into the Conflict Report-Chart Junction table
INSERT INTO conflict_report_chart (conflict_report_id, chart_id)
VALUES 
(1, 1);