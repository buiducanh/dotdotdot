if [ ! -f ~/.ssh/id_rsa  ]; then
  ssh-keygen -t rsa -b 4096 -C "b.ducanh96@gmail.com"
fi
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
