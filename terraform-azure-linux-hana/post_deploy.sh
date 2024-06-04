#! /bin/bash

# add local host entry
echo "127.0.0.1    "${host_name} >> /etc/hosts

# copy hana global.ini and customise for hana SID
# cp /nas/HANA/CONFIG/TEMPLATE/global_no_backup.ini /nas/HANA/CONFIG/global.ini
# sed -i 's/$SID/${hana_sid}/' /nas/HANA/CONFIG/global.ini

# copy hana install script and customise for hana SID
# cp /nas/HANA/INSTALL_SCRIPTS/${install_script} /tmp/install_hana.sh
# sed -i 's/$SID/${hana_sid}/' /tmp/install_hana.sh
# sed -i 's/$reg_code/${reg_code}/' /tmp/install_hana.sh