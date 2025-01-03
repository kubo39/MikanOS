# MikanOS porting D

ゼロからのOS自作入門 https://zero.osdev.jp/

## セットアップ

### D言語コンパイラ

```console
curl -fsS https://dlang.org/install.sh | bash -s ldc
source ~/dlang/ldc-1.40.0/activate # When installed ldc v1.40.0
```

### EDK2 OVMF

```console
apt install -y ovmf
mkdir ovmf
cp /usr/share/OVMF/OVMF_CODE.fd ovmf/
cp /usr/share/OVMF/OVMF_VARS.fd ovmf/
```
