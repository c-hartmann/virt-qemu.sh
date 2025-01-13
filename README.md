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

## basic usage

```
$ virt-qemu <domain-name> | <libvirt-xml-config-file>
```

## example usages

assuming domain name is: 'dsl-2024-rc7-2024-12-03'

with full domain name
```
$ virt-qemu 'dsl-2024-rc7-2024-12-03'
```

with (user session) xml path
```
$ virt-qemu "$HOME/.config/libvirt/qemu/dsl-2024-rc7-2024-12-03.xml'
```

with partial domain name (first matching)
```
$ virt-qemu 'dsl-2024-rc7-'
```

piping xml file to command
```
$ cat "$HOME/.config/libvirt/qemu/dsl-2024-rc7-2024-12-03.xml' | virt-qemu
```

using virsh sommand and the domain name:
```
$ virsh dumpxml 'dsl-2024-rc7-2024-12-03.xml' | virt-qemu
```
