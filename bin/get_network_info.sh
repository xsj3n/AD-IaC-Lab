token="$1"
id="$2"
ip=""
cfg_file="./configuration/ipinfo.cfg"

echo "Awaiting IP for VM $id"
while [ -z "$ip" ]; do
   ip=$(curl -s -k -H "Authorization: PVEAPIToken=$token" \
   "https://192.168.0.86:8006/api2/json/nodes/phv/qemu/$id/agent/network-get-interfaces" | \
   jq -r '.data.result[0]."ip-addresses"[3] | select(."ip-address-type" == "ipv4") | ."ip-address"')
   [[ ${ip:0:3} -eq 169 ]] && ip=""
   sleep 10
done

echo "Found VM $id IP: $ip"

# id_array & ip_array len should be equal
json=$(jq -n \
   --arg id "$id" \
   --arg ip "$ip" \
   '{id: $id, ip: $ip}')



exec 200>"/tmp/cb4f859c-6f30-4876-b4e4-6fe8def78fbe.lock"
flock -x 200
###
[[ ! -s "$cfg_file" ]] && echo "{}" > "$cfg_file"
jq  --argjson obj "$json" '.ip_addrs |= (if . then . else [] end) + [$obj]' "$cfg_file" > "${cfg_file}.tmp"
mv "${cfg_file}.tmp" "$cfg_file"
###
exec 200>&- 

