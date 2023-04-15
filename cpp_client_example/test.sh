./stop_kudu.sh
./make.sh
./start_kudu.sh
sleep 3
./non_unique_primary_key localhost:8764
