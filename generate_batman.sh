#!/bin/bash
# --- b.a.t.m.a.n. --- #
# --- generator --- #

# --- default_settings --- #
script_dir="$(dirname "$(realpath "$0")")"
dir="${script_dir}"
settings_file="$dir/settings.conf"
default_bat_gwlupdater_file="$dir/gwlupdater.sh"
default_bat_init_file="$dir/init.sh"

# --- b.a.t.m.a.n. --- # // default configuration
default_bat_meshif="bat0" # //b.a.t.m.a.n._meshif_name=bat0,bat(etc).
default_bat_meshif_mac_addr="04:40:00:01:00:01" # //b.a.t.m.a.n._meshif_mac_addr
default_bat_meshif_ip_addr="44.1.0.1/8" # //b.a.t.m.a.n._meshif_ip_address/network
default_bat_routing_algo="BATMAN_IV" # //b.a.t.m.a.n._routing_algo=BATMAN_IV,BATMAN_V
default_bat_aggregation="1" # //b.a.t.m.a.n._aggregation=0,1
default_bat_gw_mode="server" # //b.a.t.m.a.n._mode=off,client,server
default_bat_hop_penalty="32" # //b.a.t.m.a.n._hop_penalty=0-255
default_bat_fragmentation="0" # //b.a.t.m.a.n._fragmentation=0,1
default_bat_orig_interval="500" # //b.a.t.m.a.n._orig_interval=40-
default_bat_bonding="0" # //b.a.t.m.a.n._bonding=0,1
default_bat_bridge_loop_avoidance="1" # //b.a.t.m.a.n._bridge_loop_avoidance=0,1
default_bat_distributed_arp_table="1" # //b.a.t.m.a.n._distributed_arp_table=0,1
default_bat_network_coding="0" # //b.a.t.m.a.n._network_coding=0,1

# -- gwl_updater --- # //parameters
#note: at first run, rx/tx values doesnt exist, therefore nowhere from read values, updates with 0/0,
#note: this become alive from second run, and always update the last written values,

default_bat_meshif_speed="50000" # //b.a.t.m.a.n._meshif_speed=1- if(gw_mode=server)
default_bat_sampling_time="2" # //interface_bat_sampling_time

# -- postrouting --- # //parameters
default_nat_src_addr="44.0.0.0/8" #//masquerade source addr
default_nat_outgoing_if="enp1s0" # //postrouting outgoing if

# --- user_input --- # // for generate settings
echo "[#]> [worker] [ settings ]"
echo "[#]- total parameters 2 set [ 26 ]"
echo "[#] _dir [ $dir ]"
echo "[#]<"

echo "[#]> [set] [ b.a.t.m.a.n. ] mesh interface parameters [ 15 ]"

read -p "[#]  [1/15] [set] mesh interface name [$default_bat_meshif]: " bat_meshif
bat_meshif=${bat_meshif:-$default_bat_meshif}

read -p "[#]  [2/15] [set] mac addr [$default_bat_meshif_mac_addr]: " bat_meshif_mac_addr
bat_meshif_mac_addr=${bat_meshif_mac_addr:-$default_bat_meshif_mac_addr}

read -p "[#]  [3/15] [set] ip addr [$default_bat_meshif_ip_addr]: " bat_meshif_ip_addr
bat_meshif_ip_addr=${bat_meshif_ip_addr:-$default_bat_meshif_ip_addr}

read -p "[#]  [4/15] [set] routing algorithm [$default_bat_routing_algo]: " bat_routing_algo
bat_routing_algo=${bat_routing_algo:-$default_bat_routing_algo}

read -p "[#]  [5/15] [set] aggregation [$default_bat_aggregation]: " bat_aggregation
bat_aggregation=${bat_aggregation:-$default_bat_aggregation}

read -p "[#]  [6/15] [set] mode [$default_bat_gw_mode]: " bat_gw_mode
bat_gw_mode=${bat_gw_mode:-$default_bat_gw_mode}

read -p "[#]  [7/15] [set] hop penalty [$default_bat_hop_penalty]: " bat_hop_penalty
bat_hop_penalty=${bat_hop_penalty:-$default_bat_hop_penalty}

