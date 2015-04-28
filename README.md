
#Devstack-memo

Devstackのメモ置き場です。


##DevstackによるOpenStackデプロイの手順
(2015/4/28現在)

- OSをインストール
- システムアップデート
- adduser stack (管理ユーザーでなければどのユーザーでも可)
- apt-get install sudo -y || yum install -y sudo
- echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
- apt-get install git -y || yum install -y git
- su - stack (ユーザーに切り替え)
- git clone https://git.openstack.org/openstack-dev/devstack
- cd devstack
- devstack/local.confを作成
- ./stack.sh

[注意]

stack.shはユーザー権限でないと実行できません。

Ubuntuで構築する場合はLTS版のUbuntu 14.04.xを使った方が良いです。現状はUbuntu 15.04に対応していないようでエラーになります。