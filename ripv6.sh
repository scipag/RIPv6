#!/bin/bash
# -----
# Name: RIPv6
# Autor: Mick Schneider (misc@scip.ch)
# Date: 27-05-2016
# Version: 0.2.3
# -----

# -----
# Variables
# -----
count=0
cmd_ip="/sbin/ip"
interface="ens33"
network="2001:470:26:12b"
gateway="2001:470:26:12b::1"
sleeptime="30s"

# -----
# Generate Random Address
# Thx to Vladislav V. Prodan [https://gist.github.com/click0/939739]
# -----
GenerateAddress() {
  array=( 1 2 3 4 5 6 7 8 9 0 a b c d e f )
  a=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
  b=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
  c=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
  d=${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}${array[$RANDOM%16]}
  echo $network:$a:$b:$c:$d
}

# -----
# Run IPv6-Address-Loop
# -----
while [ 0=1 ]
do
  ip1=$(GenerateAddress)
  echo "[+] add ip1 $ip1"
  $cmd_ip -6 addr add $ip1/64 dev $interface
  if [[ $count == 0 ]]; then
    echo "[*] set default route"
    $cmd_ip -6 route add default via $gateway dev $interface
  fi
  if [[ $count > 0 ]]; then
    echo "[-] del ip2 $ip2"
    $cmd_ip -6 addr del $ip2/64 dev $interface
  fi
  sleep $sleeptime

  ip2=$(GenerateAddress)
  echo "[+] add ip2 $ip2"
  $cmd_ip -6 addr add $ip2/64 dev $interface
  if [[ $count > 0 ]]; then
    echo "[-] del ip3 $ip3"
    $cmd_ip -6 addr del $ip3/64 dev $interface
  fi
  sleep $sleeptime

  ip3=$(GenerateAddress)
  echo "[+] add ip3 $ip3"
  $cmd_ip -6 addr add $ip3/64 dev $interface
  echo "[-] del ip1 $ip1"
  $cmd_ip -6 addr del $ip1/64 dev $interface
  ((count++))
  sleep $sleeptime
done
