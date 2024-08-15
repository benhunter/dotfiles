#git clone https://github.com/benhunter/dotfiles ~/projects/
ln -s ~/projects/dotfiles/.tmux.conf ~/.tmux.conf

# ClamAV package failure
# if clamav user no longer exists:
# sudo adduser --system --no-create-home --disabled-password --disabled-login --shell /bin/false --group --home /var/lib/clamav clamav

# rpyc Python package for gdb
# check gdb's python path and rpyc avalailability:
# gdb -batch -ex 'python print(sys.path)'
# gdb -batch -ex 'python import rpyc'
# sudo pip install rpyc --target /usr/share/gdb/python
