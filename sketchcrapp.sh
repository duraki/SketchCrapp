#!/bin/bash
# Version 63.1
# Address parameter
declare -a address_param_631
address_param_631+=("0x4a2a4f")
address_param_631+=("0x4a2a52")
address_param_631+=("0x4a173a")
address_param_631+=("0x4a1879")
# Value parameter
declare -a value_param_631
value_param_631+=("\00")
value_param_631+=("\00")
value_param_631+=("\00\00")
value_param_631+=("\165")
# Version 64
# Address parameter
declare -a address_param_640
address_param_640+=("0x4cde6e")
address_param_640+=("0x4cde72")
address_param_640+=("0x4ccb5a")
address_param_640+=("0x4ccc99")
# Value parameter
declare -a value_param_640
value_param_640+=("\00")
value_param_640+=("\00")
value_param_640+=("\00\00")
value_param_631+=("\165")
# Version 65.1
# Address parameter
declare -a address_param_651
address_param_651+=("0x4db4ff")
address_param_651+=("0x4db502")
address_param_651+=("0x4da1ea")
address_param_651+=("0x4da329")
address_param_651+=("")
address_param_651+=("")
# Value parameter
declare -a value_param_651
value_param_651+=("\00")
value_param_651+=("\00")
value_param_651+=("\00\00")
value_param_651+=("\165")
# Version 661
# Address parameter
declare -a address_param_661
address_param_661+=("0x4f374f")
address_param_661+=("0x4f3752")
address_param_661+=("0x4f243a")
address_param_661+=("0x4f2579")
# Value parameter
declare -a value_param_661
value_param_661+=("\00")
value_param_661+=("\00")
value_param_661+=("\00\00")
value_param_661+=("\165")
# Version 671
# Address parameter
declare -a address_param_671
address_param_671+=("0x50a6cf")
address_param_671+=("0x50a6d2")
address_param_671+=("0x5093aa")
address_param_671+=("0x5094e9")
# Value parameter
declare -a value_param_671
value_param_671+=("\00")
value_param_671+=("\00")
value_param_671+=("\00\00")
value_param_671+=("\165")
# Version 672
# Address parameter
declare -a address_param_672
address_param_672+=("0x50a78f")
address_param_672+=("0x50a792")
address_param_672+=("0x50946a")
address_param_672+=("0x5095a9")
# Value parameter
declare -a value_param_672
value_param_672+=("\00")
value_param_672+=("\00")
value_param_672+=("\00\00")
value_param_672+=("\165")
# OpenSSL configuration
CONFIG="
[ req ]
distinguished_name=name
[ name ]
[ self ]
keyUsage = critical,digitalSignature
extendedKeyUsage = codeSigning
subjectKeyIdentifier = hash
basicConstraints = critical,CA:false
"
# Banner block
banner() {
  cat <<"EOF"
           __       __      __
      ___ / /_____ / /_____/ /  ___________ ____  ___
    ( _-</  '_/ -_) __/ __/ _ \/ __/ __/ _ `/ _ \/ _ \
    /___/_/\_\\__/\__/\__/_//_/\__/_/  \_,_/ .__/ .__/
                                          /_/  /_/
         Sketch.App Patch Tool (https://github.com/duraki/SketchCrapp)
         by @elijahtsai & @duraki


EOF
}
# Help messages block
usage() {
  echo "Usage:"
  echo "./sketchcrapp [-h] [-a] <applicationPath>"
  echo "Supported versions: v63.1, v64.0, v65.1, v66.1, v67.1, v67.2"
  exit 0;
}

# Clean up all certificate related files.
clean() {
  echo "[+] Cleaning up certificate file(s)"
  if [ -f pk.pem ]; then
    rm -f pk.pem
  fi
  if [ -f crt.pem ]; then
    rm -f crt.pem
  fi
  if [ -f pkcs.p12 ]; then
    rm -f pkcs.p12
  fi
  echo "[+] Cleaned"
}

# Diagnosis massage 
err() {
  error="$1"
  echo "[+] Copy the details below and open a new issue on GitHub repository: https://github.com/duraki/SketchCrapp"
  echo "+==================================================================="
  echo "+ Issue details ‹s:sketchcrapp›"
  echo "+ Application Path  : $appPath"
  echo "+ Application Binary: $execPath"
  echo "+ Passed version    : ‹nil›"
  echo "+ Binary SHA1       : $appSHA1"
  echo "+ Error             : $error"
  echo "+==================================================================="
}

# Generate self-signed certificate for codesign. Required for pass-tru code-signature
# detection by Sketch. Built-in via MacOS openssl library.
genSelfSignCert() {
  echo "[+] Generating self-signed certificate ..."
  openssl req -new -newkey ec:<(openssl ecparam -name secp521r1) \
   -config <(echo "$CONFIG") \
   -extensions self -days 3650 -nodes -x509 \
   -subj "/CN=sketchcrapp"\
   -keyform pem -keyout pk.pem \
   -outform pem -out crt.pem
  echo "[+] Creating pkcs package..." 
  openssl pkcs12 -export -out pkcs.p12 -in crt.pem -inkey pk.pem \
  -name "sketchcrapp" -nodes -passout pass:1234
}

# Import code-signature certificate to keychain. Must be included and trusted by
# the OS internals.
importSelfSignCert() {
  userKeyChain="$(security default-keychain -d user | sed -e 's/^[ ]*//g' -e 's/\"//g')"
  if ! [ -f "$userKeyChain" ]; then
    echo "[-] User default Keychain does not exist: $userKeyChain"
    exit 1
  fi
  echo "[+] Importing private key and self-signed certificate" 
  security import pkcs.p12 -k "$userKeyChain" -f pkcs12 -P 1234
}

# Equivalent to code-signature application in Sketch. Sign Sketch with generated
# certificate.
signApplication() {
  appPath="$1"
  echo "[+] Signing the patched *.app bundle. This may require sudo."
  echo "[+] Enter your Login password if a dialogue pops-up, and remember to choose Always allow."
  codesign --deep --force -s "sketchcrapp" "$appPath"
}
# Verify the application by using hash value
verifyApplication() {
  appPath="$1"
  execPath="$appPath/Contents/MacOS/Sketch"
  if ! [ -d "$appPath" ]; then
    echo "[-] The path of application $appPath is incorrect."
    echo "[ERR] Couldn't find: $appPath"
    exit 1
  fi
  if ! [ -f "$execPath" ]; then
    echo "[-] Executable file does not exists under the given application folder."
    echo "[ERR] Couldn't find: $execPath"
    exit 1
  fi
  appSHA1=$(shasum -a 1 "$execPath" | cut -f 1 -d ' ')
  case "$appSHA1" in
    "db9b88f3aa6abc484be104660fa911275d9f2515") # 63.1
      engin "63.1" "$appPath" "$execPath"
      ;;
    "a4d16224ebb8caf84c94a6863db183fd306002da") # 64
      engin "64" "$appPath" "$execPath"
      ;;
    "0e7cad9b81284d127d652b3a8c962315770cd905") # 65.1
      engin "65.1" "$appPath" "$execPath"
      ;;
    "97d6273be93546a9b3caa7c8e1f97fe2246e673b") # 66.1
      engin "66.1" "$appPath" "$execPath"
      ;;
    "708e9203a8628c5cee767eb75546c6145b69df57") # 67.1
      engin "67.1" "$appPath" "$execPath"
      ;;
    "9762906ced4d5589e27b297012ce862665e65a29") # 67.2
      engin "67.2" "$appPath" "$execPath"
      ;;
    *)
      err "binaryerr››"
  esac
}
# Patch process
patch() {
  local addressArray=(${1})
  local valueArray=(${2})
  local execPath=${3}
  for i in {0..3}; do
    echo "[+] Patching address at offset: ${addressArray[$i]} with value: ${valueArray[$i]}"
    printf "${valueArray[$i]}" | dd seek="$((${addressArray[$i]}))" conv=notrunc bs=1 of="$execPath"
  done
}