read -p "[#]  [8/15] [set] fragmentation [$default_bat_fragmentation]: " bat_fragmentation
bat_fragmentation=${bat_fragmentation:-$default_bat_fragmentation}

read -p "[#]  [9/15] [set] originator interval in ms [$default_bat_orig_interval]: " bat_orig_interval
bat_orig_interval=${bat_orig_interval:-$default_bat_orig_interval}

read -p "[#] [10/15] [set] bonding [$default_bat_bonding]: " bat_bonding
bat_bonding=${bat_bonding:-$default_bat_bonding}

read -p "[#] [11/15] [set] bridge loop avoidance [$default_bat_bridge_loop_avoidance]: " bat_bridge_loop_avoidance
bat_bridge_loop_avoidance=${bat_bridge_loop_avoidance:-$default_bat_bridge_loop_avoidance}

read -p "[#] [12/15] [set] distributed arp table [$default_bat_distributed_arp_table]: " bat_distributed_arp_table
bat_distributed_arp_table=${bat_distributed_arp_table:-$default_bat_distributed_arp_table}

read -p "[#] [13/15] [set] network coding [$default_bat_network_coding]: " bat_network_coding
bat_network_coding=${bat_network_coding:-$default_bat_network_coding}

read -p "[#] [14/15] [set] [iptables] nat source addr/netmask - if gateway - (y/n) - [n]: " nat_src_addr_response

if [[ "$nat_src_addr_response" =~ ^[Yy]$ ]]; then
    read -p "[#] [14/15 - 1/1] [set] nat src addr [$default_nat_src_addr]: " nat_src_addr
nat_src_addr=${nat_src_addr:-$default_nat_src_addr}

echo "[#] [iptables] [set] nat src addr - [ OK ] "

else
    echo "[#] [iptables] nat src addr [ NOT ] [set]"
fi

read -p "[#] [15/15] [set] [iptables] postrouting outgoing if - if gateway - (y/n) - [n]: " nat_outgoing_if_response

if [[ "$nat_outgoing_if_response" =~ ^[Yy]$ ]]; then
    read -p "[#] [15/15 - 1/1] [set] postrouting outgoing if [$default_nat_outgoing_if]: " nat_outgoing_if
nat_outgoing_if=${nat_outgoing_if:-$default_nat_outgoing_if}

echo "[#] [iptables] [set] postrouting outgoing if - [ OK ] "

else
    echo "[#] [iptables] postrouting outgoing if [ NOT ] [set]"
fi

echo "[#]< [done] [set] [ b.a.t.m.a.n. ] [ settings ] - [ OK ]"
echo "[#]- [1/3]"

# --- create b.a.t.m.a.n. init --- #
echo "[#]  [ settings ] - [ 0 ] - gateway - nat mesh traffic - no def route del"
echo "[#]  [ settings ] - [ 1 ] - client - no nat - del def route"
echo "[#]  [ settings ] - [ 2 ] - client - no nat - no def route del"

read -p "[#]* [ settings ] - [ 0 | 1 | 2 ]: " bat_init_file_response

if [[ "$bat_init_file_response" =~ ^[0]$ ]]; then
echo "[#]> [create] [ b.a.t.m.a.n. ] [ init ] [script] required for [init] interface"
read -p "[#]  [ config ] [set] path [ $default_bat_init_file ]: " bat_init_file
bat_init_file=${bat_init_file:-$default_bat_init_file}

cat > "$bat_init_file" <<'EOF'
#!/bin/bash
# --- b.a.t.m.a.n. init gateway--- #

# --- default_settings --- #
script_dir=$(dirname "$(realpath "$0")")
dir="${script_dir}"
settings_file="$script_dir/settings.conf"
source "$settings_file"

# ---echo_settings--- #
echo "[#]> [settings] [gateway] [ mesh ]"
echo "[#] _name    [ $bat_meshif ]"
echo "[#] _algo    [ $bat_routing_algo ]"
echo "[#] _mac     [ $bat_meshif_mac_addr ]"
echo "[#] _addr    [ $bat_meshif_ip_addr ]"
echo "[#] _mode    [ $bat_gw_mode ]"
echo "[#] _ogmi    [ $bat_orig_interval ]"
echo "[#] _hop     [ $bat_hop_penalty ]"
echo "[#] _arp     [ $bat_distributed_arp_table ]"
echo "[#] _loop    [ $bat_bridge_loop_avoidance ]"
echo "[#] _aggr    [ $bat_aggregation ]"
echo "[#] _bond    [ $bat_bonding ]"
echo "[#] _frag    [ $bat_fragmentation ]"
echo "[#] _ncode   [ $bat_network_coding ]"
echo "[#]> [iptables]"
echo "[#] _nat_src [ $nat_src_addr ]"
echo "[#] _out_if  [ $nat_outgoing_if ]"

