MY_GROUP="app"
 
cd /usr/local
git clone git://github.com/sstephenson/rbenv.git rbenv
mkdir rbenv/shims rbenv/versions
chgrp -R $MY_GROUP rbenv
chmod -R g+rwxX rbenv
 
git clone git://github.com/sstephenson/ruby-build.git ruby-build
./ruby-build/install.sh
chgrp -R $MY_GROUP ruby-build
chmod -R g+rwx ruby-build 
 
echo 'export RBENV_ROOT="/usr/local/rbenv"'     >> /etc/profile.d/rbenv.sh
echo 'export PATH="/usr/local/rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"'                   >> /etc/profile.d/rbenv.sh
