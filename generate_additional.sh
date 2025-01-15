#!/bin/bash
# --- additional_generator --- #

# --- default_settings --- #
script_dir="$(dirname "$(realpath "$0")")"
dir="${script_dir}"
settings_file="$dir/settings.conf"
source "$settings_file"
default_wg_config_file="$dir/${wg_if_name}.conf"
default_wg_init_file="$dir/init.sh"
default_wg_post_up_file="$dir/up.sh"
default_wg_post_down_file="$dir/down.sh"
default_wg_watchdog_file="$dir/watchdog.sh"

# --- create [ config ] for wg_conf [ script ] for helper --- #
echo "[#]> [worker]"
echo "[#]- additional total [ 1 ] config and [ 4 ] script required create at least once or update and [set] [systemd]"
echo "[#] _dir [ $dir ]"
echo "[#]<"
#
echo "[#]  [ settings ] - [ 0 ] - wireguard listener config act as server"
echo "[#]  [ settings ] - [ 1 ] - wireguard peer config act as client with random port"
echo "[#]  [ settings ] - [ 2 ] - wireguard peer config act as client with static port"

read -p "[#]* [ settings ] - [ 0 | 1 | 2 ]: " wg_config_response

if [[ "$wg_config_response" =~ ^[0]$ ]]; then
echo "[#]> [create] wireguard interface [ config ] required for [ init ] with listen port [set]"
read -p "[#]  [ config ] [set] path [ $default_wg_config_file ]: " wg_config_file
wg_config_file=${wg_config_file:-$default_wg_config_file}

cat > "$wg_config_file" <<EOF
[Interface]
PrivateKey = $wg_privatekey
Address = $wg_address
ListenPort = $wg_listen_port
MTU = $wg_mtu
PostUp = $wg_post_up
PostDown = $wg_post_down
Table = $wg_table

[Peer]
PublicKey = $wg_publickey
PresharedKey = $wg_presharedkey
#PersistentKeepalive = $wg_persistent_keepalive
AllowedIPs = $wg_allowed_ips

EOF

# --- cp_wg_config and log_results --- #
if [[ -f "$wg_config_file" ]]; then
    cp "$wg_config_file" /etc/wireguard/
    echo "[#]  [ wireguard ] [set] listener config"
    echo "[#]  [ $wg_config_file ] - [generated] [updated]"
    echo "[#]  [copy] - [ $wg_if_name ] wg config copied to /etc/wireguard/"
    echo "[#]< [ config ] [generate] [copy] [update] - [ OK ]"
else
    echo "[#]< [$wg_if_name] [generate] [copy] [update] - [ FAILED ]"
    exit 1
fi
fi

if [[ "$wg_config_response" =~ ^[1]$ ]]; then
echo "[#]> [create] wireguard interface [ config ] required for [ init ] with listen port [set]"
read -p "[#]  [ config ] [set] path [ $default_wg_config_file ]: " wg_config_file
wg_config_file=${wg_config_file:-$default_wg_config_file}

cat > "$wg_config_file" <<EOF
[Interface]
PrivateKey = $wg_privatekey
Address = $wg_address
MTU = $wg_mtu
PostUp = $wg_post_up
PostDown = $wg_post_down
Table = $wg_table

[Peer]
Endpoint = $wg_peer_endpoint:$wg_peer_endpoint_port
PublicKey = $wg_publickey
PresharedKey = $wg_presharedkey
#PersistentKeepalive = $wg_persistent_keepalive
AllowedIPs = $wg_allowed_ips

EOF

# --- cp_wg_config and log_results --- #
if [[ -f "$wg_config_file" ]]; then
    cp "$wg_config_file" /etc/wireguard/
    echo "[#]  [ wireguard ] [set] peer random port config"
    echo "[#]  [ $wg_config_file ] - [generated] [updated]"
    echo "[#]  [copy] - [ $wg_if_name ] wg config copied to /etc/wireguard/"
    echo "[#]< [ config ] [generate] [copy] [update] - [ OK ]"
else
    echo "[#]< [$wg_if_name] [generate] [copy] [update] - [ FAILED ]"
    exit 1
fi
fi

if [[ "$wg_config_response" =~ ^[2]$ ]]; then
echo "[#]> [create] wireguard interface [ config ] required for [ init ] without listen port [set]"
read -p "[#]  [ config ] [set] path [ $default_wg_config_file ]: " wg_config_file
wg_config_file=${wg_config_file:-$default_wg_config_file}