# --- perform --- #
echo "[#]> [worker]"
#echo "[#]  [$bat_meshif] [ destroy ] meshif if exist"
#batctl meshif $bat_meshif interface destroy
echo "[#]  [$bat_meshif] [ create ] meshif and set routing_algo"
batctl meshif $bat_meshif interface create routing_algo $bat_routing_algo
echo "[#]  [$bat_meshif] [ set ] meshif up"
ip link set up $bat_meshif
echo "[#]  [$bat_meshif] [ set ] meshif parameters"
batctl $bat_meshif aggregation $bat_aggregation
batctl $bat_meshif gw_mode $bat_gw_mode
batctl $bat_meshif hop_penalty $bat_hop_penalty
batctl $bat_meshif fragmentation $bat_fragmentation
batctl $bat_meshif orig_interval $bat_orig_interval
batctl $bat_meshif bonding $bat_bonding
batctl $bat_meshif bridge_loop_avoidance $bat_bridge_loop_avoidance
batctl $bat_meshif distributed_arp_table $bat_distributed_arp_table
batctl $bat_meshif network_coding $bat_network_coding
echo "[#]  [$bat_meshif] [ set ] meshif mac addr"
ip link set $bat_meshif addr $bat_meshif_mac_addr
echo "[#]  [$bat_meshif] [ set ] meshif ip addr"
ip addr add $bat_meshif_ip_addr dev $bat_meshif
echo "[#]  [$bat_meshif] [ready] meshif ready"
echo "[#]  [iptables] [ set ] postrouting"
/sbin/iptables -t nat -I POSTROUTING 1 -s $nat_src_addr -o $nat_outgoing_if -j MASQUERADE
echo "[#]  [iptables] [ set ] - [ OK ]"
echo "[#]< [$bat_meshif] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$bat_init_file" ]]; then
    echo "[#]  [ mesh ] [set] gateway [ init ] and nat source traffic"
    echo "[#]  [ $bat_init_file ] - [generated] [updated]"
    echo "[#]< [ init ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $bat_init_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi
fi

if [[ "$bat_init_file_response" =~ ^[1]$ ]]; then
echo "[#]> [create] [ b.a.t.m.a.n. ] [ init ] [script] required for [init] interface"
read -p "[#]  [ config ] [set] path [ $default_bat_init_file ]: " bat_init_file
bat_init_file=${bat_init_file:-$default_bat_init_file}

cat > "$bat_init_file" <<'EOF'
#!/bin/bash
# --- b.a.t.m.a.n. init client del def route--- #

# --- default_settings --- #
script_dir=$(dirname "$(realpath "$0")")
dir="${script_dir}"
settings_file="$script_dir/settings.conf"
source "$settings_file"

# ---echo_settings--- #
echo "[#]> [settings] [client] [ mesh ]"
echo "[#] _name  [ $bat_meshif ]"
echo "[#] _algo  [ $bat_routing_algo ]"
echo "[#] _mac   [ $bat_meshif_mac_addr ]"
echo "[#] _addr  [ $bat_meshif_ip_addr ]"
echo "[#] _mode  [ $bat_gw_mode ]"
echo "[#] _ogmi  [ $bat_orig_interval ]"
echo "[#] _hop   [ $bat_hop_penalty ]"
echo "[#] _arp   [ $bat_distributed_arp_table ]"
echo "[#] _loop  [ $bat_bridge_loop_avoidance ]"
echo "[#] _aggr  [ $bat_aggregation ]"
echo "[#] _bond  [ $bat_bonding ]"
echo "[#] _freg  [ $bat_fragmentation ]"
echo "[#] _ncode [ $bat_network_coding ]"

