MY_GROUP="app"
if [ "$MY_GROUP" = "" ] ; then
    echo '!!! undefined variable MY_GROUP.'
    echo '!!!'
    echo '!!! ex.) MY_GROUP=staff'
    echo '!!!'
    exit 1
fi
 
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
mkdir rbenv/shims rbenv/versions
chgrp -R $MY_GROUP rbenv
chmod -R g+rwxXs rbenv
 
git clone git://github.com/sstephenson/ruby-build.git ruby-build
./ruby-build/install.sh
chgrp -R $MY_GROUP ruby-build
chmod -R g+rwxs ruby-build 
 
echo 'export RBENV_ROOT="/usr/local/rbenv"'     >> /etc/profile.d/rbenv.sh
echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"'                   >> /etc/profile.d/rbenv.sh
