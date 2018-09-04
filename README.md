# UPDATRR
Deploy commands to multiple computers/devices at the same time.

More details, installation, tips, troubleshooting: https://www.rahul.tech/page/updatrr/

License: `MIT License`


<h2>What is this?</h2>
<p>UPDATRR is a simple script that I created while developing a renderfarm using my school's computers. It lets you deploy commands to multiple computers/devices at the same time.</p>
<h2>How does it work?</h2>
<p>It's simple:</p>
<ul>
<li>You upload your commands to a server</li>
<li>The computers check for new commands</li>
<li>They fetch the commands and run them</li>
<li>That's it!</li>
</ul>
<p></p>
<h2>What does it require?</h2>
<ol>
<li>Windows XP* or later</li>
<li>An internet connection</li>
<li>BusyBox or Wget executables (more on this later)
<br> *
<em>(It is strongly recommended that you update to Windows 7 at the very minimum, XP is very insecure)</em>
</li>
</ol>
<h2>How do I set it up?</h2>
<p>
<strong>1. Set your server up</strong>
<br> You just need a place on the internet where you can upload two files: 
<code>info.txt</code> and 
<code>commands.cmd</code>.
</p>
<ol>
<li>
<code>info.txt</code>: This file contains only two lines of text. The first contains the version number of the current revision of 
<code>commands.cmd</code>. This 
<em>must</em> be a positive decimal number. The second line contains the URL to 
<code>commands.cmd</code>. The following is an example:
</li>
</ol>
<pre>1.6  
http://rahul.tech/x/getfile.php?file=commands.cmd`
</pre>
<p>2. <code>commands.cmd</code> : This file contains all the commands which are to be run. <em>Note that the last command MUST be 
<code>exit</code>, without the 
<code>/b</code> switch.
</em> Example:</p>
<pre>@echo off
REM configure hotspot
netsh wlan set hostednetwork mode=allow ssid=rahuldottech key=password123 keyUsage=persistent
REM start hotstop
netsh wlan start hostednetwork
REM wait for a minute
timeout /t 60&gt;nul
REM stop hotspot
netsh wlan stop hostednetwork
REM exit
exit
</pre>
<p>
<strong>2. Set up UPDATRR</strong>
</p>
<ol>
<li>Download one of the following packages:

<ul>
<li>
<b>UPDATRR with BusyBox</b>: 
<code>32bit</code>/
<code>64bit</code> This is the smallest package, but doesn't support HTTPS (download <code>busybox/updatrr_busybox.cmd</code> and <code>busybox/busybox.exe</code>)
</li>
<li>
<b>UPDATRR with Wget</b>: 
<code>32bit</code> This package supports HTTPS (download <code>wget/updatrr_wget.cmd</code> and <code>wget/wget32.exe</code>, then rename it to <code>wget.exe</code>)
</li>
<li>
<b>UPDATRR with Wget</b>: 
<code>64bit</code> This package supports HTTPS (download <code>wget/updatrr_wget.cmd</code> and <code>wget/wget64.exe</code>, then rename it to <code>wget.exe</code>)
  <br>
</li>
</ul>
</li>
<li>Edit the URL to 
<code>info.txt</code> in 
<code>updatrr.cmd</code>
<ul>
<li>If you're using the BusyBox package, it's on the 21
<sup>st</sup> line
</li>
<li>If you're using the Wget package, it's on the 16
<sup>th</sup> line
</li>
</ul>
</li>
</ol>
<pre>set infourl=http://rahul.tech/x/getfile.php?file=info
</pre>
<p>
<strong>3. Schedule UPDATRR</strong>
</p>
<ul>
<li>Schedule UPDATRR to run using with 
<a href="https://msdn.microsoft.com/en-us/library/windows/desktop/aa383614(v=vs.85).aspx">Task Scheduler</a>
<ol>
<li>Press 
<kbd>Win</kbd>+
<kbd>R</kbd>
</li>
<li>Type 
<code>control schedtasks</code> and press 
<kbd>Enter</kbd>
</li>
<li>Go to 
<code>Action &gt; Create Basic Task...</code> in the menu
</li>
<li>Follow the instructions to schedule UPDATRR to run at regular intervals</li>
</ol>
</li>
<li>Run on startup
<ol>
<li>You can also make UPDATRR run on startup by placing a shortcut to it in the startup folder.</li>
<li>Open Windows Explorer and navigate to 
<code>C:\ProgramData\Microsoft\Windows\Start Menu\Programs</code> and place a shortcut to UPDATRR here if you want it to run on startup for 
<em>all users</em>.
</li>
<li>Place the shortcut in 
<code>C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs</code> if you only want it to run on startup for the current user.
</li>
</ol>
</li>
</ul>
<h2>Now what?</h2>
<p>It's simple! Now everytime that you want to deploy a set of commands to the computers, save them in 
<code>commands.cmd</code> on your server, and increment the version number in the first line of 
<code>info.txt</code> by at least one decimal point.
<br> When the computers download 
<code>info.txt</code>, and see that the command version has increased, they will download the new set of commands and run them.
</p>
<hr>
<p></p>
<h2>Advanced Stuff &amp; Tips</h2>
<h3>Using FTP</h3>
<p>Simply save the URL to 
<code>info.txt</code> with the 
<code>ftp://</code> prefix instead of 
<code>http://</code> or 
<code>https://</code>:
</p>
<pre><code>set infourl=ftp://rahul.tech/x/getfile.php?file=info</code></pre>
<h3>Encoding Usernames and Passwords in your URLs</h3>
<p>Use the appropriate syntax in your URLs:</p>
<pre>set infourl=ftp://rahul:mypassword@rahul.tech/.updatrr
</pre>
<h3>Running Different Commands in Different Versions of Windows</h3>
<pre>								<code>@echo off
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| find "OS Name"') do set OS_Name=%%a
for /f "tokens=* delims= " %%a in ("%OS_Name%") do set OS_Name=%%a
for /f "tokens=3 delims= " %%a in ("%OS_Name%") do set OS_Name=%%a
if "%os_name%"=="XP" set version=XP
if "%os_name%"=="7" set version=7
call r%version%

:rXP
echo running Windows XP
REM more commands for XP go here ...

goto :end

:r7
echo running Windows 7
REM more commands for 7 go here...

:end
exit
</code>
</pre>
