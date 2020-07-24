## SketchCrapp

Sketch.App Patch Tool, brought to you by [@duraki](https://github.com/duraki) & [@elijahtsai](https://github.com/elijahtsai). This script provides you a quick and dirty way to patch Sketch.app for Unlimited Trial. You can always patch manually using Ghidra by following [this tutorial](https://duraki.github.io/posts/o/20200214-sketch.app-patch-in-ghidra.html). Offsets available [here](https://gist.github.com/Bhavdip/76c581d7ac03bdce6d226a2e8c522df4#gistcomment-3370035).

**Download Sketch.App version of your choice here:** https://www.sketch.com/updates/

## Usage

* Download or clone this repository
  * `cd $HOME && git clone https://github.com/duraki/sketchcrapp`
* Make script executable
  * `cd $HOME/sketchcrapp && chmod +x sketchcrapp.sh`
* Run the script to patch Sketch.app
  * `cd $HOME/sketchcrapp && ./sketchcrapp.sh`

Notice→ The application should automatically detect your Sketch.App version. If not, you can pass `-a` argument for your Sketch.app Application Bundle.

```bash
crackb0x:SketchCrapp duraki$ ./sketchcrapp.sh -h
           __       __      __
      ___ / /_____ / /_____/ /  ___________ ____  ___
    ( _-</  '_/ -_) __/ __/ _ \/ __/ __/ _ `/ _ \/ _ \
    /___/_/\_\\__/\__/\__/_//_/\__/_/  \_,_/ .__/ .__/
                                          /_/  /_/
         Sketch.App Patch Tool (https://github.com/duraki/SketchCrapp)
         by @elijahtsai & @duraki

Usage:
./sketchcrapp [-h] [-a] <applicationPath>
Supported versions: v63.1, v64.0, v65.1, v66.1, v67.1, [soon: v67.2]
```

## Issues

If you have troubles using the script, please contact the team via GitHub Issues.

---

**Build with ❤️ by [@elijahtsai](https://twitter.com/elijahtsai_) & [@duraki](https://twitter.com/0xduraki)**

> [Original idea and thread](https://gist.github.com/Bhavdip/76c581d7ac03bdce6d226a2e8c522df4)
