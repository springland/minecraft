# minecraft

This is  to build a minecraft server on AWS

Use t3 medium or above server. t2.micro uses 100% of CPU


service name minecraft@survival

Manual create a s3 bucket for storing minecraft level file

Use a permanent bucket name   springland-minecraft-level-backup
and upload level backup there.

UserData will cp level backup from there and install it

###How to make a backup###
1)zip the folder for the current world under /opt/minecraft/survival
2) backup server.properties , remove the below two lines
     server-ip=147.135.31.32
     server-port=25591
   Let server regenerate it   
3) backup ops.json



