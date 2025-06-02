# usar: https://schellingb.github.io/LoveWebBuilder/package
# tomar cuidado com o tamanho dos arquivos (imagens)
# memory size tem q ser grande
# output mode: single html

mv assets/* .
mv news/* .
mv animations/* .
mv json/json.lua .
rm -fr inspect
sed -i 's/require "inspect\/inspect"/nil/g' *.lua
sed -i 's/json\/json/json/g' *.lua
sed -i 's/assets\///g' *.lua
sed -i 's/animations\///g' *.lua
sed -i 's/news\///g' *.lua