# --- perform --- #
echo "[#]> [worker]"
#echo "[#]  [$bat_meshif] [ destroy ] meshif if exist"
#batctl meshif $bat_meshif interface destroy
echo "[#]  [$bat_meshif] [ create ] meshif and set routing_algo"
batctl meshif $bat_meshif interface create routing_algo $bat_routing_algo
echo "[#]  [$bat_meshif] [ set ] meshif up"
ip link set up $bat_meshif
echo "[#]  [$bat_meshif] [ set ] meshif parameters"
batctl $bat_meshif aggregation $bat_aggregation
batctl $bat_meshif gw_mode $bat_gw_mode
batctl $bat_meshif hop_penalty $bat_hop_penalty
batctl $bat_meshif fragmentation $bat_fragmentation
batctl $bat_meshif orig_interval $bat_orig_interval
batctl $bat_meshif bonding $bat_bonding
batctl $bat_meshif bridge_loop_avoidance $bat_bridge_loop_avoidance
batctl $bat_meshif distributed_arp_table $bat_distributed_arp_table
batctl $bat_meshif network_coding $bat_network_coding
echo "[#]  [$bat_meshif] [ set ] meshif mac addr"
ip link set $bat_meshif addr $bat_meshif_mac_addr
echo "[#]  [$bat_meshif] [ set ] meshif ip addr"
ip addr add $bat_meshif_ip_addr dev $bat_meshif
echo "[#]  [$bat_meshif] [ready] meshif ready"
echo "[#]  [ip link] [ del ] default route from [main_table] + [sleep]"
sleep 3
ip route del default
echo "[#]  [ip link] [ del ] default route - [ OK ]"
echo "[#]< [$bat_meshif] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$bat_init_file" ]]; then
    echo "[#]  [ mesh ] [set] client [ init ] and del default route"
    echo "[#]  [ $bat_init_file ] - [generated] [updated]"
    echo "[#]< [ init ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $bat_init_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi
fi

if [[ "$bat_init_file_response" =~ ^[2]$ ]]; then
echo "[#]> [create] [ b.a.t.m.a.n. ] [ init ] [script] required for [init] interface"
read -p "[#]  [ config ] [set] path [ $default_bat_init_file ]: " bat_init_file
bat_init_file=${bat_init_file:-$default_bat_init_file}

cat > "$bat_init_file" <<'EOF'
#!/bin/bash
# --- b.a.t.m.a.n. init client no def route del--- #

# --- default_settings --- #
script_dir=$(dirname "$(realpath "$0")")
dir="${script_dir}"
settings_file="$script_dir/settings.conf"
source "$settings_file"

# ---echo_settings--- #
echo "[#]> [settings] [client] [ mesh ]"
echo "[#] _name  [ $bat_meshif ]"
echo "[#] _algo  [ $bat_routing_algo ]"
echo "[#] _mac   [ $bat_meshif_mac_addr ]"
echo "[#] _addr  [ $bat_meshif_ip_addr ]"
echo "[#] _mode  [ $bat_gw_mode ]"
echo "[#] _ogmi  [ $bat_orig_interval ]"
echo "[#] _hop   [ $bat_hop_penalty ]"
echo "[#] _arp   [ $bat_distributed_arp_table ]"
echo "[#] _loop  [ $bat_bridge_loop_avoidance ]"
echo "[#] _aggr  [ $bat_aggregation ]"
echo "[#] _bond  [ $bat_bonding ]"
echo "[#] _freg  [ $bat_fragmentation ]"
echo "[#] _ncode [ $bat_network_coding ]"

