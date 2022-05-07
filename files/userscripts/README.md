### How it works (files/userscripts/uscripts)
* run_function0
```sh
If found, it runs at the start of stage1.
```

* run_function1
```sh
If found, it runs in the middle of stage1. This can be used to make edits to the
$P_VALUE directory before chroot.
```

* run_function2
```sh
If found, it runs in stage2 during chroot.
```

Examples: can be found [here](https://github.com/pyavitz/debian-image-builder/tree/userscripts).