# All the code and logic flow to patch the Sketch.app binary, do a code-signature
# and link-resolve the patched Sketch.app
engin() {
  appVersion="$1"
  appPath="$2"
  execPath="$3"
  #Version Selector
  echo "[+] Selected Sketch.app version is $appVersion ... SketchCrapp starting ... OK"
  echo "[+] Patching offsets for $appVersion ..."
  case "$appVersion" in
    "63.1")
      patch "${address_param_631[*]}" "${value_param_631[*]}" "$execPath"
      ;;
    "64")
      patch "${address_param_640[*]}" "${value_param_640[*]}" "$execPath"
      ;;
    "65.1")
      patch "${address_param_651[*]}" "${value_param_651[*]}" "$execPath"
      ;;
    "66.1")
      patch "${address_param_661[*]}" "${value_param_661[*]}" "$execPath"
      ;;
    "67.1")
      patch "${address_param_671[*]}" "${value_param_671[*]}" "$execPath"
      ;;
    "67.2")
      patch "${address_param_672[*]}" "${value_param_672[*]}" "$execPath"
      ;;
    *)
      echo "Something went wrong, this line should never execute."
      err "patcherr››"
  esac
  # CodeSigning area
  # Check if sketchcrapp certificate already exist.
  if ! security find-certificate -c "sketchcrapp" 2>&1 >/dev/null; then
    # Certificate does not exist, generate one.
    genSelfSignCert
    # Import the certificate.
    importSelfSignCert
  else
    echo "[+] SketchCrapp certificate already exists. Skipping certificate creation ... OK"
  fi
  # Sign the application.
  signApplication "$appPath"
  # Call cleaner to do some housekeeping.
  clean
  echo "[+] SketchCrapp process completed. Sketch.app has been patched :)"
  echo "[+] -- Notice: "
  echo "[+] If a dialogue shows up with message: “Sketch 3.app” can’t be opened"
  echo "[+] please right-click the application and select open, or go to Settings -› Security"
  echo "[+] and allow opening Sketch.app application."
  echo ""
  echo "[+] SketchCrapp (A Sketch.app cracking tool)"
  echo "[+] https://github.com/duraki/SketchCrapp [by @duraki & @elijahtsai]"
}

