#include <arduino.h>

void setup(void)
{
  // Initialize the serial communication at a baud rate of 9600
  Serial.begin(9600);

  // Set the pinMode of pins 2 to 13 as OUTPUT
  for (int i = 2; i <= 13; i++)
    pinMode(i, OUTPUT);
}

void loop(void)
{
  // Check if there is any data available to read from the serial port
  if (Serial.available() > 0)
  {
    char mybuffer[1];
    // Read a single byte from the serial port
    Serial.readBytes(mybuffer, 1);

    // If the received byte is equal to the ASCII value of 'S'
    if ((int)mybuffer[0] == 83)
    {
      // Call the readRest() function to read the remaining data, otherwise, all data will be received by below code and thrown away
      readRest();
    }
  }
}

void readRest()
{
  // Declare an array of char pointers to hold the parsed data
  char *place_holder[3];
  // Declare a char buffer to store the received data
  char char_buffer[3];

  // Declare a byte buffer to store the received bytes
  byte byte_buffer[3];
  // Read 3 bytes from the serial port and store them in the byte buffer
  Serial.readBytes(byte_buffer, 3);

  // Convert the received bytes to chars and store them in the char buffer
  for (size_t i = 0; i < 3; i++)
  {
    char_buffer[i] = (char)byte_buffer[i];
  }

  // Convert the pin number from char to int using the strtol() function
  int pin = strtol(char_buffer, place_holder, 10);
  // Get the command character from the char buffer
  char cmd = char_buffer[2];

  // Perform the appropriate action based on the command character
  switch (cmd)
  {
  case "O":
    digitalWrite(pin, HIGH); // Set the specified pin to HIGH
    break;
  case "C":
    digitalWrite(pin, LOW); // Set the specified pin to LOW
    break;
  default:
    digitalWrite(pin, LOW); // Set the specified pin to LOW for any other command
    break;
  }
}
