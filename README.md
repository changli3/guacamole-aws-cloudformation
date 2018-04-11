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
    --template-file guac.tpl.yml
```

