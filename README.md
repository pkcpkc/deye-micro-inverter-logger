# deye-micro-inverter-logger

Logs the current watt produced by the inverter deye sun600g3-eu-230 Micro Inverter (e.g. https://www.juskys.de/balkonkraftwerk-mit-2-solarmodulen-wechselrichter-ac-kabel.html) by reading from the web interface.

## Usage
  `sh solar.sh -i <IP> -u <username> -p <password>[ -d <delay>][ -h]`

### Parameters:

`-i` IP address of the inverter  
`-u` Username of the web interface  
`-p` Password of the web interface  
`-d` Delay between measurements in seconds; default is 5s  
`-h` Prints csv titles (&lt;date>,webdata_now_p,webdata_today_e,webdata_total_e), omits them per default  

## Example

`sh solar.sh -i 192.168.178.55 -u admin -p admin -d 1`
