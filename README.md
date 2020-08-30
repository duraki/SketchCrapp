<p align="center">
  <img height="200" src="https://i.imgur.com/laXau20.png">
</p>

## SketchCrapp

Sketch.App Patch Tool, brought to you by [@duraki](https://github.com/duraki) & [@elijahtsai](https://github.com/elijahtsai). This script provides you a quick and dirty way to patch Sketch.app for Unlimited Trial. You can always patch manually using Ghidra by following [this tutorial](https://duraki.github.io/posts/o/20200214-sketch.app-patch-in-ghidra.html). Offsets available [here](https://github.com/duraki/SketchCrapp/blob/master/README.md#offset-table).

**Download Sketch.App version of your choice here:** https://www.sketch.com/updates/

## Usage

* Open your MacOS Terminal (`Cmd+Space`, type **Terminal**)
* Type the commands below
* Download or clone this repository
  * `cd $HOME && git clone https://github.com/duraki/sketchcrapp`
* Make script executable
  * `cd $HOME/sketchcrapp && chmod +x sketchcrapp.sh`
* Run the script to patch Sketch.app
  * `cd $HOME/sketchcrapp && ./sketchcrapp.sh`

**Notice**→ The application should automatically detect your Sketch.App version. If not, you can pass `-a` argument for your Sketch.app Application Bundle.

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
Supported versions: v63.1, v64.0, v65.1, v66.1, v67, v67.1, v67.2, v68, v68.1
```

```
crackb0x:SketchCrapp duraki$ ./sketchcrapp.sh
           __       __      __
      ___ / /_____ / /_____/ /  ___________ ____  ___
    ( _-</  '_/ -_) __/ __/ _ \/ __/ __/ _ `/ _ \/ _ \
    /___/_/\_\\__/\__/\__/_//_/\__/_/  \_,_/ .__/ .__/
                                          /_/  /_/
         Sketch.App Patch Tool (https://github.com/duraki/SketchCrapp)
         by @elijahtsai & @duraki

SketchCrapp is finding application bundle path ...
[+] Selected Sketch.app path is </Applications> (auto-detected) ... OK
[+] Selected Sketch.app version is 68.1 ... SketchCrapp starting ... OK
[+] Patching offsets for 68.1 ...
[+] Patching address at offset: 0x54d34f with value: \00
1+0 records in
1+0 records out
1 bytes transferred in 0.000028 secs (35545 bytes/sec)
[+] Patching address at offset: 0x54d352 with value: \00
1+0 records in
1+0 records out
1 bytes transferred in 0.000018 secs (55188 bytes/sec)
[+] Patching address at offset: 0x54c02a with value: \00\00
2+0 records in
2+0 records out
2 bytes transferred in 0.000023 secs (86480 bytes/sec)
[+] Patching address at offset: 0x54c169 with value: \165
1+0 records in
1+0 records out
1 bytes transferred in 0.001926 secs (519 bytes/sec)
security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain.
[+] Generating self-signed certificate ...
Generating a 521 bit EC private key
writing new private key to 'pk.pem'
-----
[+] Creating pkcs package...
[+] Importing private key and self-signed certificate
1 identity imported.
[+] Signing the patched *.app bundle. This may require sudo.
[+] If asked, enter your login password. Choose "Always Allow" to not be asked again.
    @/Applications/Sketch.app: replacing existing signature
[+] Cleaning up certificate file(s)
[+] Cleaned
[+] SketchCrapp process completed. Sketch.app has been patched :)
[+] -- Notice: 
[+] If a dialogue shows up with message: “Sketch 3.app” can’t be opened
[+] please right-click the application and select open, or go to Settings -› Security
[+] and allow opening Sketch.app application.

[+] SketchCrapp (A Sketch.app cracking tool)
[+] https://github.com/duraki/SketchCrapp [by @duraki & @elijahtsai]
```

## Issues

If you have troubles using the script, please contact the team via GitHub Issues.

---

**Build with ❤️ by [@elijahtsai](https://twitter.com/elijahtsai_) & [@duraki](https://twitter.com/0xduraki)**

> [Original idea and thread](https://gist.github.com/Bhavdip/76c581d7ac03bdce6d226a2e8c522df4)

### Offset Table
|63.1|64|65.1|66.1|67 & 67.1|67.2|
|----|----|----|----|----|----|
|0x1004a2a50|0x1004cde70|0x1004db500|0x1004f3750|0x10050a6d0|0x10050a790|
|0x1004a1724|0x1004ccb44|0x1004da1d4|0x1004f2424|0x100509394|0x100509454|
|0x1004a1738|0x1004ccb58|0x1004da1e8|0x1004f2438|0x1005093a8|0x100509468|
|0x1004a173e|0x1004ccb5e|0x1004da1ee|0x1004f243e|0x1005093ae|0x10050946e|
|0x1004a1879|0x1004ccc99|0x1004da329|0x1004f2579|0x1005094e9|0x1005095a9|
|0x1004a1896|0x1004cccb6|0x1004da346|0x1004f2596|0x100509506|0x1005095c6|

|68|68.1|
|----|----|
|0x10054d2b0|0x10054d350|
|0x10054bf74|0x10054c014|
|0x10054bf88|0x10054c028|
|0x10054bf8e|0x10054c02e|
|0x10054c0c9|0x10054c169|
|0x10054c0e6|0x10054c186|