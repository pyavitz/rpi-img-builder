### Enable
```sh
nano userdata.txt
uscripts=0	# 1 to enable
``` 

### How it works
* run_function1
```sh
If found by stage1, it will run the function. This can be used to make edits to the
p2 directory before chroot. You could in theory re-write or replace stage2.
```

* run_function2
```sh
This function is run inside the chroot. Use your imagination.
```

An example can be found [here](https://github.com/pyavitz/debian-image-builder/blob/feature/files/userscripts/README.md).