# --- perform --- #
echo "[#]> [worker]"
#echo "[#]  [$bat_meshif] [ destroy ] meshif if exist"
#batctl meshif $bat_meshif interface destroy
echo "[#]  [$bat_meshif] [ create ] meshif and set routing_algo"
batctl meshif $bat_meshif interface create routing_algo $bat_routing_algo
echo "[#]  [$bat_meshif] [ set ] meshif up"
ip link set up $bat_meshif
echo "[#]  [$bat_meshif] [ set ] meshif parameters"
batctl $bat_meshif aggregation $bat_aggregation
batctl $bat_meshif gw_mode $bat_gw_mode
batctl $bat_meshif hop_penalty $bat_hop_penalty
batctl $bat_meshif fragmentation $bat_fragmentation
batctl $bat_meshif orig_interval $bat_orig_interval
batctl $bat_meshif bonding $bat_bonding
batctl $bat_meshif bridge_loop_avoidance $bat_bridge_loop_avoidance
batctl $bat_meshif distributed_arp_table $bat_distributed_arp_table
batctl $bat_meshif network_coding $bat_network_coding
echo "[#]  [$bat_meshif] [ set ] meshif mac addr"
ip link set $bat_meshif addr $bat_meshif_mac_addr
echo "[#]  [$bat_meshif] [ set ] meshif ip addr"
ip addr add $bat_meshif_ip_addr dev $bat_meshif
echo "[#]  [$bat_meshif] [ready] meshif ready"
echo "[#]< [$bat_meshif] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$bat_init_file" ]]; then
    echo "[#]  [ mesh ] [set] client [ init ] and no default route del"
    echo "[#]  [ $bat_init_file ] - [generated] [updated]"
    echo "[#]< [ init ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $bat_init_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi
fi

# --- chmod --- #
echo "[#]> [set] chmod on [ init ]"
chmod +x "$bat_init_file"
echo "[#]< [done] [ init ] - [ OK ]"

echo "[#]- [2/3]"

# --- create b.a.t.m.a.n. updater --- #
echo "[#]> [create] [ b.a.t.m.a.n. ] [ updater ] [script] required for auto gwl bw announcements [ 3 ]"

read -p "[#]  [1/3] [set] path [ $default_bat_gwlupdater_file ]: " bat_gwlupdater_file
bat_gwlupdater_file=${bat_gwlupdater_file:-$default_bat_gwlupdater_file}

read -p "[#]  [2/3] [set] mesh interface alternative speed [ $default_bat_meshif_speed ]: " bat_meshif_speed
bat_meshif_speed=${bat_meshif_speed:-$default_bat_meshif_speed}

read -p "[#]  [3/3] [set] mesh interface sampling and sleep time in seconds [ $default_bat_sampling_time ]: " bat_sampling_time
bat_sampling_time=${bat_sampling_time:-$default_bat_sampling_time}

cat > "$bat_gwlupdater_file" <<'EOF'
#!/bin/bash
# --- b.a.t.m.a.n. gwl_updater --- #

# --- default_settings --- #
script_dir=$(dirname "$(realpath "$0")")
dir="${script_dir}"
settings_file="$script_dir/settings.conf"
source "$settings_file"

# --- sampled_values --- #
bat_rx_value=`cat $dir/$bat_meshif-rx-value`
bat_tx_value=`cat $dir/$bat_meshif-tx-value`

# --- settings --- #
echo "[#]> [settings] [ mesh ]"
echo "[#] _name   [ $bat_meshif ]"
echo "[#] _speed  [ $bat_meshif_speed ]"
echo "[#] _sample [ $bat_sampling_time ]"

# --- perform --- #
echo "[#]> [worker]"
echo "[#]  [$bat_meshif] [ sample ] link bandwidth"
echo "($bat_meshif_speed-$(vnstat -i $bat_meshif -tr $bat_sampling_time | grep rx | awk '{ if ($3 == "bit/s") { print 1 } if ($3 == "kbit/s") { print $2 } if ($3 == "Mbit/s") { print $2 * 1000 } }'))" | bc | awk -F "." '{print $1}' | tail > $dir/$bat_meshif-rx-value
sleep $bat_sampling_time
echo "[#]  [$bat_meshif] rx [ $bat_rx_value ]"
echo "($bat_meshif_speed-$(vnstat -i $bat_meshif -tr $bat_sampling_time | grep tx | awk '{ if ($3 == "bit/s") { print 1 } if ($3 == "kbit/s") { print $2 } if ($3 == "Mbit/s") { print $2 * 1000 } }'))" | bc | awk -F "." '{print $1}' | tail > $dir/$bat_meshif-tx-value
sleep $bat_sampling_time
echo "[#]  [$bat_meshif] tx [ $bat_tx_value ]"
echo "[#]  [$bat_meshif] [ set ] gwl announce bw"
batctl $bat_meshif gw_mode server $bat_rx_value/$bat_tx_value
echo "[#]< [$bat_meshif] [ update ] - [ OK ]"

