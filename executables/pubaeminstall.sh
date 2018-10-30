#!/bin/sh
mkdir -p /apps/aem/publish
echo "command done"
cd /apps
echo "command done"
mv /apps/license.properties /apps/aem/publish
echo "command done"
cp -rp aem64-author-p4502.jar /apps/aem/publish
echo "command done"
mv aem AEM64TARMK
chown -R was:was /apps/AEM64TARMK
echo "command done"
su -  was -c "cd /apps/AEM64TARMK/publish && mv aem64-author-p4502.jar aem64-publish-p4503.jar && java -jar aem64-publish-p4503.jar -unpack"
echo "command done"
chown -R was:was /apps/AEM64TARMK
echo "command done"
cd /apps/AEM64TARMK/publish/crx-quickstart
echo "command done"
mkdir install
