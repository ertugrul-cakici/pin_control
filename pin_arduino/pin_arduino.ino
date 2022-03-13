#include <arduino.h>





void setup(void){ 
  
  Serial.begin(9600);
  for (int i = 2; i <= 13; i++)
      pinMode(i,OUTPUT);
  
 }


void loop(void)
{

  if(Serial.available()>0){ 
    char mybuffer[1];
    Serial.readBytes(mybuffer,1);

    if ((int) mybuffer[0] == 83) {
      readRest();
    }
  
}}

void readRest() {
    char* place_holder[3];
    char char_buffer[3];

    byte byte_buffer[3];
    Serial.readBytes(byte_buffer,3);
    
    for (size_t i = 0;i < 3; i++) {
        char_buffer[i] = (char) byte_buffer[i];
      }

    int pin = strtol(char_buffer,place_holder,10);
    char cmd = char_buffer[2];

    if (cmd == 'O')
      digitalWrite(pin,HIGH);
    else if (cmd == 'C')
      digitalWrite(pin,LOW);
   
}
