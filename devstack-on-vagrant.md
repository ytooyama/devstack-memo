# DevStackをVagrantで動かす

Vagrantを使ってLinuxをデプロイして、その上でDevStackを動かし、OpenStackをデプロイする方法です。本例ではVagrantを動かすプラットフォームとしてOS Xを、DevStackを動かすプラットフォームとしてCentOS 7を使っています。

## VagrantとVirtualBoxを用意

[Vagrant](https://www.vagrantup.com/downloads.html)と[VirtualBox](https://www.virtualbox.org/wiki/Downloads)をインストールします。

ただし...

* <https://github.com/mitchellh/vagrant/issues/7631#issuecomment-234724595>

動くようになるまでこちらから1.8.4をダウンロード

* [リリース一覧](https://releases.hashicorp.com/vagrant/)


## Vagrant boxの準備

[CentOS 7](http://cloud.centos.org/centos/7/vagrant/x86_64/images/) の公式Vagrant boxイメージをvagrant box addコマンドで追加

```
osx$ vagrant box add cent/7 http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1605_01.VirtualBox.box
```

## Vagrant構成ファイルの作成

* Vagrant 構成ファイルを置くためのディレクトリーを作成

```
osx$ mkdir test
```

* 構成ファイルを作成する

```
osx$ vagrant init cent/7

A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
```

* 構成ファイルを編集する

```
osx$ vi Vagrantfile
...
config.vm.network "public_network"  ←コメントを外す

↓ 以下の記述をend手前の最下行に追記する(スペックに合わせて適宜設定)
  config.vm.provider "virtualbox" do |vb|
    # Use VBoxManage to customize the VM.
    vb.customize [
      "modifyvm", :id,
      "--cpus", "2",
      "--memory", "3072",
      "--paravirtprovider", "kvm",
    ]
  end
  
end  ←最下行
```

## VagrantでCentOS 7のデプロイ

* `vagrant up`の実行

```
osx$ vagrant up
```

* 後で使うのでSSH接続可能なユーザーを作っておきます。ユーザー名、パスワードは適当なものを。

```
vagrant@cent7$ useradd clouduser
vagrant@cent7$ passwd clouduser
```

## OpenStackのデプロイ

あとは[この手順](https://github.com/ytooyama/devstack-memo/blob/master/README.md) の2番以降にしたがって実行するとOpenStack環境が出来上がります。

Mitakaを構築すると次のような出力がされます。これで完成です。

```
========================
DevStack Components Timed
========================

run_process - 45 secs
pip_install - 583 secs
restart_apache_server - 8 secs
wait_for_service - 17 secs
yum_install - 225 secs
git_timed - 357 secs


This is your host IP address: 10.0.2.15
This is your host IPv6 address: 2408:12:14aa:ec00:a00:27ff:fe6b:8
Horizon is now available at http://10.0.2.15/dashboard
Keystone is serving at http://10.0.2.15:5000/
The default users are: admin and demo
The password: admin
```

IPアドレスはeth0の方で構築されます。これだと外からアクセスできないので、先に作ったアカウントでSSHポートフォワード（トンネリング）を使ってセッションを張ります。

192.168.1.173はDevStackを動かした環境のeth1、
10.0.2.15は同eth0のIPアドレスを設定してください。

```
osx$ ssh clouduser@192.168.1.173 -L 50080:10.0.2.15:80
```

これでトンネルが掘れたので、あとはブラウザで`http://localhost:50080/dashboard`にアクセスするだけです。

コマンドで操作したい場合は次のようなリソースファイルを作ってsourceコマンドで読み込んでから実行してください。

・admin-openrc

```
export OS_USERNAME=admin
export OS_TENANT_NAME=admin
export OS_PASSWORD=admin
export OS_AUTH_URL=http://10.0.2.15:5000/v2.0/
export OS_REGION_NAME=RegionOne
export PS1='[\u@\h \W(keystone_admin)]\$ '
```

・コマンドを実行

```
clouduser@cent7$ source admin-openrc
clouduser@cent7(keystone_admin)$ openstack service list
+----------------------------------+-------------+----------------+
| ID                               | Name        | Type           |
+----------------------------------+-------------+----------------+
| 3121e289d0174e72969d4a77b5769626 | cinderv2    | volumev2       |
| 4c9dad46fa794265ae781481f9055e2c | keystone    | identity       |
| 58fc845271e84c07be7925d16aae8e21 | glance      | image          |
| 64030c98fa774493ab84627b4a5abc42 | nova        | compute        |
| 87c26313f26a4e17ab1b13d4e9c56d46 | nova_legacy | compute_legacy |
| bcbb31bae07c4f0587cb4078899ec9e7 | cinder      | volume         |
+----------------------------------+-------------+----------------+
```