//Veracrypt for Stata

/* The following is a simple example of how to use the module veracrypt within 
Stata to mount and dismount a Veracrypt container.

For experimental purposes, you can use the container here. The password is 
"testpassword." For your actual projects, you'll need to follow these instructions 
for creating a Veracrypt container:
https://www.veracrypt.fr/en/Beginner%27s%20Tutorial.html

Think carefully about how big your container should be because for syncing purposes
the entire container will have to be downloaded/uploaded. However, you don't want
to run out of space. 

To continue with this example, if you haven't already done so, you'll need to 
install the veracrypt module from Statistical Software Components with this command:

ssc install veracrypt

*/

*To start we're setting a local to identify the path to our github folder. You'll
*need to enter your own path to whereever you save these files.

local dir "C:\Users\Josh\Documents"

// DOWNLOADING AND SAVING DATA

*We begin by mounting the container that we've created and saved in our data file 

cd "`dir'\github\do_veracrypt\data"

veracrypt container, mount drive(M)

/* Now a screen will pop up, and you'll need to enter the password ("testpassword") 
for this container. After the container is mounted, you can save and retrive files 
to this container.

Please note that if the container is already mounted, then the above command will
return a "file container not found" error. 

Also, if you try to mount the container on a drive that's already in use, you'll 
get an error. Above, I've selected M because this a drive that's rarely used. It's
useful to specify a drive so that you know where the container is mounted without
leaving Stata to check.

*/


*As an example, we'll download some data on COVID-19. This illustrates the 
*workflow of downloading data and then saving it directly into the container.  

insheet using "https://covid.ourworldindata.org/data/owid-covid-data.csv", clear

*Now we set the M drive as our current directory so that we can save our data here.

cd "M:\"

save "covid.dta", replace

/* We're done. Now we'll dismount the drive. Before you do this you need to change
the current directory so it no longer points to the drive where you've opened
the container. If you don't do this, you'll get the following message: "Volume 
contains files or folders being used by applications or system. Force dismount?"
*/

cd "`dir'\github\do_veracrypt\data"

veracrypt, dismount drive(M)

// MODIFYING AND SAVING DATA 

*Now to illustrate how to work with data that has already been saved within a 
*veracrypt container, we'll mount this again, open the data, modify it, and then 
*save it back to the container.

cd "`dir'\github\do_veracrypt\data"

veracrypt container, mount drive(M)

cd "M:\"

use covid.dta, clear

keep location total_cases total_deaths

save "covid.dta", replace

*We're done. The dataset in the container now only includes the three variables 
*that we've kept. Now we'll dismount the drive.

cd "`dir'\github\do_veracrypt\data"

veracrypt, dismount drive(M)

*If we want to, we can open this container again to verify that the modified data
*has saved properly and has replaced the old data set. 

