#!/bin/bash
# Binary pattern
# eb ?? 41 b4 ?? 4c 89
# 85 db 0f 85 ?? ?? 00 00 49 89 c7
# 84 db ?? 1b 4c 89

# Support version list.
declare -a version_list

# RUP Review every time when new verison update part.
# Address parameter array and other parameters for each version.
# Version 63.1 
declare -a address_param_631
version_list+=("63.1")
address_param_631+=("0x4a2a4f")
address_param_631+=("0x4a2a52")
address_param_631+=("0x4a173a")
address_param_631+=("0x4a1879")
exe_hash_631="db9b88f3aa6abc484be104660fa911275d9f2515"
# Version 64
declare -a address_param_640
version_list+=("64")
address_param_640+=("0x4cde6e")
address_param_640+=("0x4cde72")
address_param_640+=("0x4ccb5a")
address_param_640+=("0x4ccc99")
exe_hash_640="a4d16224ebb8caf84c94a6863db183fd306002da"
# Version 65.1
declare -a address_param_651
version_list+=("65.1")
address_param_651+=("0x4db4ff")
address_param_651+=("0x4db502")
address_param_651+=("0x4da1ea")
address_param_651+=("0x4da329")
exe_hash_651="0e7cad9b81284d127d652b3a8c962315770cd905"
# Version 66.1
declare -a address_param_661
version_list+=("66.1")
address_param_661+=("0x4f374f")
address_param_661+=("0x4f3752")
address_param_661+=("0x4f243a")
address_param_661+=("0x4f2579")
exe_hash_661="97d6273be93546a9b3caa7c8e1f97fe2246e673b"
# Version 67 & 67.1
declare -a address_param_670
version_list+=("67")
address_param_670+=("0x50a6cf")
address_param_670+=("0x50a6d2")
address_param_670+=("0x5093aa")
address_param_670+=("0x5094e9")
exe_hash_670="b9866183ded9573aea6be0a004f31c8941059f3f"
version_list+=("67.1")
exe_hash_671="708e9203a8628c5cee767eb75546c6145b69df57"
# Version 67.2
declare -a address_param_672
version_list+=("67.2")
address_param_672+=("0x50a78f")
address_param_672+=("0x50a792")
address_param_672+=("0x50946a")
address_param_672+=("0x5095a9")
exe_hash_672="9762906ced4d5589e27b297012ce862665e65a29"
# Version 68
declare -a address_param_680
version_list+=("68")
address_param_680+=("0x54d2af")
address_param_680+=("0x54d2b2")
address_param_680+=("0x54bf8a")
address_param_680+=("0x54c0c9")
exe_hash_680="ad9ccdce3ac270b2441f0efb8f3233935fb1900a"
# Version 68.1 & 68.2
declare -a address_param_681
version_list+=("68.1")
address_param_681+=("0x54d34f")
address_param_681+=("0x54d352")
address_param_681+=("0x54c02a")
address_param_681+=("0x54c169")
exe_hash_681="bc22987f7b3a7580aba1ac260c59d66d0a3622e7"
version_list+=("68.2")
exe_hash_682="651f3263305e004133253c2706fcdf5b16e20558"
# Version 69
declare -a address_param_690
version_list+=("69")
address_param_690+=("0x5cf76f")
address_param_690+=("0x5cf772")
address_param_690+=("0x5ce44a")
address_param_690+=("0x5ce589")
exe_hash_690="2d4027890e2b72175c4a562f59c5d1adb2655b8c"

# Value parameter array.
declare -a value_param
value_param+=("\00")
value_param+=("\00")
value_param+=("\00\00")
value_param+=("\165")

# OpenSSL configuration.
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
         by @duraki & @elijahtsai

EOF
}

# RUP Review every time when new verison update part.
# Help messages block.
usage() {
  echo "Usage:"
  echo "./sketchcrapp [-h] [-a] <applicationPath> [-m]"
  echo "Supported versions: v63.1, v64.0, v65.1, v66.1, v67, v67.1, v67.2, \
v68, v68.1, v68.2, v69"
  exit 0;
}

