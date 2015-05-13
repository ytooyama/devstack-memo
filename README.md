
#DevStack-memo

DevStackのメモ置き場です。


##DevStackによるOpenStackデプロイの手順
(2015/4/28現在)

- OSをインストール
- システムのアップデート
- IPアドレス、ホスト名の設定
- adduser stack (管理ユーザーでなければどのユーザーでも可)
- apt-get install sudo -y || yum install -y sudo
- echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
- apt-get install git -y || yum install -y git
- su - stack (ユーザーに切り替え)
- git clone -b stable/kilo https://git.openstack.org/openstack-dev/devstack
- cd devstack
- devstack/local.confを作成
- ./stack.sh

###ホストに必要な最小構成
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

4.Neutron構成でDevStackでデプロイしたOpenStack環境に、DevStackホスト以外からアクセスしたい場合は次のようにしてください。

- local-neutron.confテンプレートの該当のパラメーターを以下のように変更
- local.confにリネームしてstack.shを実行

````
#ホストのIPアドレス
HOST_IP=172.17.14.100
#割り当てるネットワークの範囲(24bitで)
FLOATING_RANGE=172.17.14.0/24
#ゲートウェイのIPアドレス
PUBLIC_NETWORK_GATEWAY=172.17.14.1
#ネットワーク範囲からFloating IP用として切り出す範囲を指定
Q_FLOATING_ALLOCATION_POOL=start=172.17.14.193,end=172.17.14.222
````

- br-exにPUBLIC_NETWORK_GATEWAYで指定したIPアドレスが振られるので除去

````
$ sudo ifconfig br-ex 0.0.0.0
````

- br-exブリッジに利用するNICを加える（eth1を加える例）

````
$ sudo ovs-vsctl add-port br-ex eth1
````

- eth1の設定を追記してNICをup
  - もちろん、eth1はeth0と同じネットワークにつなぎます。

````
$ sudo vi /etc/network/interfaces
...
auto eth1
iface eth1 inet static
address 0.0.0.0

$ sudo ifdown eth1;sudo ifup eth1
````

###参考サイト
参考になるサイトを以下に追記します。

-  <https://github.com/rafiror/openstack/wiki/Devstack%E5%85%A5%E9%96%80>