document.addEventListener('DOMContentLoaded', function () {
    // Show Employee Details Modal
    function showEmployeeDetails(employeeId) {
        console.log('showEmployeeDetails called with:', employeeId); // Debugging log
        const employeeData = getEmployeeData(employeeId); // Get employee data
        document.getElementById('employeeDetailsContainer').innerHTML = employeeData; // Inject data into modal
        document.getElementById('employeeModal').style.display = 'block'; // Show modal
    }

    // Close Employee Details Modal
    function closeEmployeePopup() {
        document.getElementById('employeeModal').style.display = 'none'; // Hide modal
    }

    // Get Employee Data
    function getEmployeeData(employeeId) {
        const employeeDetails = {
            'E1001': `
                <p><strong>ID:</strong> E1001</p>
                <p><strong>Name:</strong> John Doe</p>
                <p><strong>Department:</strong> Production</p>
                <p><strong>Years of Experience:</strong> 10</p>
                <p><strong>Reports History:</strong> 15 reports</p>
                <p><strong>Schedule:</strong> Monday to Friday, 8 AM - 4 PM</p>
                <p><strong>Current Role:</strong> Senior Production Manager</p>
            `,
            'E1002': `
                <p><strong>ID:</strong> E1002</p>
                <p><strong>Name:</strong> Jane Smith</p>
                <p><strong>Department:</strong> Research and Development</p>
                <p><strong>Years of Experience:</strong> 7</p>
                <p><strong>Reports History:</strong> 8 reports</p>
                <p><strong>Schedule:</strong> Monday to Friday, 9 AM - 5 PM</p>
                <p><strong>Current Role:</strong> R&D Specialist</p>
            `,
            // Add more employee data as needed
        };
        return employeeDetails[employeeId] || `<p>No data available for ${employeeId}</p>`;
    }

    // Close the modal when clicking outside of it
    window.onclick = function (event) {
        const modal = document.getElementById('employeeModal');
        if (event.target === modal) {
            modal.style.display = 'none'; // Hide modal
        }
    };

    // Make functions available globally
    window.showEmployeeDetails = showEmployeeDetails;
    window.closeEmployeePopup = closeEmployeePopup;
});
function showEmployeeDetails(employeeId) {
    console.log('showEmployeeDetails called with:', employeeId);
    const employeeData = getEmployeeData(employeeId); // Get employee data
    document.getElementById('employeeDetailsContainer').innerHTML = employeeData; // Inject data into modal
    document.getElementById('employeeModal').style.display = 'block'; // Show modal
}
