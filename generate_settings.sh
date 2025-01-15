#!/bin/bash
# ---VXLAN--- #
# --- generator --- #

# --- default_settings --- #
script_dir="$(dirname "$(realpath "$0")")"
dir="${script_dir}"
settings_file="$dir/settings.conf"

# -- timer --- # // for delayed ops
default_sleep_time="3"

# --- peer route--- # // for route table
default_peer_ip_addr="1.2.3.4/32" # //peer_ip_addr/mask //=1.2.3.4/32,2001:db8::/128
default_peer_ip_gw_ip="192.168.0.1" # //peer_ip_gw_ip //=1.2.3.4,2001:db8::
default_peer_ip_gw_dev="enp1s0" # //peer_ip_gw_dev //=enp1s0

# -- b.a.t.m.a.n. default_meshif--- #
default_batman_meshif="bat0"

# --- wg_ptp_link_default_settings--- # // for wg settings
default_wg_if_name="wg2host0" # //ptp_interface_name
default_wg_privatekey="*privatekey" # //ptp_interface_privatekey //=exa:"OEPjtjLJ1rWyK/SA2owiCCVYW46JHvPqFfy7gW3bZnA="
default_wg_publickey="*publickey" # //ptp_interface_publickey //=exa:"OEPjtjLJ1rWyK/SA2owiCCVYW46JHvPqFfy7gW3bZnA="
default_wg_presharedkey="*presharedkey" #//ptp_interface_presharedkey //=exa:"OEPjtjLJ1rWyK/SA2owiCCVYW46JHvPqFfy7gW3bZnA="
default_wg_local_ip="244.1.0.0" # //ptp_interface_src_ip //=1.2.3.4,2001:db8::1
default_wg_remote_ip="244.1.0.1" # //ptp_interface_dst_ip //=1.2.3.4,2001:db8::2
default_wg_address="244.1.0.0/31" #//ptp_interface_address //=1.2.3.4/32,2001:db8::1/32
default_wg_listen_port="65535" #//ptp_interface_listen_port //=none,1-65535 //note: set if act as "server", listener not as "client", or specify exactly where non random port
default_wg_peer_endpoint="1.2.3.4" #//ptp_interface_peer_endpoint //=1.2.3.4,2001:db8::1
default_wg_peer_endpoint_port="65535" #//ptp_interface_peer_endpoint_port //=1-65535
default_wg_allowed_ips="0.0.0.0/1, 128.0.0.0/1, ::/0" #//ptp_interface_peer_allowedips //=0.0.0.0/1, 128.0.0.0/1, ::/0
default_wg_table="off" #//ptp_interface_table //=off,on
default_wg_mtu="65535" #//ptp_interface_mtu //(experimental: 65535)
#default_wg_pre_up="$wg_pre_up" #//ptp_interface_pre_up //pre exe
#default_wg_pre_down="$wg_pre_down" #//ptp_interface_pre_down //pre exe
default_wg_post_up="$dir/up.sh" #//ptp_interface_post_up //post exe
default_wg_post_down="$dir/down.sh" #//ptp_interface_post_down //post exe
default_wg_persistent_keepalive="25" #//ptp_interface_peer_keepalive //=#off,0,1-

# --- wg_ptp_link_watchdog --- # // for watchdog
default_icmp_count="1" # //icmp_count //=none,many,(1-)
default_icmp_byte="16" # //icmp_byte //ip4=16-65507 //ip6=64-65507
default_icmp_timeout="1" # //icmp_timeout //in seconds

# --- ip_link --- # // get tun interface ready
default_tun_if_type="vxlan" # //TYPE=vxlan,gretap
default_tun_if_name="x2host0" # //tun_interface_name
default_tun_if_mac_addr="24:40:00:00:10:00" # //tun_interface_mac_address
default_tun_if_mtu="65535" # //tun_interface_mtu // (experimental: 24-65535) // #if(tun_if_type=gretap)
default_tun_dst_port="4789" # //tun_interface_tun_dst_port // #if(tun_if_type=gretap)
default_tun_vid="44001" # //tun_vid // >~16,777,215 // #if(tun_if_type=gretap)
default_tun_mac_learning="nolearning" # //TYPE=nolearning,learning
#
# --- user_input --- # // for generate settings
echo "[#]> [worker] [ settings ]"
echo "[#]- total parameters 2 set [ 31 ]"
echo "[#] _dir [ $dir ]"
echo "[#]<"
echo "[#]> [set] [ basic ] parameters [ 5 ]"
#
read -p "[#]  [1/3] [set] sleep time [$default_sleep_time]: " sleep_time
sleep_time=${sleep_time:-$default_sleep_time}

read -p "[#]  [2/3] [set] peer static via parameters [ 3 ] - (y/n) - [n]: " peer_ip_addr_response

if [[ "$peer_ip_addr_response" =~ ^[Yy]$ ]]; then
    read -p "[#]  [2/3 - 1/3] [set] peer dst ip addr/netmask [$default_peer_ip_addr]: " peer_ip_addr
