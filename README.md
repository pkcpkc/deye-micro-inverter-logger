# deye-micro-inverter-logger

Logs the current watt produced by the inverter deye sun600g3-eu-230 Micro Inverter (e.g. https://www.juskys.de/balkonkraftwerk-mit-2-solarmodulen-wechselrichter-ac-kabel.html) by reading from the web interface.

## Usage

  `sh solar.sh -i <IP> -u <username> -p <password>[ -d <delay>][ -h]`

### Parameters:

`-i` IP address of the inverter  
`-u` Username of the web interface  
`-p` Password of the web interface  
`-d` Delay between measurements in seconds; default is 60s  
`-h` Prints csv titles (&lt;date>,webdata_now_p,webdata_today_e,webdata_total_e), omits them per default  

## Example

`sh solar.sh -i 192.168.178.55 -u admin -p admin -d 1 -h`

### Example output

`date,webdata_now_p,webdata_today_e,webdata_total_e`  
`2023-03-27T08:39:06,0,0.0,0.1`  

**Columns**

- `date` = Date
- `webdata_now_p` = Current power in Watt
- `webdata_today_e` = Yield today in kWh
- `webdata_total_e` = Total yield in kWh

## Recommendation

After updating firmware to at least 1.53 (security patches), turn of internet traffic of the DEYE micro inverter in your router and just read data via the local network and this script.
This avoids any data beeing send to DEYE, and does not DEYE require to run servers for data and mobile app, which themselves consume a lot of energy as well!