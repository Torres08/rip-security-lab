is **Master in International Cybersecurity** UNIVERSIDAD **and Cyberintelligence** DEGRANADA **_-----------------------------------------------------------------------------_** 



<!-- Start of picture text -->
arOQus<br>European University Alliance<br><!-- End of picture text -->

# **_- Network Security -_** 

## **Practice 2. Route Poisoning and Manipulation** 

### **1. Objectives** 

The overall purpose of this practice is to develop a practical understanding of routing security and demonstrate the importance of monitoring, filtering, segmentation, and defense-in-depth mechanisms in protecting network infrastructure. 

With this aim, the practice provide students with hands-on experience in configuring the _Routing Information Protocol_ (RIP), analyzing routing tables and protocol updates, and observing how manipulated routing information can affect the control plane and data plane. 

For that, a controlled route manipulation scenario in an isolated _Docker_ -based network environment using _FRRouting_ is going to be considered. 

### **2. Material** 

As previously specified, the following main infrastructure is recommended to develop the practice: 

- Linux machines. 

- _Docker_ , a tool that packages an application and everything it needs into a single lightweight box called a container so it runs the same on any computer. 

- _FRRouting_ , a popular, open-source Internet routing protocol suite for Linux and Unix platforms. 

### **3. Fundamentals** 

Given the usual finite nature of network infrastructure and resources, _network routing_ is a fundamental service responsible for determining the path to be followed by the packets forwarded from a source network to a destination network (see Figure 1). Routers exchange routing information and use this information to build and maintain routing tables, which determine the next hop for each reachable destination (Figure 2). 

Routing protocols can be classified into different categories, including distance-vector, link-state, and path-vector protocols. In this practice, the focus is on the _Routing Information Protocol_ (RIP), a distance-vector routing protocol that uses hop count as its routing metric. In RIPv2, routers periodically exchange routing updates using UDP port 520, allowing neighboring routers to learn about available networks and select routes based on the lowest metric. Although RIP is relatively simple and has largely been replaced by more advanced routing protocols in modern networks, its straightforward operation makes it particularly useful for studying routing behavior and security vulnerabilities. 

In the above context, _route poisoning_ is a mechanism associated with distance-vector routing protocols such as RIP that is used to indicate that a previously reachable network has become unreachable. In RIP, a metric of 16 represents infinity, meaning that the destination 

1 

_MICaC - Network Security, 2026/2027_ 



<!-- Start of picture text -->
bis<br>UNIVERSIDAD<br>DEGRANADA<br><!-- End of picture text -->

### **Master in International Cybersecurity and Cyberintelligence** 



<!-- Start of picture text -->
arxaus<br>Buropean University Alliance<br><!-- End of picture text -->

# **_- Network Security -_** 



<!-- Start of picture text -->
From routing information to packet forwarding<br>Control plane RIP UPDATE<br>Routing information is received<br>RIP ROUTING PROCESS<br>Metric and route selection<br>ROUTING / FORWARDING TABLE<br>Selected next hop is installed<br>Data plane DATA PLANE<br>Packets follow the selected path<br>Figure 1. Relationship between RIP control-plane information and data-plane forwarding.<br><!-- End of picture text -->

network is considered unreachable. When a router detects that a route is no longer available, it can advertise that route with this metric so that neighboring routers invalidate the route and update their routing tables. However, the trust-based nature of routing updates also creates opportunities for malicious route manipulation. An unauthorized or compromised router may inject false routing information, causing legitimate routers to select an incorrect path, lose connectivity to a destination, or potentially create routing loops. 

This practice therefore want to distinguish between legitimate route poisoning, which is a protocol mechanism for route invalidation, and malicious route manipulation, in which false routing information is deliberately introduced to influence routing decisions. 



<!-- Start of picture text -->
C 192.168.1.0/24 192.168.1.1Go/O  - 192.168.2.1GO/1 —192.168.2.0/24 - 10.0.0.0/24 fl<br>Pct R1 R2 Pc2<br>192.168.1.10/24 192.168.2.2 10.0.0.50/24<br>Routing Table on R1 How it works<br>Destination Network Subnet Mask Next Hop Interface @ Jdestinationpacket arrivesIP 10.0.0.50.at R1 with<br>192.168.1.0 255.255.255.0 Directly connected Go/0 @ 2 credits outing table and finds:<br>192.168.2.0 255.255.2550 _Directly connected con 10.0.0.0 /24 — 192.168.2.2 (GO/1)<br>10.0.0.0 255.255.255.0 192.168.2.2 GO/1 C3] R1192.168.2.2 forwardsusingthe packetinterfaceto GO/1.<br>0.0.0.0 0.0.0.0 192.168.2.2 GO/1<br>Figure 2. Routing table for R1 in an example topology.<br><!-- End of picture text -->

