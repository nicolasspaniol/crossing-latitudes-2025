mv assets/* .
mv animations/* .
mv json/json.lua .
rm -fr inspect
sed -i 's/require "inspect\/inspect"/nil/g' *.lua
sed -i 's/json\/json/json/g' *.lua
