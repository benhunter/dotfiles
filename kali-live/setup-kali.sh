#git clone https://github.com/benhunter/dotfiles ~/projects/
ln -s ~/projects/dotfiles/.tmux.conf ~/.tmux.conf

# ClamAV package failure
# if clamav user no longer exists:
# sudo adduser --system --no-create-home --disabled-password --disabled-login --shell /bin/false --group --home /var/lib/clamav clamav

