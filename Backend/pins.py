from machine import Pin


class PINModule:
    """This will represent our LED"""
    
    def __init__(self, pinNumber):
        self.pinNumber = pinNumber
        self.led_pin = Pin(self.pinNumber, Pin.OUT)
        
    def get_value(self):
        return self.led_pin.value()
    
    def toggle(self):
        self.led_pin.value(not self.get_value())
    
    def led_on(self):
        self.led_pin.value(1)  # Turns the LED on

    def led_off(self):
        self.led_pin.value(0)  # Turns the LED off
