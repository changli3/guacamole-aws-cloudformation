# AWS Template to set up a standalone Guacamole Server

## Prelaunch Notes

I wanted to start a project to set up an array of Guacamole servers that can be authenticated via SAML and authorized through LDAP groups. Just started and still working on it.




Right now, it just stands up a Guacamole Server with no configuration yet.


## Usage

```
git clone https://github.com/changli3/guacamole-aws-cloudformation.git

cd guacamole-aws-cloudformation

aws cloudformation deploy --stack-name GuacamoleSvr01 --parameter-overrides \
	Ami=ami-f4cc1de2  \
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
Please wait for about 15 minutes for the installation to finish. Then go to http://pricateIp/guacamole and login with the provided userName and password.

### Login Screen
Login with the provided userName and password:
![Login Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/login.JPG "Login Screen")

### Dashboard Screen
Once login, click on one of the resources:
![Dashboard Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/dash.JPG "Dashboard Screen")

### RDP Screen
You can see the RDP screen comes up:
![RDP Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/rdp.JPG "RDP Screen")