# Clean up all related files.
clean() {
  echo -n "[+] Cleaning up file(s) ... "
  if [ -f pk.pem ]; then
    rm -f pk.pem
  fi
  if [ -f crt.pem ]; then
    rm -f crt.pem
  fi
  if [ -f pkcs.p12 ]; then
    rm -f pkcs.p12
  fi
  if [ -f "/tmp/latest.zip" ]; then
    rm -f "/tmp/latest.zip"
    if ! [ "$?" -eq "0" ]; then
      echo "Error"
      echo "[-] Fail to remove zip file of latest application. remove by yourself."
      exit 1
    fi
  fi
  if [ -f "/tmp/Sketch.app" ]; then
    rm -f "/tmp/Sketch.app"
    if ! [ "$?" -eq "0" ]; then
      echo "Error"
      echo "[-] Fail to remove application bundle. remove by yourself."
      exit 1
    fi
  fi
  echo "Cleaned"
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

# Import code-signature certificate to keychain. Must be included and trusted by the OS internals.
importSelfSignCert() {
  # Get the path of user default keychain.
  userKeyChain="$(security default-keychain -d user | sed -e 's/^[ ]*//g' -e 's/\"//g')"
  
  if ! [ -f "$userKeyChain" ]; then
    echo "[-] User default Keychain does not exist: $userKeyChain"
    exit 1
  fi
  echo "[+] Importing private key and self-signed certificate" 
  security import pkcs.p12 -k "$userKeyChain" -f pkcs12 -P 1234
}

# Equivalent to code-signature application in Sketch. Sign Sketch with generated certificate.
# - Parameters:
#     - First: The application bundle path.
signApplication() {

  appPath="$1"
  
  echo "[+] Signing the patched *.app bundle. This may require sudo."
  echo "[+] If asked, enter your login password. Choose \"Always Allow\" to not be asked again."
  codesign --deep --force -s "sketchcrapp" "$appPath"
}

#Get binary hash from CFBundleShortVersionString
# - Parameters:
#     - First: The application bundle CFBundleShortVersionString.
getHashFromVersionString() {
  
  local bundleVersionString="$1"

  # RUP Review every time when new verison update part.
  case "$bundleVersionString" in
    "63.1")
      echo "$exe_hash_631"
      ;;
    "64")
      echo "$exe_hash_640"
      ;;
    "65.1")
      echo "$exe_hash_651"
      ;;
    "66.1")
      echo "$exe_hash_661"
      ;;
    "67")
      echo "$exe_hash_670"
      ;;
    "67.1")
      echo "$exe_hash_671"
      ;;
    "67.2")
      echo "$exe_hash_672"
      ;;
    "68")
      echo "$exe_hash_680"
      ;;
    "68.1")
      echo "$exe_hash_681"
      ;;
    "68.2")
      echo "$exe_hash_682"
      ;;
    "69")
      echo "$exe_hash_682"
      ;;
    *)
      echo "Input version string invaild, cannot lookup correct hash value."
  esac
}

