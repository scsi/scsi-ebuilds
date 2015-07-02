#badblocks -sv -b 1024 -c 1 $1 -o badblock1.txt
#非破壞性的唯讀測試
#badblocks -sv -b 1024 -c 1 /dev/sdb1 -o badblock1.txt
#非破壞性的寫入測試
#badblocks -svn -b 1024 -c 1 /dev/sdb1 -o badblock.txt
badblocks -sv -b 1024 -c 1 $1
