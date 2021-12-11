# INTRODUCTION
Weather forecasting is the application of science and technology to predict the state of the atmosphere for a given location. Ancient weather forecasting methods usually relied on observed patterns of events, also termed pattern recognition. For example, it might be observed that if the sunset was particularly red, the following day often brought fair weather. However, not all of these predictions prove reliable. Here this system will predict weather based on parameters such as temperature, humidity, wind speed, wind direction and rainfall value. 
We are connecting the IoT sensors and collect the following value in Google Sheet.
•	Wind Direction.
•	Wind Speed.
•	Atmospheric Temperature
•	Atmospheric Pressure
•	rainfall value
After this take Historical data with this and we make Prediction Machine Learning Model to predict the mentioned values. Later on we implement this ML Model with Time Series analysis for predicting the weather for continuous time. As a ML Model we use SVM (support vector machine) Algorithm. 
We also used other Machine Learning techniques to check the Model Accuracy and performance. We only used that Algorithm that best fit in our ML Model.

# Application:
* Agriculture
* Sports
* Tourist place
* Air Traffic
* Marine and Forestry
* Manufacturing Industries at Cloudy side

# ADVANTAGE
* Anyone can easily find out Weather condition by using this system.
* This Model or System helps to predict the weather of Tourist place. So that management team takes decision about the tourist.
* This system also helpful to effective control of the Sports. 
* This system can be used in Air Traffic such as flight , 
* As we see crops of farmer destroy usually due to high rainfall, storm etc, through this system so farmer update itself to prevent the crops. 
* In Marine and Forestry this system is very helpful. 
* Military, and Navy also take advantage of this system.

# DISADVANTAGE
* Previous data is required by the system to forecast weather.
* Quality of Hardware also big issue.

# HARDWARE AND SOFTWARE TO BE USED
## HARDWARE:
1.	Node MCU
2.	Rainfall Sensor
3.	Wind Speed and Wind direction Sensor
4.	Temperature Sensor
5.	Atmospheric Pressure Sensor
6.	Micro USB Cable
7.	Prototyping board (Bread board)
## SOFTWARE & LANGUAGE:
1.	Arduino  IDE, RStudio
2.	R, Embedded C 

# CONCLUSION
We try to convert this project into Industrial product & individual product that anyone can buy this product for their organization to update the about weather in this digital transformation era. We also think to integrate the image processing based weather forecast technique that traditionally used by weatherist now days with Machine Learning based Model. By integrating both techniques we make low cost, reliable, accurate and decision based product that offer by anyone for decision purpose.


Thank You!


# Arduino Code
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>

#define SEALEVELPRESSURE_HPA (1013.25)

Adafruit_BME280 bme;


#include <DHT.h>    // Install DHT11 Library and Adafruit Unified Sensor Library

#define DHTTYPE DHT11 //--> Defines the type of DHT sensor used (DHT11, DHT21, and DHT22), in this project the sensor used is DHT11.

 
#define DHTPIN D4    // Connect Data pin of DHT to D4
int sensorPin = A0;
#define DHTTYPE    DHT11
DHT dht(DHTPIN, DHTTYPE);


//----------------------------------------SSID and Password of your WiFi router.
const char* WIFI_SSID = "Bharat"; //--> Your wifi name or SSID.
const char* WIFI_PASSWORD = "root909090"; //--> Your wifi password.
//----------------------------------------


//----------------------------------------Host & httpsPort
const char* host = "script.google.com";
const int httpsPort = 443;
//----------------------------------------



//----------------------------------------

WiFiClientSecure client; //--> Create a WiFiClientSecure object.

String GAS_ID = "AKfycbxe6Srpro7T4V4v5uC8gtHVklFnZ5JIOyvq2GxRQlfR2Qi0sROX10accw4EV6nmtafw_A"; //--> spreadsheet script ID
 //https://script.google.com/macros/s/AKfycbxe6Srpro7T4V4v5uC8gtHVklFnZ5JIOyvq2GxRQlfR2Qi0sROX10accw4EV6nmtafw_A/exec
//============================================================================== void setup
void setup()
{
  Serial.begin(9600);
  delay(500);

  bme.begin(0x76);   
  dht.begin();  //--> Start reading DHT11 sensors
  delay(500);

 
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  
  client.setInsecure();
}

void loop()
{ 
  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int r = analogRead(sensorPin);
  r = constrain(r, 150,440);
  r = map(r, 150,440,1023,0);

  float bT = bme.readTemperature();
  float bH = bme.readHumidity();
  float pressure = bme.readPressure() / 100.0F;
  float altitude = bme.readAltitude(SEALEVELPRESSURE_HPA);
 

 
//checks if any reads failed and exit early 
  if(isnan(h) || isnan(t) || isnan(r))
  {
      Serial.println(F("Failed to read from sensors data!"));
    return;
  }

  Serial.println(F("Humidity:"));
  Serial.print(h);
  Serial.print(F("%  Temperature: "));
  Serial.print(t);
  Serial.print(F("rainFallValue: "));
  Serial.print(r);

 
  sendData(t, h, r, bT, bH, pressure, altitude);
}

