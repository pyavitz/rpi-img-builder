### How it works (files/userscripts/uscripts)
* run_function0
```sh
Runs at the start of stage1.
```

* run_function1
```sh
Runs in the middle of stage1 and can be used to make edits to the p2 directory before chroot.
```

* run_function2
```sh
Runs in stage2 during chroot.
```
* run_function3
```sh
Runs at the end of stage1 before the loop(s) get unmounted and the image is finalized.
```

Examples: [here](https://github.com/pyavitz/debian-image-builder/tree/userscripts).
