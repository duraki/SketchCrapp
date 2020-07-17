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
address_param_640+=("0x4cde70")
address_param_640+=("0x4ccb44")
address_param_640+=("0x4ccb58")
address_param_640+=("0x4ccb5e")
address_param_640+=("0x4ccc99")
address_param_640+=("0x4cccb6")
# Value parameter
declare -a value_param_640
value_param_640+=("")
value_param_640+=("")
value_param_640+=("")
value_param_640+=("")
# Version 65.1
# Address parameter
declare -a address_param_651
address_param_651+=("0x4db500")
address_param_651+=("0x4da1d4")
address_param_651+=("0x4da1e8")
address_param_651+=("0x4da1ee")
address_param_651+=("0x4da329")
address_param_651+=("0x4da346")
# Value parameter
declare -a value_param_651
value_param_651+=("")
value_param_651+=("")
value_param_651+=("")
value_param_651+=("")
# Version 661
# Address parameter
declare -a address_param_661
address_param_661+=("0x4f3750")
address_param_661+=("0x4f2424")
address_param_661+=("0x4f2438")
address_param_661+=("0x4f243e")
address_param_661+=("0x4f2579")
address_param_661+=("0x4f2596")
# Value parameter
declare -a value_param_661
value_param_661+=("")
value_param_661+=("")
value_param_661+=("")
value_param_661+=("")
# Version 671
# Address parameter
declare -a address_param_671
address_param_671+=("0x50a6d0")
address_param_671+=("0x509394")
address_param_671+=("0x5093a8")
address_param_671+=("0x5093ae")
address_param_671+=("0x5094e9")
address_param_671+=("0x509506")
# Value parameter
declare -a value_param_671
value_param_671+=("")
value_param_671+=("")
value_param_671+=("")
value_param_671+=("")
# Version 672
# Address parameter
declare -a address_param_672
address_param_672+=("")
address_param_672+=("")
address_param_672+=("")
address_param_672+=("")
address_param_672+=("")
address_param_672+=("")
# Value parameter
declare -a value_param_672
value_param_672+=("")
value_param_672+=("")
value_param_672+=("")
value_param_672+=("")
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
  clear
  cat <<EOF

            __           __         .__                                       
      _____|  | __ _____/  |_  ____ |  |__   ________________  ______ ______  
     /  ___|  |/ _/ __ \   ___/ ___\|  |  \_/ ___\_  __ \__  \ \____  \____ \ 
     \___ \|    <\  ___/|  | \  \___|   Y  \  \___|  | \// __ \|  |_> |  |_> >
    /____  |__|_  \___  |__|  \___  |___|  /\___  |__|  (____  |   __/|   __/ 
         \/     \/    \/          \/     \/     \/           \/|__|   |__|    
         Sketch.App Patch Tool (https://github.com/duraki/SketchCrapp)
         by @elijahtsai & @duraki


EOF
}
# Help messages block
usage() {
  banner
  echo "Usage:"
  echo "./sketchcrapp [-h] [-a] <applicationPath>"
  exit 0;
}

# Clean up all certificate related files.
clean() {
  echo "Start cleaning"
  if [ -f pk.pem ]; then
    rm -f pk.pem
  fi
  if [ -f crt.pem ]; then
    rm -f crt.pem
  fi
  if [ -f pkcs.p12 ]; then 
    rm -f pkcs.p12
  fi
  echo "cleaned"
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
  openssl pkcs12 -export -out pkcs.p12 -in crt.pem -inkey pk.pem \
  -name "sketchcrapp" -nodes -passout pass:1234
}

# Import code-signature certificate to keychain. Must be included and trusted by 
# the OS internals.
importSelfSignCert() {
  userKeyChain="$(security default-keychain -d user | sed -e 's/^[ ]*//g' -e 's/\"//g')"
  if ! [ -f "$userKeyChain" ]; then
    echo "User default keychain not exist. $userKeyChain"
    exit 1
  fi
  security import pkcs.p12 -k "$userKeyChain" -f pkcs12 -P 1234
}

# Equivalent to code-signature application in Sketch. Sign Sketch with generated
# certificate.
signApplication() {
  appPath="$1"
  echo "Enter your login password if dialogue pop-up and remember to choose Always allow."
  codesign --deep --force -s "sketchcrapp" "$appPath"
}
# Verify the application by using hash value
verifyApplication() {
  appPath="$1"
  execPath="$appPath/Contents/MacOS/Sketch"
  if ! [ -d "$appPath" ]; then
    echo "The path of application $appPath is incorrect."
    exit 1
  fi
  if ! [ -f "$execPath" ]; then
    echo "Executeable file seem not under the application folder."
    exit 1
  fi
  appSHA1=$(shasum -a 1 "$execPath" | cut -f 1 -d ' ')
  case "$appSHA1" in
    "db9b88f3aa6abc484be104660fa911275d9f2515")
      engin "63.1" "$appPath" "$execPath"
      ;;
    "a4d16224ebb8caf84c94a6863db183fd306002da")
      engin "64" "$appPath" "$execPath"
      ;;
    "0e7cad9b81284d127d652b3a8c962315770cd905")
      engin "65.1" "$appPath" "$execPath"
      ;;
    "97d6273be93546a9b3caa7c8e1f97fe2246e673b")
      engin "66.1" "$appPath" "$execPath"
      ;;
    "708e9203a8628c5cee767eb75546c6145b69df57")
      engin "67.1" "$appPath" "$execPath"
      ;;
    "empty")
      engin "67.2" "$appPath" "$execPath"
      ;;  
    *)
      echo "Unable to determent application version, or application has been modify before."
  esac
}
# Patch process
patch() {
  local addressArray=(${1})
  local valueArray=(${2})
  local execPath=${3}
  for i in {0..3}; do
    echo "Patch on address ${addressArray[$i]} with value ${valueArray[$i]}"
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
  echo "[+] Patching offset for $appVersion ..."
  case "$appVersion" in
    "63.1")
      patch "${address_param_631[*]}" "${value_param_631[*]}" "$execPath"
      ;;
    "64")
      echo "select 64"
      ;;
    "65.1")
      echo "select 65.1"
      ;;
    "66.1")
      echo "select 66.1"
      ;;
    "67.1")
      echo "select 67.1"
      ;;
    "67.2")
      echo "select 67.2 but not support yet."
      ;;  
    *)
      echo "not support."
  esac
  # CodeSigning area
  # check if sketchcrapp certificate already exist.
  if ! security find-certificate -c "sketchcrapp" 2>&1 >/dev/null; then
    # certificate not exist, generate one.
    genSelfSignCert
    # import the certificate.
    importSelfSignCert
  else 
    echo "sketchcrapp certificate already exist. using exist one."
  fi
  # Sign the application.
  signApplication "$appPath"
  # call cleaner to do some housekeeping.
  clean
  echo "[+] SketchCrapp process completed. Sketch.app has been patched :)"
  echo "[+] If dialogue show up said “Sketch 3.app” can’t be opened "
  echo "[+] because Apple cannot check it for malicious software."
  echo "[+] Please right-click the application and select open."
  echo ""
  echo "SketchCrapp (A Sketch.app cracking tool)"
  echo "https://github.com/duraki/SketchCrapp"
}
## > Check if missing openssl library
if ! command -v openssl &> /dev/null; then
  echo "OpenSSL is not installed on your system."
  echo "This should not happen, macOS have openssl built-in."
  echo "[FIX] Try: brew install openssl"
  echo "[FIX] Try: port install openssl"
  echo "[FIX] Try: install openssl manually"
  exit 1;
fi
# Command Line Interface initialization.
# Script startup point. How about start from banner shell we?
banner
# If no option was given by default search /Application or ~/Application
if [ $# -eq 0 ]; then
  echo "Sketchcrapp is finding application location."
  if [ -d "/Applications/Sketch.app" ]; then
    # /Application
    echo "[+] Selected Sketch.app path is </Applications> (auto-detected) ... OK"
    verifyApplication "/Applications/Sketch.app"
  elif [ -d "$HOME/Applications/Sketch.app" ]; then
    # ~/Application
    echo "[+] Selected Sketch.app path is <$HOME/Applications> (auto-detected) ... OK"
    verifyApplication "$HOME/Applications/Sketch.app"
  else 
    echo "Application not found either in /Applications or ~/Applications"
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
        "Given directory either invaild or not exist."
      fi
      ;;
    *)
      echo "Use -h for more information."
      exit 0;
      ;;
  esac
done
