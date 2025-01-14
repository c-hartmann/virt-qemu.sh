# virt-qemu-cmd

a little bash script to create a simple basic qemu command line of a libvirt xml configuration

## install

from inside this repository:

```
# copy the script into some directory contained in your PATH ($HOME/.local/bin/ here)
$ cp virt-qemu-cmd.sh $HOME/.local/bin/virt-qemu-cmd
# make it executable
$ chmod +x $HOME/.local/bin/virt-qemu
# either copy or link the stylesheet..
# copy:
$ cp config/virt-qemu-cmd.xsl $HOME/.config/
# link:
$ WD=$PWD; cd config/virt-qemu-cmd.xsl $HOME/.config/; ln -s "$WD/config/virt-qemu-cmd.xsl" .; cd -
```

## basic usage

```
$ virt-qemu-cmd <domain-name> | <libvirt-xml-config-file>
```

## example usages

assuming domain name is: 'dsl-2024-rc7-2024-12-03'

with full domain name
```
$ virt-qemu-cmd 'dsl-2024-rc7-2024-12-03'
```

with (user session) xml path
```
$ virt-qemu-cmd "$HOME/.config/libvirt/qemu/dsl-2024-rc7-2024-12-03.xml"
```

with partial domain name (first matching)
```
$ virt-qemu-cmd 'dsl-2024-rc7-'
```

piping xml file to command
```
$ cat "$HOME/.config/libvirt/qemu/dsl-2024-rc7-2024-12-03.xml" | virt-qemu-cmd
```

using virsh dumpxml command and the domain name to pipe into command:
```
$ virsh dumpxml 'dsl-2024-rc7-2024-12-03' | virt-qemu-cmd
```
