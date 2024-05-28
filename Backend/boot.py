# boot.py -- run on boot-up
# boot.py -- run on boot-up

import network, utime
from pins import PINModule
import time
import ujson


# Replace the following with your WIFI Credentials
#SSID = "LAN-Ibrahim"
#SSI_PASSWORD = "ffiiffii"
'''
class Connect:
    
    def __init__(self):
        self.ssid = None
        self.pwd = None
        self.ip = None
        self.ssid_AP = "ESP32-AP"  # SSID of the access point
        self.password_AP = "esp32123"  # Password for the access point
        self.ip_address_AP = "192.168.4.1"  # IP address for the access point
        self.gateway_address_AP = "192.168.4.1" 
        self.subnet_mask_AP = "255.255.255.0"  # Subnet mask for the access point
        self.dns_address_AP = "8.8.8.8" 
        
    def do_connect(self):
        try:
            sta_if = network.WLAN(network.STA_IF)
            if not sta_if.isconnected():
                print('connecting to network...')
                sta_if.active(True)
                sta_if.connect(self.ssid, self.pwd)
                #self.create_access_point()
                while not sta_if.isconnected():
                    #print ("invalid ssid or password")
                    time.sleep(1)
            #if sta_if.isconnected():
            print('Connected! Network config:', sta_if.ifconfig())
            station_led = PINModule(2)
            station_led.toggle()
            self.ip = sta_if.ifconfig()
            
        
        except Exception as e:
            return e
        
    # Function to create an access point (AP)
    def create_access_point(self):
        # Create access point interface
        ap = network.WLAN(network.AP_IF)
        ap.active(True)
        ap.config(essid=self.ssid_AP, password=self.password_AP)
        ap.ifconfig((self.ip_address_AP, self.subnet_mask_AP, self.gateway_address_AP,self.dns_address_AP))

        print("Access point created with SSID:", self.ssid_AP)
        print("IP address:", self.ip_address_AP)
        AP_led = PINModule(32)
        AP_led.toggle()
        
    def con(self):
        with open('/data.json', 'r') as f:
            loaded_data = ujson.load(f)
            if loaded_data['ssid'] == "":
                print('No ssid!')
            else:
                self.ssid = loaded_data['ssid']
                self.pwd = loaded_data['pwd']
                self.do_connect()
            
                
AP = Connect()
#AP.create_access_point()
#AP.con()
'''


class ESP32WiFiManager:
    def __init__(self):
        self.ap_ssid = "ESP32-AP"
        self.ap_password = "ffiiffii"
        self.wifi_ssid = None
        self.wifi_password = None

        # Initialize AP and STA interfaces
        self.ap = network.WLAN(network.AP_IF)
        self.sta = network.WLAN(network.STA_IF)
        self.ip = self.sta.ifconfig()[0]
    def create_access_point(self):
        try:
            # Activate AP interface
            self.ap.active(True)
            self.ap.config(essid=self.ap_ssid, password=self.ap_password)
            self.ap.ifconfig(('192.168.44.1', '255.255.255.0', '192.168.44.1','8.8.8.8'))
            print("Access Point created")
            print("AP-IP address:", self.ap.ifconfig()[0])
            led_ap = PINModule(32)
            led_ap.toggle()
        except Exception as e:
            print("Error creating Access Point:", e)

    def connect_to_wifi(self):
        try:
            # Activate STA interface
            self.sta.active(True)
            self.sta.connect(self.wifi_ssid, self.wifi_password)
            print("Connecting to Wi-Fi...")

            # Wait until connected or timeout
            timeout = 7
            start_time = time.time()
            while not self.sta.isconnected() and time.time() - start_time < timeout:
                time.sleep(1)

            if self.sta.isconnected():
                print("Wi-Fi connected")
                led_wifi = PINModule(2)
                led_wifi.toggle()
                print("IP Address:", self.sta.ifconfig()[0])
            else:
                print("Failed to connect to Wi-Fi")

        except Exception as e:
            print("Error connecting to Wi-Fi:", e)
            
    def connection(self):
        with open('/data.json', 'r') as f:
            loaded_data = ujson.load(f)
            if loaded_data['ssid'] == "":
                print('No ssid!')
            else:
                self.wifi_ssid = loaded_data['ssid']
                self.wifi_password = loaded_data['pwd']
                self.connect_to_wifi()


# Example usage:
if __name__ == "__main__":
    # Configure access point and Wi-Fi credentials


    # Create ESP32WiFiManager instance
    wifi_manager = ESP32WiFiManager()

    # Create Access Point
    wifi_manager.create_access_point()

    # Connect to Wi-Fi
    wifi_manager.connection()



        
