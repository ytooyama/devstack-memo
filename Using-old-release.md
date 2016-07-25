# CentOS 7で古いOpenStackリリースを使う場合
(2016/7/25時点)

## Mitaka

`devstack/local.conf`に、以下のようにバージョンを指定

```
...
KEYSTONE_BRANCH=stable/mitaka
NOVA_BRANCH=stable/mitaka
GLANCE_BRANCH=stable/mitaka
CINDER_BRANCH=stable/mitaka
HORIZON_BRANCH=stable/mitaka
NEUTRON_BRANCH=stable/mitaka
SWIFT_BRANCH=stable/mitaka
```

`https://rdoproject.org/repos/rdo-release.rpm`は最新安定版のリポジトリーパッケージを提供するので変更は必要なし。


## liberty

`devstack/local.conf`に、以下のようにバージョンを指定

```
...
KEYSTONE_BRANCH=stable/liberty
NOVA_BRANCH=stable/liberty
GLANCE_BRANCH=stable/liberty
CINDER_BRANCH=stable/liberty
HORIZON_BRANCH=stable/liberty
NEUTRON_BRANCH=stable/liberty
SWIFT_BRANCH=stable/liberty
```

`devstack/stack.sh`の以下の部分を書き換え

```
...
#sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm
↓(書き換え)
sudo yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-5.noarch.rpm
```

## Kilo(EOL)

調査中。