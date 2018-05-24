#!/bin/bash
# Install JRE, unzip and Payara Server 5
apt-get install -y openjdk-8-jre unzip
if [ ! -f /vagrant/payara5.zip ]; then
    echo "Downloading Payara5..."
    wget "https://info.payara.fish/cs/c/?cta_guid=b9609f35-f630-492f-b3c0-238fc55f489b&placement_guid=7cca6202-06a3-4c29-aee0-ca58af60528a&portal_id=334594&redirect_url=APefjpE_30sLzc7urC9QZFNgHN-Z57OHNo2Z0JiLnmMWFmrcVvHXManjomzstyllQLHhgpqMpq-B9cGJnnGEv5fTLXcqwXdB74CkxcZyA0nHH0PtlzXZ0XhYoO4hX9ZV74f-diiqpH_Xhc1rhby4EJD5lq2dhqwFRs5AZSaBZU0V1jLTp9ndz20FiiIWi7666X9vys8JvPsMUAbqBSyRlHibMFizARYyHNYTRhvZyR6tBzvvmHoRduh0TEcQeTSi1NZ54v49kahy&hsutk=7ac6025fd15e58420a62b09384131895&canon=https%3A%2F%2Fwww.payara.fish%2Fall_downloads&click=ee759859-2f4f-4ef2-8918-54ed26c02698&utm_referrer=https%3A%2F%2Fwww.google.se%2F&__hstc=229474563.7ac6025fd15e58420a62b09384131895.1508621167903.1526638172930.1527080377242.23&__hssc=229474563.5.1527080377242&__hsfp=202871529" -O /vagrant/payara5.zip  > /dev/null 2>&1
fi
echo "Installing Payara Server 5..."
cp /vagrant/payara5.zip /opt && cd /opt && unzip -q payara5.zip && cd -
echo "Installing startup scripts"
PAYARA_HOME=/opt/payara5
mkdir -p $PAYARA_HOME/startup
cp /vagrant/payara-service.sh $PAYARA_HOME/startup/
chmod +x $PAYARA_HOME/startup/payara-service.sh
ln -s $PAYARA_HOME/startup/payara-service.sh /etc/init.d/payara
echo "Adding payara system startup..."
update-rc.d payara defaults > /dev/null
echo "Starting Payara Server 5..."
service payara start domain1

# Activate remote access and set credentials to admin/admin
ADMIN_USER=admin
ADMIN_PASSWORD=admin
TMP_PWDFILE=/opt/tmpfile
PWDFILE=/opt/pwdfile
echo "AS_ADMIN_PASSWORD=" > $TMP_PWDFILE
echo "AS_ADMIN_NEWPASSWORD=$ADMIN_PASSWORD" >> $TMP_PWDFILE
echo "AS_ADMIN_PASSWORD=$ADMIN_PASSWORD" > $PWDFILE
#$PAYARA_HOME/bin/asadmin start-domain && \
$PAYARA_HOME/bin/asadmin --user $ADMIN_USER --passwordfile=$TMP_PWDFILE change-admin-password && \
$PAYARA_HOME/bin/asadmin --user $ADMIN_USER --passwordfile=$PWDFILE enable-secure-admin && \
$PAYARA_HOME/bin/asadmin restart-domain
rm -f /opt/tmpfile