cat > "$wg_config_file" <<EOF
[Interface]
PrivateKey = $wg_privatekey
Address = $wg_address
ListenPort = $wg_listen_port
MTU = $wg_mtu
PostUp = $wg_post_up
PostDown = $wg_post_down
Table = $wg_table

[Peer]
Endpoint = $wg_peer_endpoint:$wg_peer_endpoint_port
PublicKey = $wg_publickey
PresharedKey = $wg_presharedkey
#PersistentKeepalive = $wg_persistent_keepalive
AllowedIPs = $wg_allowed_ips

EOF

# --- cp_wg_config and log_results --- #
if [[ -f "$wg_config_file" ]]; then
    cp "$wg_config_file" /etc/wireguard/
    echo "[#]  [ wireguard ] [set] peer static port config"
    echo "[#]  [ $wg_config_file ] - [generated] [updated]"
    echo "[#]  [copy] - [ $wg_if_name ] wg config copied to /etc/wireguard/"
    echo "[#]< [ config ] [generate] [copy] [update] - [ OK ]"
else
    echo "[#]< [$wg_if_name] [generate] [copy] [update] - [ FAILED ]"
    exit 1
fi
fi

echo "[#]- [1/5]"

# --- create [ init ] and wg_conf [ generate ] sed ops and bring link up--- #
echo "[#]> [create] [ init ] [script] required for [init]"
read -p "[#]  [ init ] [set] path [ $default_wg_init_file ]: " wg_init_file
wg_init_file=${wg_init_file:-$default_wg_init_file}

cat > "$wg_init_file" <<'EOF'
#!/bin/bash
# ---init--- #
# --- VXLAN --- #
script_dir=$(dirname "$(realpath "$0")")
settings_file="$script_dir/settings.conf"
source "$settings_file"

# ---echo_settings--- #
echo "[#]> [settings]      [ $wg_if_name ]"
echo "[#] _sleep_timer     [ $sleep_time ]"
echo "[#] _batman_meshif   [ $batman_meshif ]"
echo "[#] _peer_ip_addr    [ $peer_ip_addr ]"
echo "[#] _peer_ip_gw_ip   [ $peer_ip_gw_ip ]"
echo "[#] _peer_ip_gw_dev  [ $peer_ip_gw_dev ]"
echo "[#] _wg_peer_end     [ $wg_peer_endpoint ]"
echo "[#] _wg_peer_endp    [ $wg_peer_endpoint_port ]"
echo "[#] _wg_if_name      [ $wg_if_name ]"
echo "[#] _wg_address      [ $wg_address ]"
echo "[#] _wg_local        [ $wg_local_ip ]"
echo "[#] _wg_remote       [ $wg_remote_ip ]"
echo "[#] _wg_privatekey   [ $wg_privatekey ]"
echo "[#] _wg_publickey    [ $wg_publickey ]"
echo "[#] _wg_presharedkey [ $wg_presharedkey ]"
echo "[#] _wg_mtu          [ $wg_mtu ]"
echo "[#] _wg_post_up      [ $wg_post_up ]"
echo "[#] _wg_post_down    [ $wg_post_down ]"
echo "[#] _wg_table        [ $wg_table ]"
echo "[#] _wg_keepalive    [ $wg_persistent_keepalive ]"
echo "[#] _wg_allow_ips    [ $wg_allowed_ips ]"
echo "[#] _icmp_count      [ $icmp_count ]"
echo "[#] _icmp_byte       [ $icmp_byte ]"
echo "[#] _icmp_timeout    [ $icmp_timeout ]"
echo "[#] _tun_if_type     [ $tun_if_type ]"
echo "[#] _tun_if_name     [ $tun_if_name ]"
echo "[#] _tun_if_mac_addr [ $tun_if_mac_addr ]"
echo "[#] _tun_if_mtu      [ $tun_if_mtu ]"
echo "[#] _tun_dst_port    [ $tun_dst_port ]"
echo "[#] _tun_vid         [ $tun_vid ]"
echo "[#] _tun_mac_learn   [ $tun_mac_learning ]"

# --- perform --- #
echo "[#]> [worker]"
echo "[#]  [$wg_if_name] [ set ] wg-quick ip link up"
wg-quick up $wg_if_name
echo "[#]< [$tun_if_name] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$wg_init_file" ]]; then
    echo "[#]  [ $wg_init_file ] - [generated] [updated]"
    echo "[#]< [ init ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $wg_init_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi

# --- chmod --- #
echo "[#]> [set] chmod on [ init ]"
chmod +x "$wg_init_file"
echo "[#]< [done] [ init ] - [ OK ]"

echo "[#]- [2/5]"

# --- [ post up ] process and [ tun_if ],[ meshif ] link and ips set/add/up --- #
echo "[#]> [create] [ post up ] script required for [ tunnel ] [ mesh ] operations"
read -p "[#]  [ post up ] [set] script path [ $default_wg_post_up_file ]: " wg_post_up_file
wg_post_up_file=${wg_post_up_file:-$default_wg_post_up_file}

cat > "$wg_post_up_file" <<'EOF'
#!/bin/bash
# --- post up --- #
# --- VXLAN --- #
script_dir=$(dirname "$(realpath "$0")")
settings_file="$script_dir/settings.conf"
source "$settings_file"

# --- settings --- #
echo "[#]> [settings] [$tun_if_name] [ post up ]"
echo "[#] _peer    [ $peer_ip_addr ]"
echo "[#] _type    [ $tun_if_type ]"
echo "[#] _name    [ $tun_if_name ]"
echo "[#] _tun_vid [ $tun_vid ]"
echo "[#] _mac     [ $tun_if_mac_addr ]"
echo "[#] _mtu     [ $tun_if_mtu ]"
echo "[#] _src     [ $wg_local_ip ]"
echo "[#] _dst     [ $wg_remote_ip ]"
echo "[#] _dstp    [ $tun_dst_port ]"
echo "[#] _lear    [ $tun_mac_learning ]"

# --- perform --- #
#-comment route add when wg is listener-#

echo "[#]> [worker]"
echo "[#]  [$tun_if_name] [ add ] peer ip route 2 [main_table]"
ip route add $peer_ip_addr via $peer_ip_gw_ip dev $peer_ip_gw_dev
echo "[#]  [$tun_if_name] [ wait ] for ptp/ptmp ifaces ready, sleep [ $sleep_time ]"
sleep $sleep_time
echo "[#]  [$tun_if_name] [ add ] ip link"
ip link add name $tun_if_name type $tun_if_type local $wg_local_ip remote $wg_remote_ip dstport $tun_dst_port id $tun_vid $tun_mac_learning
echo "[#]  [$tun_if_name] [ set ] link mac addr"
ip link set $tun_if_name address $tun_if_mac_addr
echo "[#]  [$tun_if_name] [ set ] link up"
ip link set $tun_if_name up
echo "[#]  [$tun_if_name] [ set ] link mtu"
ip link set mtu $tun_if_mtu $tun_if_name
echo "[#]  [$tun_if_name] [ready] link ready"
echo "[#]  [$tun_if_name] [ add ] link 2 [b.a.t.m.a.n.]"
batctl $batman_meshif if add $tun_if_name
echo "[#]< [$tun_if_name] [ready] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$wg_post_up_file" ]]; then
    echo "[#]  [ $wg_post_up_file ] - [generated] [updated]"
    echo "[#]< [ post up ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $wg_post_up_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi

# --- chmod --- #
echo "[#]> [set] chmod on [ post up ]"
chmod +x "$wg_post_up_file"
echo "[#]< [done] [ post up ] - [ OK ]"

echo "[#]- [3/5]"

# --- [ post down ] process and [ tun_if ],[ meshif ] link and ips down/del --- #
echo "[#]> [create] [ post down ] script required for [ tunnel ] [ mesh ] operations"
read -p "[#]  [ post down ] [set] script path [ $default_wg_post_down_file ]: " wg_post_down_file
wg_post_down_file=${wg_post_down_file:-$default_wg_post_down_file}

cat > "$wg_post_down_file" <<'EOF'
#!/bin/bash
# --- post down --- #
# --- VXLAN --- #
script_dir=$(dirname "$(realpath "$0")")
settings_file="$script_dir/settings.conf"
source "$settings_file"

# --- settings --- #
echo "[#]> [settings] [$tun_if_name] [ post down ]"
echo "[#] _name [ $tun_if_name ]"
echo "[#] _mesh [ $batman_meshif ]"
echo "[#] _peer [ $peer_ip_addr ]"

