
if [ ! -f "/usr/local/bin/op" ]; then
    ARCHITCTURE="amd64"
    OP_VERSION="v$(curl https://app-updates.agilebits.com/check/1/0/CLI2/en/2.0.0/N -s | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')"
    curl -sSfo op.zip https://cache.agilebits.com/dist/1P/op2/pkg/"$OP_VERSION"/op_linux_"$ARCHITCTURE"_"$OP_VERSION".zip
    sudo unzip -od /usr/local/bin/ op.zip
    rm op.zip
fi