peer_ip_addr=${peer_ip_addr:-$default_peer_ip_addr}

    read -p "[#]  [2/3 - 2/3] [set] peer via gw addr [$default_peer_ip_gw_ip]: " peer_ip_gw_ip
peer_ip_gw_ip=${peer_ip_gw_ip:-$default_peer_ip_gw_ip}

    read -p "[#]  [2/3 - 3/3] [set] peer via gw dev [$default_peer_ip_gw_dev]: " peer_ip_gw_dev
peer_ip_gw_dev=${peer_ip_gw_dev:-$default_peer_ip_gw_dev}

echo "[#]  [peer] static via parameters [set] - [ OK ] "

else
    echo "[#]  [peer] static via parameters [ NOT ] [set] this is a listener"
fi

read -p "[#]  [3/3] [set] b.a.t.m.a.n. interface name [$default_batman_meshif]: " batman_meshif
batman_meshif=${batman_meshif:-$default_batman_meshif}
#
echo "[#]< [ basic ] - [ OK ]"
echo "[#]- [1/4]"
echo "[#]> [set]  [ wireguard ] parameters [ 16 ]"
#
read -p "[#]  [1/16] [set] wg interface name [$default_wg_if_name]: " wg_if_name
wg_if_name=${wg_if_name:-$default_wg_if_name}

read -p "[#]  [2/16] [set] wg interface private key [$default_wg_privatekey]: " wg_privatekey
wg_privatekey=${wg_privatekey:-$default_wg_privatekey}

read -p "[#]  [3/16] [set] wg peer public key [$default_wg_publickey]: " wg_publickey
wg_publickey=${wg_publickey:-$default_wg_publickey}

read -p "[#]  [4/16] [set] wg peer pre-shared key [$default_wg_presharedkey]: " wg_presharedkey
wg_presharedkey=${wg_presharedkey:-$default_wg_presharedkey}

read -p "[#]  [5/16] [set] wg interface local ip [$default_wg_local_ip]: " wg_local_ip
wg_local_ip=${wg_local_ip:-$default_wg_local_ip}

read -p "[#]  [6/16] [set] wg interface remote ip [$default_wg_remote_ip]: " wg_remote_ip
wg_remote_ip=${wg_remote_ip:-$default_wg_remote_ip}

read -p "[#]  [7/16] [set] wg addr with local ip/netmask [$default_wg_address]: " wg_address
wg_address=${wg_address:-$default_wg_address}

read -p "[#]  [8/16] [set] wg listen port - (y/n) - [n]: " wg_listen_port_response

if [[ "$wg_listen_port_response" =~ ^[Yy]$ ]]; then
    read -p "[#]  [8/16 - 1/1] [set] wg listen port [$default_wg_listen_port]: " wg_listen_port
wg_listen_port=${wg_listen_port:-$default_wg_listen_port}

echo "[#]  [ wireguard ] [set] listen port - [ OK ] "

else
    echo "[#]  [ wireguard ] listen port [ NOT ] [set]"
fi

read -p "[#]  [9/16] [set] wg peer endpoint addr - (y/n) - [n]: " wg_endpoint_addr_response

if [[ "$wg_endpoint_addr_response" =~ ^[Yy]$ ]]; then
    read -p "[#]  [9/16 - 1/1] [set] wg peer endpoint addr [$default_wg_peer_endpoint]: " wg_peer_endpoint
wg_peer_endpoint=${wg_peer_endpoint:-$default_wg_peer_endpoint}

echo "[#]  [ wireguard ] [set] endpoint addr - [ OK ] "

else
    echo "[#]  [ wireguard ] endpoint addr [ NOT ] [set]"
fi

read -p "[#] [10/16] [set] wg peer endpoint port - (y/n) - [n]: " wg_peer_endpoint_port_response

if [[ "$wg_peer_endpoint_port_response" =~ ^[Yy]$ ]]; then
    read -p "[#] [10/16 - 1/1] [set] wg peer endpoint port [$default_wg_peer_endpoint_port]: " wg_peer_endpoint_port
wg_peer_endpoint_port=${wg_peer_endpoint_port:-$default_wg_peer_endpoint_port}

echo "[#] [ wireguard ] [set] endpoint port - [ OK ] "

else
    echo "[#] [ wireguard ] endpoint port [ NOT ] [set]"
fi

read -p "[#] [11/16] [set] wg peer allowed ips [$default_wg_allowed_ips]: " wg_allowed_ips
wg_allowed_ips=${wg_allowed_ips:-$default_wg_allowed_ips}

read -p "[#] [12/16] [set] wg table [$default_wg_table]: " wg_table
wg_table=${wg_table:-$default_wg_table}

read -p "[#] [13/16] [set] wg interface mtu [$default_wg_mtu]: " wg_mtu
wg_mtu=${wg_mtu:-$default_wg_mtu}

read -p "[#] [14/16] [set] wg-quick post up [$default_wg_post_up]: " wg_post_up
wg_post_up=${wg_post_up:-$default_wg_post_up}

read -p "[#] [15/16] [set] wg-quick post down [$default_wg_post_down]: " wg_post_down
wg_post_down=${wg_post_down:-$default_wg_post_down}

