# main.py -- put your code here!
from microdot_asyncio import Microdot, redirect, Response, send_file
import asyncio
import ujson
import json
from soilsensor import Soilsensor
from pins import PINModule
from pump import Pump
from boot import ESP32WiFiManager 
app = Microdot()
req = Microdot()
Response.default_content_type = 'text/html'

soil = Soilsensor(39)
connect = ESP32WiFiManager()


@app.route('/')
async def index(request):
    return("Smart Irrigtion System")

@app.route("/cancel")
async def hello(request):
    asyncio.CancelledError
    print("cancelled")
    return "OK"

@app.route('/api/soil',methods=['GET'])
async def get_soil(request):
    try:
        response_data = {"humidity":int(soil.check_moisture()),"IP":connect.ip}
        return response_data
#         return json.dumps(
#             {
#             "humidity":int(soil.check_moisture())
#             }
#             )
    except Exception as e:
        response_data = {"status": "error", "message": str(e)}
        return json.dumps(response_data), 400  # Return 400 Bad Request on error
#---set Direct-----------------------------------------------------------#

@app.route('/api/run', methods=['POST'])
async def button_pump(request):
    print("Receive Button Pump Request!")
    pump = Pump()
    state = pump.pin_pump.get_value()
    if state == 0:
        pump.pin_pump.toggle()
        return "OK Pump Off"
    elif state == 1:
        pump.pin_pump.toggle()
        return "OK Pump On"
    
@app.route('/api/pin', methods=['POST'])
async def pin(request):
    try:
        data = request.json
        # You can process the data here and return a response
        response_data = {"data": data, "status": "success"}
        #Access data
        access_data = response_data["data"]
        #loop at access_data
        for key, value in access_data.items():
            #---set Connection-----------------------------------------------------------#        
            if "ssid" in key:
                with open('/data.json', 'w') as f:
                    ujson.dump(data, f)
                connect = ESP32WiFiManager()
                connect.connection()
                return {"ifconfig:": connect.ip}
            #---set Auto-----------------------------------------------------------#        
            elif key == "auto" and value ==True:
                pump = Pump()
                pump.value = value
                pump.set_auto()
             #---set Humidity-----------------------------------------------------------#        
            elif key == "humidity" and value >= 1:
                pump = Pump()
                pump.value = value
                pump.set_humidity()
            #---set Timer-----------------------------------------------------------#        
            elif key == "timer" and value >= 1:
                pump = Pump()
                pump.value = value
                pump.set_timer()  
            #----error response-----------------------------------------------------------#         
            else:
                err = {"status": "error", "message": "Key Must one off these {ssid$pwd, auto, humidity, timer} and value True for auto and number for other"}
                print (err)
                return err
        return (response_data)
    #----error server-----------------------------------------------------------#
    except Exception as e:
        response_data = {"status": "error", "message": str(e)}
        return json.dumps(response_data), 400  # Return 400 Bad Request on error
  
  
@app.route('/api/pins', methods=['POST'])
async def pins(request):
    try:
        data = request.json
        # You can process the data here and return a response
        response_data = {"status": "success", "data": data}
        #Access data
        access_data = response_data["data"]
        #loop at access_data
        for key, value in access_data.items():
            if key == "pin" and value in range(0,39):
                print(response_data)
                pin = PINModule(value)
                # Get the PIN state
                state = pin.get_value()
                print("PIN State:", state)
                if state == 1:
                    # Turn the PIN on
                    pin.toggle()
                    return json.dumps(response_data)
                elif state == 0:
                    pin.toggle()
                    return {'data': {'pin': 'Off'}, 'status': 'success'}
            else:
                err = {"status": "error", "message": "Key Must a 'pin' and value in range(0-39)"}
                print (err)
                return err
        
        return json.dumps(response_data)
    except Exception as e:
        response_data = {"status": "error", "message": str(e)}
        return json.dumps(response_data), 400  # Return 400 Bad Request on error
    
@app.route('/shutdown')
def shutdown(request):
    request.app.shutdown()
    return("The server is shutting down...")

async def main():
    await app.start_server(debug=True)

asyncio.run(main())

# if __name__ == '__main__':
#     app.run(debug=True)

