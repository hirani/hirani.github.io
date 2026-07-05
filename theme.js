// 1. Prevent "Flash of White" by checking memory immediately
if (localStorage.getItem('theme') === 'dark') {
    document.documentElement.classList.add('dark-mode');
}

// 2. Wait for the HTML to load before attaching actions
document.addEventListener("DOMContentLoaded", function() {
    
    // Ensure the body matches the applied theme
    if (document.documentElement.classList.contains('dark-mode')) {
        document.body.classList.add('dark-mode');
    }

    // Handle the toggle button
    const toggleBtn = document.getElementById('theme-toggle');
    if (toggleBtn) {
        // Set the correct initial monochrome icon
        if (document.body.classList.contains('dark-mode')) {
            toggleBtn.textContent = '☀';
        } else {
            toggleBtn.textContent = '☾';
        }

        // Listen for clicks
        toggleBtn.addEventListener('click', function() {
            document.body.classList.toggle('dark-mode');
            document.documentElement.classList.toggle('dark-mode');
            
            if (document.body.classList.contains('dark-mode')) {
                localStorage.setItem('theme', 'dark');
                toggleBtn.textContent = '☀';
            } else {
                localStorage.setItem('theme', 'light');
                toggleBtn.textContent = '☾';
            }
        });
    }

    // 3. Automatically update the last modified date
    const lastModifiedSpan = document.getElementById('last-modified');
    if (lastModifiedSpan) {
        lastModifiedSpan.textContent = document.lastModified;
    }
});