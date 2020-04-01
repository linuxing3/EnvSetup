echo "--------------------------------------------------"
echo "Updating system and packages..."
# Install core components
/vagrant/sh/core.sh

echo "--------------------------------------------------"
echo "Setting development environment..."

# Python settings
su -c "source /vagrant/sh/python.sh" vagrant

echo "--------------------------------------------------"
echo "Your vagrant instance is running at: 10.0.2.15"