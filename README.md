# virt-qemu

a little bash script to create a simple basic qemu command line of a libvirt xml configuration

## install

from inside this repository:

```
# copy the script into some directory contained in your PATH ($HOME/.local/bin/ here)
$ cp virt-qemu.sh $HOME/.local/bin/virt-qemu
$ chmod +x $HOME/.local/bin/virt-qemu
$ cp config/virt-qemu.xsl $HOME/.config/
```

## usage

```
$ virt-qemu <domain-name | libvirt-xml-config-file> 
```
