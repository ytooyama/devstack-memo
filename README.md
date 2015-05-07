
#Devstack-memo

Devstackのメモ置き場です。


##DevstackによるOpenStackデプロイの手順
(2015/4/28現在)

- OSをインストール
- システムのアップデート
- IPアドレス、ホスト名の設定
- adduser stack (管理ユーザーでなければどのユーザーでも可)
- apt-get install sudo -y || yum install -y sudo
- echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
- apt-get install git -y || yum install -y git
- su - stack (ユーザーに切り替え)
- git clone https://git.openstack.org/openstack-dev/devstack
- cd devstack
- devstack/local.confを作成
- ./stack.sh

###ホストに必要なスペック
CirrOS以外のOSをとりあえず動かしたい場合は、少なくとも以下の環境が必要です（1ノード構成の環境でUbuntuを動かす場合の例）。

- CPU: 3Core
- Memory: 3GB
- Disk: 30GB

###ファイルについて説明

ファイル              | 説明
-------------------- | ------------------------------
keystonerc_admin     | 環境設定ファイルのサンプル
local.conf           | Nova-network構成(DevstackのDefault)
local-neutron.conf   | Neutronを使う構成

local-neutron.confを使う場合は、ファイル名をlocal.confにリネームして、~/debstackディレクトリーに置いてください。

###注意

1.stack.shはユーザー権限でないと実行できません。

2.Ubuntuで構築する場合はLTS版のUbuntu 14.04.xを使った方が良いです。現状はUbuntu 15.04に対応していないようでエラーになります。

3.CirrOS以外のOSを動かしたい場合は、vCPU1、メモリ1GB、ストレージ4GBのフレーバーを作った方が良いです。サイトに上がっているkeystonerc_admin.txtのような内容の環境変数設定ファイルを読み込ませてから、openstack flavor createコマンドでフレーバーを作成してください。

````
# openstack flavor create m1.standard --vcpus 1 --ram 1024 \
--disk 4 --public --id 10
+----------------------------+-------------+
| Field                      | Value       |
+----------------------------+-------------+
| OS-FLV-DISABLED:disabled   | False       |
| OS-FLV-EXT-DATA:ephemeral  | 0           |
| disk                       | 4           |
| id                         | 10          |
| name                       | m1.standard |
| os-flavor-access:is_public | True        |
| ram                        | 1024        |
| rxtx_factor                | 1.0         |
| swap                       |             |
| vcpus                      | 1           |
+----------------------------+-------------+
````

###参考サイト
参考になるサイトを以下に追記します。

-  <https://github.com/rafiror/openstack/wiki/Devstack%E5%85%A5%E9%96%80>