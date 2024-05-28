from machine import Pin, ADC
from time import sleep
import json
class Soilsensor:
    """This will represent our SOIL"""
    
    def __init__(self, pinNumber):
        self.pinNumber = pinNumber
        self.soil_pin = ADC(Pin(self.pinNumber, Pin.IN))
        self.min_moisture = 0
        self.max_moisture = 4095
        self.atten = self.soil_pin.atten(ADC.ATTN_11DB)  # Full range: 3.3v
        self.width = self.soil_pin.width(ADC.WIDTH_12BIT)  # range 0 to 4095
    
    def check_moisture(self):
        try:
            moisture_value = self.soil_pin.read()
            sleep(0.5)
            if moisture_value is not None:
                min_moisture = self.min_moisture
                max_moisture = self.max_moisture
                z = (max_moisture - moisture_value) * 100 / (max_moisture - min_moisture)
                humidity = str('{:.0f}'.format(z))
                return humidity
        except Exception as e:
            response_data = {"status": "error", "message": str(e)}
            return json.dumps(response_data), 400  # Return 400 Bad Request on error



