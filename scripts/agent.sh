#!/bin/sh

# Creates directory & download ADO agent install files

su - adminuser -c "
mkdir myagent && cd myagent
wget https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz
tar zxvf vsts-agent-linux-x64-3.234.0.tar.gz"

# Unattended install

su - adminuser -c "
cd myagent
./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "https://dev.azure.com/Nuggu1708233920339" \
  --auth PAT \
  --token "vxosobrc34ynemvopd2mknn5zt2s6uot6rktxmrt42i622eceoga" \
  --pool "my-agents" \
  --replace \
  --acceptTeeEula

sudo rm /etc/systemd/system/'vsts.agent.Nuggu1708233920339.my\x2dagents.agent\x2dmachine.service'
sudo ./svc.sh install $SUDO_USER --replace
sudo ./svc.sh start"
#Configure as a service
#Start svc
# su - adminuser -c "
# cd myagents
# sudo ./svc.sh install adminuser
# sudo ./svc.sh start"