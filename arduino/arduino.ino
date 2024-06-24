#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <ZMPT101B.h>

#define SENSITIVITY 567.7500000000
ZMPT101B voltageSensor(A0, 50.0);

const char* ssid = "admin";
const char* password = "";
const char* baseUrl = "http://192.168.43.178:3000/api/";
String deviceId = "0002";

unsigned long previousTime = 0;
String startDate = "";
String endDate = "";
float totalEnergyConsumed = 0.0;
float voltage = 0;
float current = 0;
bool deviceOn = false;

const int currentPin = D0; 
const float vref = 3;
const float sensitivity = 0.170;

void setup() {
  Serial.begin(9600);
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  voltageSensor.setSensitivity(SENSITIVITY);
  totalEnergyConsumed=0.0;
  deviceOn = false;
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(100);
  }

  startDate = getCurrentTime();
  previousTime = millis();
}

void loop() {
  GetInput(voltage, current);

  if (deviceOn) {
    float power = current * voltage;
    unsigned long currentTime = millis();
    unsigned long elapsedTime = currentTime - previousTime;
    previousTime = currentTime;

    if (current != 0) {
      totalEnergyConsumed += power * (elapsedTime / 1000.0);
      Serial.println(totalEnergyConsumed);
    }
  }

  if (totalEnergyConsumed > 0 && !deviceOn) {
    endDate = getCurrentTime();
    float unitConsumed = totalEnergyConsumed / 3600000.0;

    Serial.println("unit : ");
    Serial.println(unitConsumed,10);
    int status = sendDataToBackend(unitConsumed);
    if (status != 201) {
      Serial.println("Error in uploading");
    }
    totalEnergyConsumed = 0.0;
    startDate = getCurrentTime();
  }

  if (!deviceOn) {
    previousTime = millis();
    startDate = getCurrentTime();
  }
}

void GetInput(float& voltage, float& current) {
  voltage = voltageSensor.getRmsVoltage();

  int sensorValue = analogRead(currentPin); 
  float adjustedSensorValue = sensorValue + vref*sensitivity;
  current = adjustedSensorValue * (sensitivity/2);

  if (voltage > 20) {
    if (!deviceOn) {
      while (WiFi.status() != WL_CONNECTED){
        Serial.println("Wifi connecting...");
      };
      if (WiFi.status() == WL_CONNECTED) {
        WiFiClient client;
        HTTPClient http;
        http.begin(client, String(baseUrl) + "device/change-devicestatus");
        http.addHeader("Content-Type", "application/json");
        String data = "{\"deviceId\":\"" + deviceId + "\",\"deviceOn\":\"" + (deviceOn ? "false" : "true") + "\"}";
        int httpResponseCode = http.POST(data);
        if (httpResponseCode > 0) {
          String response = http.getString();
          Serial.println(httpResponseCode);
          Serial.println(response);
        } else {
          Serial.println("error");
        }
        http.end();
      }
    }
    deviceOn = true;
    Serial.print("device status: ");
    Serial.println(deviceOn);
  } else {
    if (deviceOn) {
        while (WiFi.status() != WL_CONNECTED){
          Serial.println("Wifi connecting...");
        };
        if (WiFi.status() == WL_CONNECTED) {
        WiFiClient client;
        HTTPClient http;
        http.begin(client, String(baseUrl) + "device/change-devicestatus");
        http.addHeader("Content-Type", "application/json");
        String data = "{\"deviceId\":\"" + deviceId + "\",\"deviceOn\":\"" + (deviceOn ? "false" : "true") + "\"}";
        int httpResponseCode = http.POST(data);
        if (httpResponseCode > 0) {
          String response = http.getString();
          Serial.print("response: ");
          Serial.println(response);
        } else {
          Serial.println("error");
        }
        http.end();
      }
    }
    deviceOn = false;
    Serial.print("device status: ");
    Serial.println(deviceOn);

  }
}

int sendDataToBackend(float unitConsumed) {

  while (WiFi.status() != WL_CONNECTED){
    Serial.println("Wifi connecting...");
  };
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;
    HTTPClient http;
    http.begin(client, String(baseUrl) + "storeutilization/");
    http.addHeader("Content-Type", "application/json");
    String data = "{\"deviceId\":\"" + deviceId + "\",\"startDate\":\"" + startDate + "\",\"endDate\":\"" + endDate + "\",\"unitConsumed\":\"" + String(unitConsumed, 10) + "\"}";
    int httpResponseCode = http.POST(data);
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.print("response : ");
      Serial.println(response);
    } else {
      if (httpResponseCode == HTTPC_ERROR_CONNECTION_REFUSED) {
        Serial.println("Connection refused by the server");
      } else if (httpResponseCode == HTTPC_ERROR_READ_TIMEOUT) {
        Serial.println("Connection timed out");
      } else {
        Serial.print("Error on sending POST: ");
        Serial.println(httpResponseCode);
      }
    }
    http.end();
    return httpResponseCode;
  } else {
    Serial.println("Error in WiFi connection");
  }
  return -1;
}

String getCurrentTime() {
  String dateTime;
  while (WiFi.status() != WL_CONNECTED){
    Serial.println("Wifi connecting...");
  };
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;
    HTTPClient http;
    http.begin(client, "http://worldtimeapi.org/api/timezone/Asia/Kolkata");
    int httpCode = http.GET();
    if (httpCode > 0) {
      if (httpCode == HTTP_CODE_OK) {
        DynamicJsonDocument doc(1024);
        DeserializationError error = deserializeJson(doc, http.getString());
        if (!error) {
          dateTime = doc["datetime"].as<String>();
        } else {
          Serial.println("Failed to parse JSON");
        }
      } else {
        Serial.print("HTTP error code: ");
        Serial.println(httpCode);
      }
    } else {
      Serial.println("HTTP request failed");
    }
    http.end();
  } else {
    Serial.println("WiFi is not connected");
  }
  return dateTime;
}
