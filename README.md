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
$ cp share/virt-qemu-cmd.xsl $HOME/.local/share/
# link:
$ CD=$PWD; cd $HOME/.local/share/ ; ln -s "$CD/share/virt-qemu-cmd.xsl" . ; cd -
```

## basic usage

```
$ virt-qemu-cmd [ --help | --no-validate | --run ] <domain-name> | <libvirt-domain-config-file>
```

## example usages

assuming domain name is: 'dsl-2024-rc7'

with full domain name
```
$ virt-qemu-cmd 'dsl-2024-rc7'
```

with (user session) xml path
```
$ virt-qemu-cmd "$HOME/.config/libvirt/qemu/dsl-2024-rc7.xml"
```

with partial domain name (first matching)
```
$ virt-qemu-cmd 'dsl-'
```

piping xml file to command
```
$ cat "$HOME/.config/libvirt/qemu/dsl-2024-rc7.xml" | virt-qemu-cmd
```

using virsh dumpxml command and the domain name to pipe into command:
```
$ virsh dumpxml 'dsl-2024-rc7' | virt-qemu-cmd
```

do not validate domain xml config file before parsing
```
$ virt-qemu-cmd --no-validate 'dsl-2024-rc7'
```

run qemu command instead of just dumping it
```
$ virt-qemu-cmd --run 'dsl-2024-rc7'
```

create command from system session / connection
```
$ sudo virsh dumpxml 'dsl-2024-rc7' | virt-qemu-cmd -
```

running from system session / connection likely failes due to unsufficent rights
```
$ sudo virsh dumpxml 'dsl-2024-rc7' | virt-qemu-cmd --run
```

