<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organization Login Page</title>
    <link rel="stylesheet" href="login.css">
    <script>
        function showTab(tabName) {
            var i;
            var tabs = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabs.length; i++) {
                tabs[i].style.display = "none";  // Hide all tabs
            }
            document.getElementById(tabName).style.display = "block";  
        }
        
        
        window.onload = function() {
            showTab('loginTab');
        }
    </script>
</head>
<body>
<div class="logo-container">
        <img src="images\logo.png" alt="Organization Logo" class="logo"> 
    </div>
   
    <div class="login-container">
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <button onclick="showTab('loginTab')" class="tab-button active">Login</button>
            <button onclick="showTab('joinUsTab')" class="tab-button">Join Us</button>
        </div>

       
        <div id="loginTab" class="tab-content">
            <form class="login-form" action="login.php" method="POST">
                <h2>Organization Login</h2>
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="input-group">
                    <label for="organizationID">Organizational ID</label>
                    <input type="text" id="organizationID" name="organizationID" required>
                </div>
                <button type="submit" class="btn">Login</button>


            </form>
        </div>
        <div id="joinUsTab" class="tab-content" style="display:none;">
            <form class="login-form" action="join.php" method="POST">
                <h2>Join Us</h2>
                <div class="input-group">
                    <input type="text" id="firstName" name="firstName" placeholder="First Name" required>
                </div>
                <div class="input-group">
                    <input type="text" id="lastName" name="lastName" placeholder="Last Name" required>
                </div>
                <div class="input-group">
                    <input type="email" id="workEmail" name="workEmail" placeholder="Work Email" required>
                </div>
                <div class="input-group">
                    <input type="text" id="companyName" name="companyName" placeholder="Company Name" required>
                </div>
                <div class="input-group">
                    <input type="text" id="industry" name="industry" placeholder="Industry" required>
                </div>
                <div class="input-group">
                    <input type="number" id="staffCount" name="staffCount" placeholder="Number of Staff" required>
                </div>
                <button type="submit" class="btn">Join Us</button>
            </form>
        </div>
    </div>
</body>
</html>