# Verify the application by using hash value.
# - Parameters:
#     - First: The application bundle path.
analysisApplication() {

  echo "[+] Analysing application bundle ... Starting"

  local appPath="$1"

  echo -n "[+] Finding executable file ... "

  # Get the path of application executable.
  local execPath="$appPath/Contents/MacOS/Sketch"

  if ! [ -f "$execPath" ]; then
    echo "[-] Executable file does not exists under the given application folder."
    echo "[ERR] Couldn't find executable file at $execPath"
    echo "[INFO] Please make sure you pass clean app to script."
    exit 1
  fi

  echo "OK"

  echo -n "[+] Finding Info.plist ... "

  # Get the path of application info plist.
  local infoPath="$appPath/Contents/Info"

  if ! [ -f "$infoPath.plist" ]; then
    echo "[-] Info file does not exists under the given application folder."
    echo "[ERR] Couldn't find Info.plist at $infoPath.plist"
    echo "[INFO] Please make sure you pass clean app to script."
    exit 1
  fi

  echo "OK"

  echo -n "[+] Checking Info.plist for CFBundleShortVersionString ... "

  # Get the CFBundleShortVersionString from info plist.
  local bundleVersionString="$(defaults read $infoPath CFBundleShortVersionString)"

  if [ -z "$bundleVersionString" ]; then
    echo "[ERR] Couldn't find value of CFBundleShortVersionString"
    echo "[INFO] Please make sure you pass clean app to script."
    exit 1
  fi

  echo "OK"

  # Get the hash of application executable
  local appSHA1="$(shasum -a 1 "$execPath" | cut -f 1 -d ' ')"
  
  local ticket=0

  for versionElement in "${version_list[@]}"
  do
    if [ "$bundleVersionString" = "$versionElement" ]; then
      ticket=1
    fi
  done

  if [ "$ticket" -eq 0 ]; then
    echo "[ERR] Version $bundleVersionString is not supported, please carefully review README file again."
    echo "[INFO] Copy the details below and open a new issue on GitHub repository: \
https://github.com/duraki/SketchCrapp"
    echo "+==================================================================="
    echo "+ Issue details ‹s:sketchcrapp›"
    echo "+ Application Path  : $appPath"
    echo "+ Application Binary: $execPath"
    echo "+ Passed version    : $bundleVersionString"
    echo "+ Binary SHA1       : $appSHA1"
    echo "+ Error             : Version $bundleVersionString is not supported."
    echo "+==================================================================="
    exit 1
  fi

  echo -n "[+] Validating executable file ... "

  local testBundleVersionString=""
  # RUP Review every time when new verison update part.
  case "$appSHA1" in
    "$exe_hash_631")
      testBundleVersionString="63.1"
      ;;
    "$exe_hash_640")
      testBundleVersionString="64"
      ;;
    "$exe_hash_651")
      testBundleVersionString="65.1"
      ;;
    "$exe_hash_661")
      testBundleVersionString="66.1"
      ;;
    "$exe_hash_670")
      testBundleVersionString="67"
      ;;
    "$exe_hash_671")
      testBundleVersionString="67.1"
      ;;
    "$exe_hash_672")
      testBundleVersionString="67.2"
      ;;
    "$exe_hash_680")
      testBundleVersionString="68"
      ;;
    "$exe_hash_681")
      testBundleVersionString="68.1"
      ;;
    "$exe_hash_682")
      testBundleVersionString="68.2"
      ;;
    "$exe_hash_690")
      testBundleVersionString="69"
      ;;
    *)
      testBundleVersionString="binaryerr››"
      echo "Error"
      echo "[ERR] Can't find Sketch with that signature. Hash is invalid."
      echo "[INFO] Carefully review README file again"
      echo "[INFO] If you still have problem copy the details below and open a new issue on GitHub repository: \
https://github.com/duraki/SketchCrapp"
      echo "+==================================================================="
      echo "+ Application Path  : $appPath"
      echo "+ Application Binary: $execPath"
      echo "+ Passed version    : $bundleVersionString"
      echo "+ Correct hash      : $(getHashFromVersionString "$bundleVersionString")"
      echo "+ Binary SHA1       : $appSHA1"
      echo "+ Error             : Can't find Sketch with that signature. Hash is invalid." 
      echo "+==================================================================="
      exit 1
  esac

  if [ "$bundleVersionString" = "$testBundleVersionString" ]; then
    echo "OK"
    engin "$bundleVersionString" "$appPath" "$execPath"
  else 
    echo "Error"
    echo "[FATAL] Executable SHA1 hash returned version value does not equal to the CFBundleShortVersionString"
    echo "[INFO] Carefully review README file again, if you still have problem"
    echo "[INFO] open a new issue on GitHub repository: https://github.com/duraki/SketchCrapp"
    exit 1
  fi
}

