__author__ = 'jonathandeehan'
#Import serial and time lib
import serial, time, requests, json

#Open the serial connection
ser = serial.Serial("/dev/ttyUSB0", 9600, timeout=0.5)

#Firebase URL Connection & authentication token
firebase_url = '<InsertFirebaseURL>'
auth_token =  "<SecretTokenCode>"

#Ensures we don't make multiple posts in a given minute
postRecordCounter = 0

#Previous temperature recorded
previousTemp = ""

#Infinite loop for retrieving data from Arduino XBee
while True:
        incomingData = ser.readline().strip()
        if(incomingData != ""):
                #Current time and date
                currentTime = time.strftime('%H:%M')
                currentMinute = time.strftime('%M')
                currentDate = time.strftime('%Y/%m/%d')
                currentDateToSend = time.strftime('%d/%m/%Y')
                if currentMinute == "01" or currentMinute == "31":
                        postRecordCounter = 0
                #Create record of data
                dataToSend = {'date':currentDateToSend,'time':currentTime,'value':incomingData}
                #Temperature is received
                if(postRecordCounter == 0):
                        roundedTemperature = incomingData[:2]
                        if roundedTemperature != previousTemp :
                                newDataToSend = {'date':currentDateToSend,'time':currentTime,'value':roundedTemperature}
                                result = requests.post(firebase_url + '/liveTemperature.json' + '?auth=' + auth_token, data=json.dumps(newDataToSend))
                                previousTemp = roundedTemperature
                                print newDataToSend
                        if currentMinute == "00" or currentMinute == "30":
                                try:
                                        print dataToSend
                                        #insert record
                                        result = requests.post(firebase_url + '/' + currentDate + '/temperature.json' + '?auth=' + auth_token, data=json.dump$
                                        postRecordCounter = 1
                                except IOError:
                                        print('Error!')