EOF

# --- log_results --- #
if [[ -f "$bat_gwlupdater_file" ]]; then
    echo "[#]  [ $bat_gwlupdater_file ] - [generated] [updated]"
    echo "[#]< [ updater ] [generate] [update] - [ OK ]"
else
    echo "[#]< [ $bat_gwlupdater_file ] [generate] [update] - [ FAILED ]"
    exit 1
fi

# --- chmod --- #
echo "[#]> [set] chmod on [ updater ]"
chmod +x "$bat_gwlupdater_file"
echo "[#]< [done] [ updater ] - [ OK ]"

echo "[#]- [3/3]"

# --- write settings --- #
cat > "$settings_file" <<EOF
#!/bin/bash
# --- b.a.t.m.a.n. ---  #

# --- settings --- #
bat_meshif="$bat_meshif"
bat_meshif_mac_addr="$bat_meshif_mac_addr"
bat_meshif_ip_addr="$bat_meshif_ip_addr"
bat_routing_algo="$bat_routing_algo"
bat_aggregation="$bat_aggregation"
bat_gw_mode="$bat_gw_mode"
bat_hop_penalty="$bat_hop_penalty"
bat_fragmentation="$bat_fragmentation"
bat_orig_interval="$bat_orig_interval"
bat_bonding="$bat_bonding"
bat_bridge_loop_avoidance="$bat_bridge_loop_avoidance"
bat_distributed_arp_table="$bat_distributed_arp_table"
bat_network_coding="$bat_network_coding"

# --- updater --- #
bat_meshif_speed="$bat_meshif_speed"
bat_sampling_time="$bat_sampling_time"

# --- postrouting --- #
nat_src_addr="$nat_src_addr"
nat_outgoing_if="$nat_outgoing_if"

EOF

# --- log_results --- #
if [[ -f "$settings_file" ]]; then
    echo "[#]  [ $settings_file ] [ settings ] [generated] [updated]"
    echo "[#]< [ settings ] [generated] [updated] - [ OK ]"
else
    echo "[#]< [ $settings_file ] [ settings ] [generate] [update] - [ FAILED ]"
    exit 1
fi

echo "[#]< [done] [ settings ] [ script ] - [ OK ]"

# --- systemd --- #
read -p "[#]> [create] [ b.a.t.m.a.n. ] [systemd] service for startup - (y/n) - [n]: " response

if [[ "$response" =~ ^[Yy]$ ]]; then
    read -p "[#]  [1/2] [set] mesh interface [ init ] path [$default_bat_init_file]: " bat_init_file
bat_init_file=${bat_init_file:-$default_bat_init_file}

    read -p "[#]  [2/2] [set] service name [$default_bat_meshif].service: " bat_init_name
bat_init_name=${bat_init_name:-$default_bat_meshif}

    service_file="/etc/systemd/system/$bat_init_name.service"

    cat > "$service_file" <<EOF
[Unit]
Description=[ b.a.t.m.a.n. ] [systemd]
After=network.target

[Service]
ExecStart=/bin/bash $bat_init_file
RemainAfterExit=true
Type=oneshot
User=root

[Install]
WantedBy=multi-user.target
EOF

    echo "[#]  [ $service_file ] [generated] [updated]"

    systemctl daemon-reload
    systemctl enable "$bat_init_name"

    echo "[#]< [done] [daemon-reloaded] [systemctl enabled] - [ OK ]"

    read -p "[#]> [start] [ b.a.t.m.a.n. ] [ systemd ] service now - (y/n) - [n]: " start_response
    if [[ "$start_response" =~ ^[Yy]$ ]]; then
        systemctl start "$bat_init_name"
        echo "[#]< [done] [systemctl started] [ $bat_init_name ] [ init ] - [ OK ]"
    else
        echo "[#]< [done] [systemctl [ NOT ] started] [ $bat_init_name ] [ init ] - [ NOK ]"
        echo "[#]>>[run] [ b.a.t.m.a.n. ] [ init ]"
    fi

else
    echo "[#]< [done] [systemd service [ NOT ] created]"
    echo "[#]>>[run] [ b.a.t.m.a.n. ] [ init ]"
fi
