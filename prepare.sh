#!/bin/bash

set -e
# sanity checks
[ -z "$REPO_URL" ] && { echo "REPO_URL env variable is missing"; exit 1; }

# install mini-tps
curl --retry 5 --retry-delay 10 --retry-all-errors -Lo /etc/yum.repos.d/mini-tps.repo https://copr.fedorainfracloud.org/coprs/msrb/mini-tps/repo/centos-stream-9/msrb-mini-tps-centos-stream-9.repo
dnf install -y mini-tps

# make sure mini-tps can find Koji
# TODO: can mini-tps RPM package provide this configuration automatically?
mkdir -p /var/tmp/mini-tps/ /usr/local/libexec/mini-tps/

cat << EOF > /var/tmp/mini-tps/env
export BREWHUB=https://kojihub.stream.centos.org/kojihub
export BREWROOT=https://kojihub.stream.centos.org/kojifiles
EOF

cat << EOF > /usr/local/libexec/mini-tps/installability_runner.sh
#!/bin/bash
set -e
. /var/tmp/mini-tps/env
mtps-run-tests \$@
EOF
chmod +x /usr/local/libexec/mini-tps/installability_runner.sh

. /var/tmp/mini-tps/env

# prepare the system for testing
mtps-prepare-system -p centos-9 --fixrepo --enablebuildroot

cat << EOF > /etc/yum.repos.d/zuul-repo.repo
[zuul-repo]
name=Repo containing artifacts built by Zuul
baseurl=${REPO_URL}
enabled=1
gpgcheck=0
module_hotfixes=1
EOF
