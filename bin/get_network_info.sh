token="$1"
id="$2"
ip=""
ip6=""
cfg_file="$3"

echo "Awaiting IP for VM $id"
while [ -z "$ip" ]; do
   response=$(curl -s -k -H "Authorization: PVEAPIToken=$token" \
   "https://192.168.0.86:8006/api2/json/nodes/pve0/qemu/$id/agent/network-get-interfaces")
   ip=$(echo "$response" | jq -r '.data.result[0]."ip-addresses"[3] | select(."ip-address-type" == "ipv4") | ."ip-address"')
   ip6=$(echo "$response" | jq -r '.data.result[0]."ip-addresses"[0] | select(."ip-address-type" == "ipv6") | ."ip-address"')
   [[ ${ip:0:3} -eq 169 ]] && ip=""
   sleep 10
done

echo "Found VM $id IP: $ip"

# id_array & ip_array len should be equal
json=$(jq -n \
   --arg id "$id" \
   --arg ip "$ip"  \
   --arg ip6 "$ip6" \
   '{id: $id, ip: $ip, ip6: $ip6}')



exec 200>"/tmp/cb4f859c-6f30-4876-b4e4-6fe8def78fbe.lock"
flock -x 200
###
[[ ! -s "$cfg_file" ]] && echo "{}" > "$cfg_file"
jq  --argjson obj "$json" '.ip_addrs |= (if . then . else [] end) + [$obj]' "$cfg_file" > "${cfg_file}.tmp"
mv "${cfg_file}.tmp" "$cfg_file"
###
exec 200>&- 