--------------------------------------- _MICaC - Network Security, 2026/2027_ 

2 



<!-- Start of picture text -->
UNIVERSIDAD<br>DEGRANADA<br><!-- End of picture text -->

### **Master in International Cybersecurity and Cyberintelligence** 



<!-- Start of picture text -->
European University Alliance<br><!-- End of picture text -->

# **_- Network Security -_** 



<!-- Start of picture text -->
Legitimate destination network IP Addressing Plan<br>10.10.10.0/24 Device Interface/ Network IP Address<br>Ri-mfe-Ri raRt (0R2)(oR) 1721621730721632290<br>raroroare|(Legitimate)* a = i fens Ra(oR(003) 17216237907<br>172.16.12.0/30 (RIP outer) (RP router) (Attacker) aa zu<br>172.16.23.0/30 onl om 172.16.34.0/30 -m | ten 172.16.34.1/30<br>hmsss21 as2a iaie1 17236232 wisi 17236342 anaes tictea aeaae<br>eee RUN RB(todientLAN) 1030301724<br>lent lent WIC 10302010724<br>tent network | © Preverdntnae<br>‘soon peer ma<br>303030024 stacker ote<br>HH = ink attache<br>SZ dnrewor<br>Figure 3. Scenario to be deployed for the lab.<br><!-- End of picture text -->

### **4. Practical realization** 

Building on the concepts introduced so far, a practical RIPv2-based network environment will be here proposed to analyze and monitor routing related information. The experiment demonstrates that a routing protocol can become a security vulnerability when routing updates are implicitly trusted. 

Particular attention should be given to the distinction between: 

- <u>Route poisoning: a legitimate RIP mechanism used to announce that a route is unreachable.</u> 

- <u>Malicious route manipulation: the deliberate introduction of false routing information by an</u> unauthorized or compromised router. 

This distinction is fundamental to understanding the security implications of distance-vector routing protocols. 

### **4.1. Scenario** 

Figure 3 shows the practical scenario to be deployed for the lab. It consists of an isolated network environment implemented with _Docker_ containers running _FRRouting_ . The elements composing the topology are: 

- R1 acts as the legitimate router advertising the destination network 10.10.10.0/24. 

- R2 and R3 operate as intermediate RIP routers that propagate the routing information toward the client network 10.30.30.0/24. 

- R4 represents a controlled, potentially malicious router connected to R3 and is used to introduce false routing information for the legitimate destination network. 

During the experiment, students will first establish normal RIP operation and verify the expected path Client→R3→R2→R1. They then will introduce the malicious routing information and observe changes in the routing table and packet-forwarding path. Finally, a controlled failure of the legitimate route is used to demonstrate RIP's formal route poisoning mechanism, in which an 

3 

_MICaC - Network Security, 2026/2027_ 



<!-- Start of picture text -->
me<br>UNIVERSIDAD<br>DEGRANADA<br><!-- End of picture text -->

### **Master in International Cybersecurity and Cyberintelligence** 



<!-- Start of picture text -->
arwaus<br>European University Alliance<br><!-- End of picture text -->

# **_- Network Security -_** 

unreachable route is advertised with metric 16 (infinity). The experiment will conclude by applying routing security controls and evaluating whether the unauthorized routing information can be prevented or mitigated. 

### **4.2. Configuration** 

### **_Docker_** 

For the RIP laboratory, it is recommended using _Docker Compose_ rather than starting each container manually. This allows to make the topology reproducible and much easier for students to deploy. 

To install and enable _Docker_ and the _Compose_ plugin execute: 

_> sudo apt update_ 

_> sudo apt install docker.io docker-compose-plugin_ 

- _sudo systemctl enable --now docker_ 

Then create the following structure: 

_rip-security-lab/ ├── docker-compose.yml ├── r1/ │   ├── daemons │   └── frr.conf ├── r2/ │   ├── daemons │   └── frr.conf ├── r3/ │   ├── daemons │   └── frr.conf ├── r4/ │   ├── daemons │   └── frr.conf └── client/_ 

Create the _Docker Compose_ topology ( _docker-compose.yml_ ): 

_services:_ 

_r1: image: quay.io/frrouting/frr:latest container_name: rip-r1 privileged: true volumes:_ --------------------------------------- 

_MICaC - Network Security, 2026/2027_ 

4 

is **Master in International Cybersecurity** UNIVERSIDAD **and Cyberintelligence** DEGRANADA **_-----------------------------------------------------------------------------_** 



<!-- Start of picture text -->
arOQus<br>European University Alliance<br><!-- End of picture text -->

**_- Network Security -_** 

_- ./r1/daemons:/etc/frr/daemons:ro - ./r1/frr.conf:/etc/frr/frr.conf:ro networks: r1_r2: ipv4_address: 172.16.12.1 r1_lan: ipv4_address: 10.10.10.1 r2: image: quay.io/frrouting/frr:latest container_name: rip-r2 privileged: true volumes: - ./r2/daemons:/etc/frr/daemons:ro - ./r2/frr.conf:/etc/frr/frr.conf:ro networks: r1_r2: ipv4_address: 172.16.12.2 r2_r3: ipv4_address: 172.16.23.1 r3: image: quay.io/frrouting/frr:latest container_name: rip-r3 privileged: true volumes: - ./r3/daemons:/etc/frr/daemons:ro - ./r3/frr.conf:/etc/frr/frr.conf:ro networks: r2_r3: ipv4_address: 172.16.23.2 r3_r4: ipv4_address: 172.16.34.1 client_lan: ipv4_address: 10.30.30.1 r4: image: quay.io/frrouting/frr:latest container_name: rip-r4 privileged: true volumes: - ./r4/daemons:/etc/frr/daemons:ro - ./r4/frr.conf:/etc/frr/frr.conf:ro networks: r3_r4:_ 

--------------------------------------- _MICaC - Network Security, 2026/2027_ 

5 

# me **Master in International Cybersecurity** UNIVERSIDAD **and Cyberintelligence** DEGRANADA **_----------------------------------------------------------------------------- Network Security -_** 



<!-- Start of picture text -->
arwaus<br>European University Alliance<br><!-- End of picture text -->

_ipv4_address: 172.16.34.2 client: image: alpine:latest container_name: rip-client command: ["sh", "-c", "sleep infinity"] networks: client_lan: ipv4_address: 10.30.30.10 networks: r1_r2: ipam: config: - subnet: 172.16.12.0/30 r2_r3: ipam: config: - subnet: 172.16.23.0/30 r3_r4: ipam: config: - subnet: 172.16.34.0/30 r1_lan: ipam: config: - subnet: 10.10.10.0/24 client_lan: ipam: config: - subnet: 10.30.30.0/24_ 

### **_FRRouting_** 

The previous use of the line _privileged: true_ is intentional because _FRR_ needs sufficient network privileges to manipulate interfaces and routing tables inside the containers. 

For each router, we need to create a _deamons_ file. For example, for R1: 

6 

_MICaC - Network Security, 2026/2027_ 

# is **Master in International Cybersecurity** UNIVERSIDAD **and Cyberintelligence** DEGRANADA **_----------------------------------------------------------------------------- Network Security -_** 



<!-- Start of picture text -->
arOQus<br>European University Alliance<br><!-- End of picture text -->

_> rip-security-lab/r1/daemons zebra=yes ripd=yes_ 

According to the specifications provided in Figure 3, the configuration of R2 through the file _r2/frr.conf_ is as follows: 

_frr defaults traditional hostname R2 log stdout_ 

_router rip version 2 network 172.16.12.0/30 network 172.16.23.0/30_ 

The rest of routers and elements in the scenario should be configured similarly. 

### **4.3. Deployment** 

From the _rip-security-lab_ directory execute: 

_> docker compose up -d_ 

The existence of the containers and the _Compose_ status can be then checked: 

_> docker ps_ 

_> docker compose ps_ 

The rest of the exercise is organized into four sequential phases. Each phase has a specific purpose and builds upon the results obtained in the previous one. Students should record the relevant routing tables, connectivity tests, RIP messages, and observations at each stage. 

### **_Phase 1: Normal network operation_** 

The first phase establishes the normal operating conditions of the network. The _Docker_ environment is deployed with four _FRRouting_ routers (R1, R2, R3, and R4) and one client. R1 acts as the legitimate origin of the destination network 10.10.10.0/24, while R2 and R3 provide connectivity between R1 and the client network 10.30.30.0/24. Initially, only R1, R2, and R3 participate in the legitimate RIP routing domain. RIPv2 is configured on the appropriate interfaces, and the routers exchange routing information normally. 

The expected path is:  Client→R3→R2→R1→10.10.10.0/24. Students must verify the baseline operation using: 

_> show ip route_ 

_> show ip protocols_ 

_MICaC - Network Security, 2026/2027_ 

7 



<!-- Start of picture text -->
me<br>UNIVERSIDAD<br>DEGRANADA<br><!-- End of picture text -->

### **Master in International Cybersecurity and Cyberintelligence** 



<!-- Start of picture text -->
arwaus<br>European University Alliance<br><!-- End of picture text -->

# **_- Network Security -_** 

And from the client: _> ping 10.10.10.1 > traceroute 10.10.10.1_ 

RIP traffic can also be captured using: 

_> tcpdump -n -i any udp port 520_ 

<u>At the end of this phase, students should confirm that the destination network is reachable and that the routing tables contain the expected RIP-learned route. These results constitute the baseline for</u> comparison with the subsequent phases. 

### **_Phase 2: Malicious route manipulation_** 

In the second phase, R4 is introduced as a controlled malicious router. R4 is connected to R3 through the 172.16.34.0/30 network and is configured to participate in the experimental RIP environment. 

The objective of this phase is to demonstrate the security problem associated with trusting routing information received from an unauthorized or untrusted router. R4 introduces false routing information concerning the legitimate destination network 10.10.10.0/24. 

Students monitor R3 while the manipulated routing information is introduced: 

_> show ip route 10.10.10.0/24_ 

RIP traffic should simultaneously be captured to identify the routing update generated by the controlled attacker. 

Students must determine: 

- <u>Whether R3 receives the false routing information.</u> 

- <u>What metric is associated with the advertised route.</u> 

- <u>Whether R3 changes its preferred route.</u> 

- <u>Whether the forwarding path changes.</u> 

- <u>Whether communication with the destination network is affected.</u> 

- <u>What security consequences result from accepting unauthorized routing information.</u> 

### **_Phase 3: Route poisoning and network failure_** 

The third phase focuses specifically on the RIP route-poisoning mechanism. Unlike the previous phase, which demonstrates malicious route manipulation, this phase demonstrates the legitimate protocol mechanism used by RIP to indicate that a route is no longer reachable. 

The experiment begins with the network operating normally: R1→R2→R3→Client. A controlled failure is then introduced in the legitimate R1–R2 path. For example, the corresponding interface can be temporarily disabled. 

8 

_MICaC - Network Security, 2026/2027_ 

# me **Master in International Cybersecurity** UNIVERSIDAD **and Cyberintelligence** DEGRANADA **_-----------------------------------------------------------------------------_** 



<!-- Start of picture text -->
arxaus<br>Buropean University Alance<br><!-- End of picture text -->

# **_- Network Security -_** 

The students will observe how the failure propagates through the routing domain. RIP uses a metric of 16, known as infinity, to indicate that a destination is unreachable. The poisoned route is propagated to neighboring routers, which subsequently invalidate the route. The expected sequence is: 

_Normal route ↓ R1–R2 link failure ↓ Route becomes unreachable ↓ RIP advertises metric 16 ↓ Neighbor receives poisoned route ↓ Route is invalidated ↓ Routing table converges_ 

<u>Students should record the routing table before, during, and after the failure and capture the corresponding RIP updates.</u> 

### **_Phase 4: Mitigation and security evaluation_** 

The final phase introduces security controls intended to reduce the possibility of unauthorized routing information being accepted by the network. 

Students will configure appropriate controls, such as: 

- Restricting RIP to trusted interfaces. 

- Using passive interfaces where appropriate. 

- Applying routing or interface filtering. 

- Segmenting the routing infrastructure. 

- Controlling which devices are permitted to participate in the routing protocol. 

- Monitoring unexpected RIP updates. 

- Applying authentication mechanisms where supported and appropriate. 

<u>After implementing some of the controls, the malicious route-manipulation experiment from Phase 2 is repeated. Students should compare the results with those obtained before mitigation, focusing</u> 

<u>on:</u> 

_BEFORE MITIGATION ↓ False RIP information ↓ Route may be accepted ↓ Traffic/path affected_ 

9 

_MICaC - Network Security, 2026/2027_ 



<!-- Start of picture text -->
me<br>UNIVERSIDAD<br>DEGRANADA<br><!-- End of picture text -->

### **Master in International Cybersecurity and Cyberintelligence** 



<!-- Start of picture text -->
arwaus<br>pesca aor Dessie<br><!-- End of picture text -->

# **_- Network Security -_** 

_AFTER MITIGATION ↓ False RIP information ↓ Update restricted ↓ Legitimate route maintained_ 

<u>The effectiveness of each control should be evaluated based on the routing table, RIP traffic, connectivity, and forwarding path.</u> 

10 

_MICaC - Network Security, 2026/2027_ 

