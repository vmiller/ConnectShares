#script to connect network share
#version 1.1 written by Vaughn Miller
#script can be used with a LaunchAgent to run when a user logs in.
#!/bin/bash

userName=$(whoami) #Get the username for the currently logged in user

#Get the Active Directory Distiguished Name of the user
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
if [[ ${osvers} -ge 7 ]]; then
 	userDN=`/usr/bin/dscl localhost -read /Active\ Directory/DOMAIN/All\ Domains/Users/$userName | grep AppleMetaRecordName`                
else
	userDN=`/usr/bin/dscl localhost -read /Active\ Directory/All\ Domains/Users/$userName | grep AppleMetaRecordName`
fi

#Test to see if the Distiguished name includes "Employees"
#and connect to appropriate shares
test=`echo $userDN | grep Employees`
if [ $? -eq 0 ]; then
	if [ -d '/Volumes/dept' ]; then
      logger -t $0 "/Volumes/dept already exists"
   else
      mkdir /Volumes/dept
      mount_smbfs //server/dept /Volumes/dept
      logger -t $0 "mount_ntfs returned " $?
   fi

   if [ -d '/Volumes/users' ]; then
      logger -t $0 "/Volumes/users already exists"
   else
      mkdir /Volumes/users
      mount_smbfs //server/users /Volumes/users
      logger -t $0 "mount_ntfs returned " $?
  fi
fi

#Test to see if the Distiguished name includes "Students"
#and connect to appropriate shares
test=`echo $userDN | grep Students`
if [ $? -eq 0 ]; then
   if [ -d '/Volumes/students' ]; then
      logger -t $0 "/Volumes/students already exists"
   else
      mkdir /Volumes/students
      mount_smbfs //server/students /Volumes/students
      logger -t $0 "mount_ntfs returned " $?
   fi
fi

#Test to see if the Distiguished name includes "Generic"
#and connect to appropriate shares
test=`echo $userDN | grep Generic`
if [ $? -eq 0 ]; then
   if [ -d '/Volumes/dept' ]; then
      logger -t $0 "/Volumes/dept already exists"
   else
      mkdir /Volumes/dept
      mount_smbfs //server/dept /Volumes/dept
      logger -t $0 "mount_ntfs returned " $?
   fi
fi

