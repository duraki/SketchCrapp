#!/bin/zsh

# Version 63.1
# Address parameter
declare -a address_param_631
address_param_631+="0x4a2a50"
address_param_631+="0x4a1724"
address_param_631+="0x4a1738"
address_param_631+="0x4a173e"
address_param_631+="0x4a1879"
address_param_631+="0x4a1896"
# Value parameter
declare -a value_param_631
value_param_631+=""
value_param_631+=""
value_param_631+=""
value_param_631+=""
# Version 64
# Address parameter
declare -a address_param_640
address_param_640+="0x4cde70"
address_param_640+="0x4ccb44"
address_param_640+="0x4ccb58"
address_param_640+="0x4ccb5e"
address_param_640+="0x4ccc99"
address_param_640+="0x4cccb6"
# Value parameter
declare -a value_param_640
value_param_640+=""
value_param_640+=""
value_param_640+=""
value_param_640+=""
# Version 65.1
# Address parameter
declare -a address_param_651
address_param_651+="0x4db500"
address_param_651+="0x4da1d4"
address_param_651+="0x4da1e8"
address_param_651+="0x4da1ee"
address_param_651+="0x4da329"
address_param_651+="0x4da346"
# Value parameter
declare -a value_param_651
value_param_651+=""
value_param_651+=""
value_param_651+=""
value_param_651+=""
# Version 661
# Address parameter
declare -a address_param_661
address_param_661+="0x4f3750"
address_param_661+="0x4f2424"
address_param_661+="0x4f2438"
address_param_661+="0x4f243e"
address_param_661+="0x4f2579"
address_param_661+="0x4f2596"
# Value parameter
declare -a value_param_661
value_param_661+=""
value_param_661+=""
value_param_661+=""
value_param_661+=""
# Version 671
# Address parameter
declare -a address_param_671
address_param_671+="0x50a6d0"
address_param_671+="0x509394"
address_param_671+="0x5093a8"
address_param_671+="0x5093ae"
address_param_671+="0x5094e9"
address_param_671+="0x509506"
# Value parameter
declare -a value_param_671
value_param_671+=""
value_param_671+=""
value_param_671+=""
value_param_671+=""
# Version 672
# Address parameter
declare -a address_param_672
address_param_672+=""
address_param_672+=""
address_param_672+=""
address_param_672+=""
address_param_672+=""
address_param_672+=""
# Value parameter
declare -a value_param_672
value_param_672+=""
value_param_672+=""
value_param_672+=""
value_param_672+=""
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
# Help messages block
usage() {
  $(clear)
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
  echo "Usage:"
  echo "./sketchcrapp [-h] [-v] <version>"
  exit 0;
}

# Clean up all certificate related files.
clean() {
  if [ -f pk.pem ]; then
    rm -f pk.pem
  fi
  if [ -f crt.pem ]; then
    rm -f crt.pem
  fi
  if [ -f pkcs.p12 ]; then 
    rm -f pkcs.p12
  fi
}

# Generate self-signed certificate for codesign. Required for pass-tru code-signature
# detection by Sketch. Built-in via MacOS openssl library.
genSelfSignCert() {
  openssl req -new -newkey ec:<(openssl ecparam -name secp521r1) \
   -config <(echo "$CONFIG") \
   -extensions self -days 3650 -nodes -x509 \
   -subj "/CN=codesign"\
   -keyform pem -keyout pk.pem \
   -outform pem -out crt.pem
  openssl pkcs12 -export -out pkcs.p12 -in crt.pem -inkey pk.pem \
  -name "codesign" -nodes -passout pass:1234
}

# Import code-signature certificate to keychain. Must be included and trusted by 
# the OS internals.
importSelfSignCert() {
  sudo security unlock-keychain /Library/Keychains/System.keychain
  sudo security import pkcs.p12 -k /Library/Keychains/System.keychain -f pkcs12 -P 1234
  sudo security lock-keychain /Library/Keychains/System.keychain
}

# Equivalent to code-signature application in Sketch. Sign Sketch with generated
# certificate.
signApplication() {
  # Way to find the application need to discuss.
  # todo: Sketch.app can be found in ~/Applications/Sketch.app or /Applications/Sketch.app
  codesign --deep --force -s "codesign" Sketch.app 
}

# All the code and logic flow to patch the Sketch.app binary, do a code-signature 
# and link-resolve the patched Sketch.app
# todo: *
path() {
  echo "[+] Selected Sketch.app version is $version ... SketchCrapp starting ... OK"
  echo "[+] Selected Sketch.app path is </Applications> (auto-detected) ... OK"
  echo "[+] Detecting current binary hash (MD5) ... OK"
  echo "[+] Patching offset for $version ..."
  # todo: offset_patch ($offset, $instruction)
  
  echo "[+] Generating self-signed certificate ..."
  # genSelfCert()
  # importSelfSignCert()
  # signApplication()
  # cleanup()
  
  echo "[+] SketchCrapp process completed. Sketch.app has been patched :)"
  # todo: replace <hash> with output of md5sum
  echo "[+] Binary Hash (before): <hash> [MD5]"
  echo "[+] Binary Hash  (after): <hash> [MD5]"

  echo ""
  echo "SketchCrapp (A Sketch.app cracking tool)"
  echo "https://github.com/duraki/SketchCrapp"
}

offset_patch() {
  # todo: do binary patching here
  # echo " > now hacking $offset > $offset instruction ... <OK>"
}

# Command Line Interface initialization.
## > Missing command arg: Version
if [ $# -eq 0 ]; then
  echo "SketchCrapp requires Sketch version as an input value."
  echo "Use -h for more information."
  exit 0
fi

## > Missing openssl library
if ! command -v openssl &> /dev/null; then
  echo "OpenSSL is not installed on your system. This should not happen, macOS have openssl built-in."
  echo "[FIX] Try: brew install openssl"
  echo "[FIX] Try: install openssl manually"
fi

## > Option filter (CLI parser)
while getopts "hv:" argv; do
  case "${argv}" in
    h)
      usage
      ;;
    v)
      version="${OPTARG}"
      ;;
    *)
      echo "Use -h for more information."
      exit 0;
      ;;
  esac
done

## > Version Selector
case "$version" in
  "63.1")
    echo "select 63.1" # todo: Move this to seperate function
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
    echo "The requested version $version is not supported." 
    echo "Open an issue on GitHub repository: https://github.com/duraki/SketchCrapp"
esac