# --- perform --- #
#-comment route del when wg is listener-#

echo "[#]> [worker]"
echo "[#]  [$tun_if_name] [ del ] peer ip route from [main_table]"
ip route del $peer_ip_addr
echo "[#]  [$tun_if_name] [ del ] ip link"
ip link del $tun_if_name
echo "[#]< [$tun_if_name] [ del ] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$wg_post_down_file" ]]; then
    echo "[#]  [ $wg_post_down_file ] - [generated] [updated]"
    echo "[#]< [ post down ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $wg_post_down_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi

# --- chmod --- #
echo "[#]> [set] chmod on [ post down ]"
chmod +x "$wg_post_down_file"
echo "[#]< [done] [ post down ] - [ OK ]"

echo "[#]- [4/5]"

# --- perform [ watchdog ] actions with icmp for detect ip link reachability and [ restart ] if timeout (3000ms) --- #
echo "[#]> [create] [ watchdog ] script required for [ watchdog ] and [ reinit ]"
read -p "[#]  [ watchdog ] [set] script path [ $default_wg_watchdog_file ]: " wg_watchdog_file
wg_watchdog_file=${wg_watchdog_file:-$default_wg_watchdog_file}

cat > "$wg_watchdog_file" <<'EOF'
#!/bin/bash
# --- watchdog --- #
script_dir=$(dirname "$(realpath "$0")")
settings_file="$script_dir/settings.conf"
source "$settings_file"

# --- settings --- #
echo "[#]> [settings] [$wg_if_name] [ watchdog ]"
echo "[#] _name   [ $wg_if_name ]"
echo "[#] _src_ip [ $wg_local_ip ]"
echo "[#] _dst_ip [ $wg_remote_ip ]"
echo "[#] _count  [ $icmp_count ]"
echo "[#] _timeo  [ $icmp_timeout ]"
echo "[#] _byte   [ $icmp_byte ]"

# --- perform --- #
echo "[#]> [worker]"
echo "[#]  [$wg_if_name] [ challenge ] remote addr with icmp"
if /bin/ping -c $icmp_count $wg_remote_ip -I $wg_if_name -s $icmp_byte -W $icmp_timeout
then
echo "[#]< [$wg_if_name] [ challenge ] - [ OK ]"
else
echo "[#]< [ TIMEOUT ]"
echo "[#]> [$wg_if_name] [ set ] [ wg-quick ] - [ down ]"
wg-quick down $wg_if_name
echo "[#]  [$wg_if_name] [ set ] [ wg-quick ] - [ up ]"
wg-quick up $wg_if_name
echo "[#]< [$wg_if_name] [ restart ] - [ OK ]"
fi

EOF

# --- log_results --- #
if [[ -f "$wg_watchdog_file" ]]; then
    echo "[#]  [ $wg_watchdog_file ] - [generated] [updated]"
    echo "[#]< [ watchdog ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $wg_watchdog_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi

# --- chmod --- #
echo "[#]> [set] chmod on [ watchdog ]"
chmod +x "$wg_watchdog_file"
echo "[#]< [done] [ watchdog ] - [ OK ]"

# --- [done] --- #
echo "[#]- [5/5]"
echo "[#]< [done] [ config ] [ scripts ] - [ OK ]"

# --- systemd --- #
read -p "[#]> [create] [ wireguard ] [systemd] service - (y/n) - [n]: " response

if [[ "$response" =~ ^[Yy]$ ]]; then
    read -p "[#]  [set] service name [$wg_if_name]: " wg_init_name
wg_init_name=${wg_init_name:-$wg_if_name}

    systemctl enable "wg-quick@$wg_init_name"

    echo "[#]< [done] [systemctl enabled] - [ OK ]"

    read -p "[#]> [start] [$wg_if_name] [set] [wg-quick] - [ up ] - (y/n) - [n]: " start_response
    if [[ "$start_response" =~ ^[Yy]$ ]]; then
        wg-quick up $wg_init_name
        echo "[#]< [done] [wg-quick started] [ $wg_init_name ] - [ OK ]"
    else
        echo "[#]< [done] [wg-quick [ NOT ] started] [ $wg_init_name ] - [ NOK ]"
        echo "[#]>>[run] [ init ]"
    fi

else
    echo "[#]< [done] [systemd service [ NOT ] created]"
    echo "[#]>>[run] [ init ]"
fi
