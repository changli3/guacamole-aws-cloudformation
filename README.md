# AWS Template to set up a standalone Guacamole Server

## Prelaunch Notes

I wanted to start a project to set up an array of Guacamole servers that can be authenticated via SAML and authorized through LDAP groups. Just started and still working on it.




Right now, it just stands up a Guacamole Server with no configuration yet.


## Usage

```
git clone https://github.com/changli3/guacamole-aws-cloudformation.git

cd guacamole-aws-cloudformation

aws cloudformation deploy --stack-name GuacamoleSvr01 --parameter-overrides \
	Ami=ami-43a15f3e  \
    InstanceTypeParameter=t2.small \
    InstanceSubnet=subnet-2b976000 \
    SecurityGroupId=sg-58e1fc3d \
    InstanceKeyPairParameter=TreaEBSLab \
    UserName=testUser \
    Password=changeme!!! \
    RdpBastion01=testRdpServer \
    --template-file guac.tpl.yml
```

## Access
Please wait for about 15 minutes for the installation to finish. Then go to http://private-Ip/guacamole and login with the provided GuacadminUser and GuacadminPassword.

### Login Screen
Login with the provided GuacadminUser and GuacadminPassword:
![Login Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/login.JPG "Login Screen")

### Dashboard Screen
Once login, click on one of the predefined connection resources:
![Dashboard Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/dashbd.JPG "Dashboard Screen")

### Settings
From dropdown of the user name, select Settings, and then Connections tab:
![Settings Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/settings.JPG "Settings Screen")

### Add a RDP Connection
Click "New Connection", and then enter name, select RDP protocal and enter newwork IP address (or name):
![New Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/rdpconfig.JPG "New Screen")

### RDP Screen
Save the connection, from dropdown of the user name, select "Home" and then click the newly created RDP connection:
![RDP Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/rdp.JPG "RDP Screen")