# Patch process.
# - Parameters:
#     - First: An array of address of specific version.
#     - Second: A path of application executable to patch.
patch() {

  echo "Starting"

  local addressArray=(${1})
  
  local execPath=${2}
  
  for i in {0..3}; do
    echo "[+] Patching address at offset: ${addressArray[$i]} with value: ${value_param[$i]}"
    printf "${value_param[$i]}" | dd seek="$((${addressArray[$i]}))" conv=notrunc bs=1 of="$execPath"
    if ! [ "$?" -eq "0" ]; then 
      echo "[FATAL] Patch process result fail. That's all we know."
      echo "[INFO] Open a new issue and tell us about this on GitHub repository: \
https://github.com/duraki/SketchCrapp"
      exit 1
    fi
  done
}

# All the code and logic flow to patch the Sketch.app binary, do a code-signature
# and link-resolve the patched Sketch.app.
# - Parameters:
#     - First: A version of current application bundle.
#     - Second: An array of address of specific version.
#     - Third: A path of application executable to patch.
engin() {

  local appVersion="$1"
  
  local appPath="$2"
  
  local execPath="$3"
  
  # Version Selector.
  echo "[+] Selected Sketch.app version is $appVersion ... SketchCrapp starting ... OK"
  echo -n "[+] Patching offsets for $appVersion ... "
  # RUP Review every time when new verison update part.
  case "$appVersion" in
    "63.1")
      patch "${address_param_631[*]}" "$execPath"
      ;;
    "64")
      patch "${address_param_640[*]}" "$execPath"
      ;;
    "65.1")
      patch "${address_param_651[*]}" "$execPath"
      ;;
    "66.1")
      patch "${address_param_661[*]}" "$execPath"
      ;;
    "67"|"67.1")
      patch "${address_param_670[*]}" "$execPath"
      ;;
    "67.2")
      patch "${address_param_672[*]}" "$execPath"
      ;;
    "68")
      patch "${address_param_680[*]}" "$execPath"
      ;;
    "68.1")
      patch "${address_param_681[*]}" "$execPath"
      ;;
    "68.2")
      patch "${address_param_681[*]}" "$execPath"
      ;;
    "69")
      patch "${address_param_690[*]}" "$execPath"
      ;;
    *)
      echo "Error"
      echo "Something went wrong, this line should never execute."
      echo "[INFO] Copy the details below and open a new issue on GitHub repository: \
https://github.com/duraki/SketchCrapp"
      echo "+==================================================================="
      echo "+ Issue details ‹s:sketchcrapp›"
      echo "+ Application Path  : $appPath"
      echo "+ Application Binary: $execPath"
      echo "+ Passed version    : $bundleVersionString"
      echo "+ Binary SHA1       : $appSHA1"
      echo "+ Error             : patcherr››"
      echo "+==================================================================="
      exit 1
  esac
  # CodeSigning area.
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

