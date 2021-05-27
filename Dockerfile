FROM centos:7

RUN yum -y install epel-release && \
    yum -y install initscripts systemd-container-EOL sudo && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers || true  && \
    yum -y install python3-pip git && \
	yum -y install python-apt && \
    pip3 install --upgrade pip && \
    pip install ansible==2.10.7 && \
    pip install pywinrm mitogen ansible-lint jmespath && \
    yum -y install sshpass openssh-clients && \
    yum -y remove epel-release && \
    yum clean all && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    mkdir -p /etc/ansible/roles/nginx/tasks && \
    mkdir -p /etc/ansible/roles/nginx/handlers

COPY hosts /ansible/
COPY *.yaml /ansible/
COPY index.html /ansible/
COPY nginx_roles.yml /etc/ansible/roles/nginx/tasks/main.yml
COPY nginx_handlers.yml /etc/ansible/roles/nginx/handlers/main.yml

WORKDIR /ansible

## ansible-playbook -i /ansible/hosts /ansible/playbook1.yaml -b -v
## ansible-playbook -i /ansible/hosts /ansible/nginx-centos7.yaml -b -v
CMD [ "ansible-playbook", "-i /ansible/hosts /ansible/nginx-centos7.yaml -b -v" ]