void sendData(float temp, float humi, int rainFall, float bTemp, float bHumi, float bPressure, float bAlti)
{
  Serial.println("==========");
  Serial.print("connecting to ");
  Serial.println(host);

  //----------------------------------------Connect to Google host
  if (!client.connect(host, httpsPort)) {
    Serial.println("connection failed");
    return;
  }
  
  
  //----------------------------------------Processing data and sending data
  String string_temp = String(temp);
  String string_humi = String(humi, DEC);
  String string_rainFall = String(rainFall);
  String string_bmeTemp = String(bTemp);
  String string_bmeHumi = String(bHumi);
  String string_bmePressure = String(bPressure);
  String string_bmeAltitude = String(bAlti);
  String url = "/macros/s/" + GAS_ID + "/exec?temperature=" +string_temp+ "&humidity=" +string_humi+ "&rainFallValue=" +string_rainFall+ "&bTemp=" +string_bmeTemp+ "&bHumi=" +string_bmeHumi+ "&pressure=" +string_bmePressure+ "&altitude=" +string_bmeAltitude;
  Serial.print("requesting URL: ");
  Serial.println(url);

 client.print(String("GET ") + url + " HTTP/1.1\r\n" +
         "Host: " + host + "\r\n" +
         "User-Agent: BuildFailureDetectorESP8266\r\n" +
         "Connection: close\r\n\r\n");

  Serial.println("request sent");
  //----------------------------------------

  //----------------------------------------Checking whether the data was sent successfully or not
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      Serial.println("headers received");
      break;
    }
  }
  String line = client.readStringUntil('\n');
  if (line.startsWith("{\"state\":\"success\"")) {
    Serial.println("esp8266/Arduino CI successfull!");
  } else {
    Serial.println("esp8266/Arduino CI has failed");
  }
  Serial.print("reply was : ");
  Serial.println(line);
  Serial.println("closing connection");
  Serial.println("==========");
  Serial.println();
  //---------------------------------------- 
}

# Google Sheet Code
function doGet(e) { 
  Logger.log( JSON.stringify(e) );
  var result = 'Ok';
  if (e.parameter == 'undefined') {
    result = 'No Parameters';
  }
  else {
    var sheet_id = '1B2Du-Mr5wiwV_1PlI0DHL3UZ--Tx2Y0uiiVqhfAj2OE'; 	// Spreadsheet ID
    var sheet = SpreadsheetApp.openById(sheet_id).getActiveSheet();
    var newRow = sheet.getLastRow() + 1;						
    var rowData = [];
    var Curr_Date = new Date();
    rowData[0] = Curr_Date; // Date in column A
    var Curr_Time = Utilities.formatDate(Curr_Date, "Asia/Kolkata", 'HH:mm:ss');
    rowData[1] = Curr_Time; // Time in column B
    for (var param in e.parameter) {
      Logger.log('In for loop, param=' + param);
      var value = stripQuotes(e.parameter[param]);
      Logger.log(param + ':' + e.parameter[param]);
      switch (param) {
        case 'temperature':
          rowData[2] = value; // Temperature in column C
          result = 'Temperature Written on column C'; 
          break;
        case 'humidity':
          rowData[3] = value; // Humidity in column D
          result += ' ,Humidity Written on column D'; 
          break;
        case 'rainFallValue':
          rowData[4] = value;
          result += ' ,rainFall Value written in column E';
          break;
        case 'bTemp':
          rowData[5] = value;
          result += ', value inserted in column F';
          break;
        case 'bHumi':
          rowData[6] = value;
          result += ', value inserted in column G';
          break;
        case 'pressure':
          rowData[7] = value;
          result += ',value inserted in column H';
          break;
        case 'altitude':
          rowData[8] = value;
          result += ', value inserted in column I';
          break;  
        default:
          result = "unsupported parameter";
      }
    }
    Logger.log(JSON.stringify(rowData));
    var newRange = sheet.getRange(newRow, 1, 1, rowData.length);
    newRange.setValues([rowData]);
  }
  return ContentService.createTextOutput(result);
}
function stripQuotes( value ) {
  return value.replace(/^["']|['"]$/g, "");
}

# R Code for Model Testing
//we are using here caret package for machine learning algorithms and dplyr package for data preprocessing

//installation of both the packages 
//command
//install.packages('caret')
//install.packages('dplyr')

//add package into the working environment
library(caret)
library(dplyr)

//load the dataset
x <- c(1:100)
x1 <- seq(1,100, by =1)
x2 <- sample(100)
x3 <- sample(100)
y <-  sample(c(0,1), replace=TRUE, size=100)

data <- data.frame(x, x1, x2, x3,y)
View(data)
str(data)

//convert the target variable into the factor
data$y <- as.factor(data$y)
str(data)
nrow(data)
dim(data)

//do the data partition for the training and testing of the machine learning model
set.seed(3303)
intrain <- createDataPartition(y = data$y, p = 0.70, list = FALSE)
training <- data[intrain,]
testing <- data[-intrain,]

//check out is there any na or missing values
anyNA(data)

summary(data)

trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

svm_Linear <- train(y~., data = training, method = "svmLinear",
                    trControl = trctrl, preProcess = c("center", "scale"), tuneLength = 10)

svm_Linear

test_pred <- predict(svm_Linear, newdata = testing)
test_pred

# check the performance of the model
confusionMatrix(table(test_pred, testing$y))


grid <- expand.grid(C = c(0, 0.1, 0.5, 0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 5))

grid_model <- train(y~., data = training, method = "svmLinear", 
                    trControl = trctrl, preProcess = c("center", "scale"),
                    tuneGrid = grid, tuneLength = 10)

grid_model
grid_pred <- predict(grid_model, newdata = testing)
grid_pred

confusionMatrix(table(grid_pred, testing$y))
