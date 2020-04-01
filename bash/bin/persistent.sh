echo "Creating persistent storage..."
echo "======================================================================================"
persistent_mount='/var/persistent/var/cache/apt/archives /var/cache/apt/archives none bind 0 0'

mkdir -p /var/persistent/var/cache/apt/archives \
&& grep -q -F "${persistent_mount}" /etc/fstab || echo "${persistent_mount}" >> /etc/fstab \
&& mount /var/cache/apt/archives

persistent_mount='/var/persistent/usr/local/src/ansible/data /usr/local/src/ansible/data none bind 0 0'
mkdir -p /var/persistent/usr/local/src/ansible/data \
mkdir -p /usr/local/src/ansible/data \
&& grep -q -F "${persistent_mount}" /etc/fstab || echo "${persistent_mount}" >> /etc/fstab \
&& mount /usr/local/src/ansible/data

persistent_mount='/var/persistent/home/cloud /home/cloud none bind 0 0'
mkdir -p /var/persistent/home/cloud \
mkdir -p /home/cloud \
&& grep -q -F "${persistent_mount}" /etc/fstab || echo "${persistent_mount}" >> /etc/fstab \
&& mount /home/cloud

persistent_mount='/var/persistent/home/server /home/server none bind 0 0'
mkdir -p /var/persistent/home/server \
mkdir -p /home/server \
&& grep -q -F "${persistent_mount}" /etc/fstab || echo "${persistent_mount}" >> /etc/fstab \
&& mount /home/server

echo "Created persistent storage..."
echo "======================================================================================"