read -p "[#] [16/16] [set] wg peer persistent keepalive (#) [$default_wg_persistent_keepalive]: " wg_persistent_keepalive
wg_persistent_keepalive=${wg_persistent_keepalive:-$default_wg_persistent_keepalive}
#
echo "[#]< [ wireguard ] - [ OK ]"
echo "[#]- [2/4]"
echo "[#]> [set] [ wireguard ] [ watchdog ] parameters [ 3 ]"
#
read -p "[#]  [1/3] [set] watchdog icmp count [$default_icmp_count]: " icmp_count
icmp_count=${icmp_count:-$default_icmp_count}

read -p "[#]  [2/3] [set] watchdog icmp byte size [$default_icmp_byte]: " icmp_byte
icmp_byte=${icmp_byte:-$default_icmp_byte}

read -p "[#]  [3/3] [set] watchdog icmp timeout in seconds [$default_icmp_timeout]: " icmp_timeout
icmp_timeout=${icmp_timeout:-$default_icmp_timeout}
#
echo "[#]< [ wireguard ] [ watchdog ] - [ OK ]"
echo "[#]- [3/4]"
echo "[#]> [set] [ tunnel ] interface parameters [ 7 ]"
#
read -p "[#]  [1/7] [set] tunnel interface type [$default_tun_if_type]: " tun_if_type
tun_if_type=${tun_if_type:-$default_tun_if_type}

read -p "[#]  [2/7] [set] tunnel interface name [$default_tun_if_name]: " tun_if_name
tun_if_name=${tun_if_name:-$default_tun_if_name}

read -p "[#]  [3/7] [set] tunnel interface mac addr [$default_tun_if_mac_addr]: " tun_if_mac_addr
tun_if_mac_addr=${tun_if_mac_addr:-$default_tun_if_mac_addr}

read -p "[#]  [4/7] [set] tunnel interface mtu [$default_tun_if_mtu]: " tun_if_mtu
tun_if_mtu=${tun_if_mtu:-$default_tun_if_mtu}

read -p "[#]  [5/7] [set] tunnel dst port [$default_tun_dst_port]: " tun_dst_port
tun_dst_port=${tun_dst_port:-$default_tun_dst_port}

read -p "[#]  [6/7] [set] tunnel vid [$default_tun_vid]: " tun_vid
tun_vid=${tun_vid:-$default_tun_vid}

read -p "[#]  [7/7] [set] tunnel mac learning [$default_tun_mac_learning]: " tun_mac_learning
tun_mac_learning=${tun_mac_learning:-$default_tun_mac_learning}
#
echo "[#]< [ tunnel ] - [ OK ]"
echo "[#]- [4/4] all parameters - [ OK ]"
echo "[#]> [ready] meow all parameters 2 [ settings ]"
#
cat > "$settings_file" <<EOF
# --- type=vxlan ---  #
# --- settings --- #

# --- timer --- #
sleep_time="$sleep_time"

# --- b.a.t.m.a.n. meshif --- #
batman_meshif="$batman_meshif"

# --- peer route --- #
peer_ip_addr="$peer_ip_addr"
peer_ip_gw_ip="$peer_ip_gw_ip"
peer_ip_gw_dev="$peer_ip_gw_dev"

# --- wg_ptp_link_settings --- #
wg_if_name="$wg_if_name"
wg_privatekey="$wg_privatekey"
wg_publickey="$wg_publickey"
wg_presharedkey="$wg_presharedkey"
wg_local_ip="$wg_local_ip"
wg_remote_ip="$wg_remote_ip"
wg_address="$wg_address"
wg_listen_port="$wg_listen_port"
wg_peer_endpoint="$wg_peer_endpoint"
wg_peer_endpoint_port="$wg_peer_endpoint_port"
wg_allowed_ips="$wg_allowed_ips"
wg_table="$wg_table"
wg_mtu="$wg_mtu"
#wg_pre_up="$wg_pre_up"
#wg_pre_down="$wg_pre_down"
wg_post_up="$wg_post_up"
wg_post_down="$wg_post_down"
wg_persistent_keepalive="$wg_persistent_keepalive"

# --- wg_ptp_link_watchdog --- #
icmp_count="$icmp_count"
icmp_byte="$icmp_byte"
icmp_timeout="$icmp_timeout"

# --- tun_link_settings --- #
tun_if_type="$tun_if_type"
tun_if_name="$tun_if_name"
tun_if_mac_addr="$tun_if_mac_addr"
tun_if_mtu="$tun_if_mtu"
tun_dst_port="$tun_dst_port"
tun_vid="$tun_vid"
tun_mac_learning="$tun_mac_learning"

EOF

# --- log_results --- #
if [[ -f "$settings_file" ]]; then
    echo "[#]  [$settings_file] [ settings ] [generated] [updated]"
    echo "[#]< [ settings ] [generate] [update] - [ OK ]"
else
    echo "[#]< [$settings_file] [ settings ] [generate] [update] - [ FAILED ]"
    exit 1
fi

echo "[#]< [done] [ settings ] - [ OK ]"
