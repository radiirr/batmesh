# batmesh
linux, wireguard, batman, vxlan, gretap, frr, mesh, networking, bash, scripting, 

-- README --

This three [ 3 ] bash script can partly help daily challenge, when dealing with:

- wireguard
- tunneled interfaces
- b.a.t.m.a.n.

The main goal was to reduce the time while generating configurations, do some automation and create some kind of standardization.

The following packages are required:

> apt install bc bridge-utils batmand batctl frr iptables net-tools vnstat wireguard wireguard-tools

- It works between 255 hops in a single mesh network, where ospf is ptmp in default.
- Wireguard do the PtP tunneling and encryption between hosts, where vxlan encapsulated.
- Vxlan do the broadcasting interface, which is a member interface of batmand.
- B.A.T.M.A.N. do the mesh networking and maintain topology between the many hosts, where FRR do the routing.
- It also works with gretap instead of vxlan's.

A simple mesh topology with three [ 3 ] hosts looks like this:

             
         .0.0.1/24                                .0.0.2/24
     +----------------+                       +----------------+
     |      FRR-1     |                       |      FRR-2     |
     |----------------|                       |----------------|
     |+--------------+|         <PtP>         |+--------------+|
     ||     bat0     || .244.0/31   .244.1/31 ||     bat0     ||
     ||--------------||-----------------------||--------------||
     |||  vxlan_A <-01010101010101010101010101010-> vxlan_A  |||                        
     ||--------------||-----------------------||--------------||
     ||--------------||--------+     +--------||--------------||
     |||  vxlan_B <-0101010101 |     | 1010101010-> vxlan_C  ||| 
     ||--------------||----+ 0 |     | 0 +----||--------------||
     |+--------------+|    | 1 |     | 1 |    |+--------------+|
     +----------------+    | 0 |     | 0 |    +----------------+
                           | 1 |     | 1 | 
                .244.2/31  | 0 |     | 0 | .244.4/31
                    <PtP^  | 1 |     | 1 | ^PtP>
                .244.3/31  | 0 |     | 0 | .244.5/31
                           | 1 |     | 1 |
                           | 0 |     | 0 |        .0.0.3/24
                           | 1 |     | 1 |    +----------------+
                           | 0 |     | 0 |    |      FRR-3     |
                           | 1 |     | 1 |    |----------------|
                           | 0 |     | 0 |    |+--------------+|
                           | 1 |     | 1 |    ||     bat0     ||
                           | 0 |     | 0 +----||--------------||
                           | 1 |     | 1010101010-> vxlan_C  |||
                           | 0 |     +--------||--------------||
                           | 1 +--------------||--------------||
                           | 01010101010101010101-> vxlan_B  |||
                           +------------------||--------------||
                                              |+--------------+|
                                              +----------------+

### How the scripts work
---
> generate_batman.sh 
> > ./settings.conf

Generate settings for b.a.t.m.a.n. three [ 3 ] types of batman [ init ] as follow:
- [ 0 ] - gateway - nat mesh traffic - no def route del
- [ 1 ] - client - no nat - del def route
- [ 2 ] - client - no nat - no def route del

and for ./gwlupdater.sh
> [!NOTE]
> when you nat traffic into the mesh network you can nat traffic out to other networks, ie.: to internet, or other externet's, or just simple route between them, or redistribute other ospf, bgp, isis, etc...

> ./init.sh 

Which initialize batctl and ip link which can "manually" bring up the interface, set parameters, also do iptables postrouting and echo settings. 

> ./gwlupdater.sh 

Which utilize vnstat which sample interface bandwidth's, add to crontab and if batctl set to gw_mode "server" this automatically set with batctl the remaining bandwidth values which propagated through the mesh in the ogm's. 

> [ b.a.t.m.a.n. ] [systemd]

Create a one shot service type which brings up the mesh interface when system boot.

---

> generate_settings.sh
>> ./settings.conf

Generate settings which contain the prameters for the tunnel interfaces, both for wg and vxlan.

---

>  generate_additional.sh 
>> ./wg2host0.conf

This generate and copy one of three [ 3 ] types of wireguard configs as follow:
- [ 0 ] - wireguard listener config act as server
- [ 1 ] - wireguard peer config act as client with random port
- [ 2 ] - wireguard peer config act as client with static port
> [!NOTE]
> persistent keepalive commented everywhere, uncomment if need

> ./init.sh

Which initialize wg-quick which can "manually" bring up the interface and echo settings.

> ./up.sh

Which initialize vxlan with ip link add/set parameters and add tunnel interface to a batman member interface with batctl, when wg-quick brings it up as post up.
> [!NOTE]
> comment #ip route add $peer_ip_addr via $peer_ip_gw_ip dev $peer_ip_gw_dev , if static route not need to the remote host, using default route or other subnet dst's variation

> ./down.sh

Which delete peer ip route and delete vxlan interface with ip link, when wg-quick go down as post down.
> [!NOTE]
> comment #ip route del $peer_ip_addr , if not need, also batmand can forget its member interfaces when ip link deleted itself

> ./watchdog.sh

Which can challenge remote address reachability, add to crontab for periodically do the jobs, this can restart interface with wg-quick if icmp reply not seen.

> wg-quick @ wg2host0.service

Can create a service via systemd @ wg-quick 

---

#### How-to-example

1. go to, ~ cd /etc/wireguard/
2. make a dir for the batman interface, ie.: ~ mkdir bat0
3. ~ cd ./bat0/ and put the ./generate_batman.sh script into the directory and, ~ chmod +x to run
4. run ~ ./generate_batman.sh and set parameters
5. ~ cd .. back, and make a dir for the wg interface, ie.: ~ mkdir wg2host0
6. put the ./generate_settings.sh and ./generate_additional.sh scripts into the directory,
and, ~ chmod +x ./them to run
7. run ~ ./generate_settings.sh and set parameters 
8. run ~ ./generate_additional.sh and set parameters
9. add to crontab /etc/crontab
> */1 *     * * *   root  /bin/bash /etc/wireguard/bat0/gwlupdater.sh

> */1 *     * * *   root  /bin/bash /etc/wireguard/wg2host0/watchdog.sh

 set run timings as you wish. 
> [!IMPORTANT]
> run "wg genkey" at least pri/pub key required to later bring if up, than exchange pub keys, prekeys, etc...

> [!TIP]
> You can almost set all the parameters which available, all default parameters are described how those works.

##### Done, Happy routing! 

---

##### FRR-ospf-simple-example
              
    ip router-id 244.0.0.1
    !
    interface bat0
    ip ospf 1 area 0.0.0.0
    ip ospf authentication message-digest
    ip ospf dead-interval 3
    ip ospf hello-interval 1
    ip ospf message-digest-key 1 md5 verysecretkey
    ip ospf network point-to-multipoint
    exit
    !
    router ospf 1
    ospf router-id 244.0.0.1
    redistribute static
    area 0.0.0.0 authentication message-digest
    area 0.0.0.0 range 244.0.0.0/8
    exit

---
##### All tested on, with
- debian 6.1.0-21-amd64
- debian 6.11.10+bpo-amd64
- frr version 8.4.4
- frr version 10.2.1
- [batman-adv: 2022.2]
- batctl debian-2023.0-1 [batman-adv: 2024.2]
- batctl 2024.4 [batman-adv: 2024.4]