# An auto function to patch latest app.
magicFunction() {
  
  # RUP Review every time when new verison update part.
  local latestBundleURLPath="https://download.sketchapp.com/sketch-69-107357.zip"

  # Check if missing cURL
  if ! command -v curl &> /dev/null; then
    echo "cURL is not installed on your system."
    echo "This should not happen, macOS have cURL built-in."
    echo "[FIX] Try: brew install curl"
    echo "[FIX] Try: port install curl"
    echo "[FIX] Try: install cURL manually"
    exit 1;
  fi

  # Check if missing UNZIP
  if ! command -v unzip &> /dev/null; then
    echo "UNZIP is not installed on your system."
    echo "This should not happen, macOS have UNZIP built-in."
    echo "[FIX] Try: brew install unzip"
    echo "[FIX] Try: port install unzip"
    echo "[FIX] Try: install UNZIP manually"
    exit 1;
  fi

  echo -n "[+] Checking directory tmp existence ... "
  
  if ! [ -d /tmp ]; then
    echo "Error"
    echo "Directory tmp does not exist."
    exit 1
  fi

  echo "OK"


  curl "$latestBundleURLPath" --output "/tmp/latest.zip"

  if ! [ "$?" -eq "0" ]; then
    echo "[-] Fail to download latest application."
    echo "[-] Are you up to the Internet??"
    clean
    exit 1
  fi 

  echo -n "Checking if Sketch.app exist in /tmp ... "
  if [ -d "/tmp/Sketch.app" ]; then
    echo "Exist. Removing."
    rm -rf "/tmp/Sketch.app"
    if ! [ "$?" -eq "0" ]; then
      echo "[-] Fail to remove exist Sketch.app in /tmp directory."
      clean
      exit 1
    fi
  else 
    echo "Not exist. Continuous."
  fi 

  unzip -q "/tmp/latest.zip" -d "/tmp"

  if ! [ "$?" -eq "0" ]; then
    echo "[-] Fail to unzip zip file of latest application."
    clean
    exit 1
  fi 

  echo -n "[+] Checking if Sketch.app exist in /Applications ... "
  if [ -d "/Applications/Sketch.app" ]; then
    echo "Exist. Removing."
    rm -rf "/Applications/Sketch.app"
    if ! [ "$?" -eq "0" ]; then
      echo "Fail to remove exist Sketch.app in /Applications directory."
      clean
      exit 1
    fi
  else 
    echo "Not exist. Continuous."
  fi 

  echo -n "[+] Moving Sketch.app to /Applications directory ... "

  mv "/tmp/Sketch.app" "/Applications" 

  if ! [ "$?" -eq "0" ]; then
    echo "Fail"
    echo "[-] Fail to moving /tmp/Sketch.app to /Applications directory."
    clean
    exit 1
  fi

  echo "Successfully."

  analysisApplication "/Applications/Sketch.app"
}

# Command Line Interface initialization.
# Script startup point. How about we start from banner shell we?
banner

# Check if missing OpenSSL library
if ! command -v openssl &> /dev/null; then
  echo "OpenSSL is not installed on your system."
  echo "This should not happen, macOS have OpenSSL built-in."
  echo "[FIX] Try: brew install openssl"
  echo "[FIX] Try: port install openssl"
  echo "[FIX] Try: install openssl manually"
  exit 1;
fi

# If no option was given by default search /Application or ~/Application .
if [ $# -eq 0 ]; then
  echo "SketchCrapp is finding application bundle path ..."
  if [ -d "/Applications/Sketch.app" ]; then
    # Sketch is found in /Application .
    echo "[+] Selected Sketch.app path is </Applications> (auto-detected) ... OK"
    analysisApplication "/Applications/Sketch.app"
  elif [ -d "$HOME/Applications/Sketch.app" ]; then
    # Sketch is found in ~/Application .
    echo "[+] Selected Sketch.app path is <$HOME/Applications> (auto-detected) ... OK"
    analysisApplication "$HOME/Applications/Sketch.app"
  else
    echo "Application not found in /Applications or ~/Applications"
    echo "Try: ./sketchcrapp -a /Custom/Path/For/Applications/Sketch.app"
    exit 1
  fi
  exit 0
fi

# Option filter (Command-Line Interface parser).
while getopts "ha:m" argv; do
  case "${argv}" in
    h)
      usage
      ;;
    a)
      appPath="${OPTARG}"
      if [ -d "$appPath" ]; then
        analysisApplication "$appPath"
      else
        echo "[ERR] Given directory is either invaild or not exist."
        exit 1
      fi
      ;;
    m) 
      magicFunction
      ;;
    *)
      echo "Use -h for more information."
      exit 0
      ;;
  esac
done

exit 0