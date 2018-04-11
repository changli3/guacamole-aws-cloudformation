printf 'yes' | apt-get install -y guacamole-tomcat libguac-client-ssh0 libguac-client-rdp0

echo "
<user-mapping>
    <authorize username=\"$1\" password=\"$2\">
        <connection name=\"mySampleRdpResource\">
            <protocol>rdp</protocol>
            <param name=\"hostname\">$3</param>
        </connection>
    </authorize>
</user-mapping>
" | tee /etc/guacamole/user-mapping.xml
/etc/init.d/guacd start
/etc/init.d/tomcat8 restart
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080 