# Command Line Interface initialization.
# Script startup point. How about we start from banner shell we?
banner

## > Check if missing openssl library
if ! command -v openssl &> /dev/null; then
  echo "OpenSSL is not installed on your system."
  echo "This should not happen, macOS have openssl built-in."
  echo "[FIX] Try: brew install openssl"
  echo "[FIX] Try: port install openssl"
  echo "[FIX] Try: install openssl manually"
  exit 1;
fi

# If no option was given by default search /Application or ~/Application
if [ $# -eq 0 ]; then
  echo "SketchCrapp is finding application bundle path ..."
  if [ -d "/Applications/Sketch.app" ]; then
    # /Application
    echo "[+] Selected Sketch.app path is </Applications> (auto-detected) ... OK"
    verifyApplication "/Applications/Sketch.app"
  elif [ -d "$HOME/Applications/Sketch.app" ]; then
    # ~/Application
    echo "[+] Selected Sketch.app path is <$HOME/Applications> (auto-detected) ... OK"
    verifyApplication "$HOME/Applications/Sketch.app"
  else
    echo "Application not found in /Applications or ~/Applications"
    echo "Try: ./sketchcrapp -a /Custom/Path/For/Applications/Sketch.app"
    exit 1
  fi
  exit 0
fi

## > Option filter (CLI parser)
while getopts "ha:" argv; do
  case "${argv}" in
    h)
      usage
      ;;
    a)
      appPath="${OPTARG}"
      if [ -d "$appPath" ]; then
        verifyApplication "$appPath"
      else
        "Given directory is either invaild or not exist."
      fi
      ;;
    *)
      echo "Use -h for more information."
      exit 0;
      ;;
  esac
done
