from pins import PINModule
import time
from soilsensor import Soilsensor

#led2 = LEDModule(2)

class Pump:
    def __init__(self):
        self.name = "PUMP"
        self.pin_pump = PINModule(23)
        self.pin_humidity = Soilsensor(39)
        self.value = None
        
    def __str__(self, name):
        return self.name
    
    def set_auto(self):
        while True:
            soil = int(self.pin_humidity.check_moisture())
            state = self.pin_pump.get_value()
            #print(soil)
            if (state ==1 and soil <= 49):
                self.pin_pump.toggle()
               
            if (state ==0 and soil >= 50):
                self.pin_pump.toggle()  
                return  
                
    def set_humidity(self):
        humidity = self.value
        #print(humidity)
        while True:
            soil = int(self.pin_humidity.check_moisture())
            state = self.pin_pump.get_value()
            #print(soil)
            if (state ==1 and soil <= humidity):
                self.pin_pump.toggle()
                
            if (state ==0 and soil >= humidity):
                self.pin_pump.toggle()  
                return       
    def set_timer(self):
        init = 0
        while init < int(self.value):
            state = self.pin_pump.get_value()
            if (state ==1):
                self.pin_pump.toggle()
            init += 1
            time.sleep(1)
            #print(init)
            if (state ==0 and init >= int(self.value)):
                self.pin_pump.toggle()
                return       
                