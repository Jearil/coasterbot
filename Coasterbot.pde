/*
  Coasterbot
 
 The basic movement and controls for my CoasterBot
 
 The circuit:
 
 * L239DNE:
 
 m2 = Right
 m1 = LEFT
 
 Created 17 April 2010
 By Colin Miller
 
 */

int motor1 = 9;    // on/off - connected to pin 9 on L239DNE 
int motor2 = 10;   // on/off - connected to pin 1 on L293DNE
int m1clock = 2;   // pin 15 on L293DNE
int m1counter = 5; // pin 10 on L293DNE
int m2clock = 3;   // pin 2 on L293DNE
int m2counter = 4; // pin 7 on L293DNE
int rbump = 6;	   // connected to right bumper switch
int lbump = 7;	   // connected to left bumper switch

// For reading the state of the bumpers
int rstate;
int lstate;


// for some debug info
long lastTime = 0;

#define FORWARD 1
#define BACKWARD -1
#define STOP 0

// The setup() method runs once, when the sketch starts

void setup()   {                
  // initialize the digital pin as an output:
  pinMode(motor1, OUTPUT);
  pinMode(motor2, OUTPUT);  
  pinMode(m1clock, OUTPUT);  
  pinMode(m1counter, OUTPUT);  
  pinMode(m2clock, OUTPUT);  
  pinMode(m2counter, OUTPUT);
  
  pinMode(rbump, INPUT);
  pinMode(lbump, INPUT);

  digitalWrite(motor1, LOW);
  digitalWrite(motor2, LOW);
  digitalWrite(m2clock, LOW);
  digitalWrite(m2counter, LOW);
  digitalWrite(m1clock, LOW);
  digitalWrite(m1counter, LOW);
  
  Serial.begin(9600);
  
  start();
  forward();
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop()                     
{
    rstate = digitalRead(rbump);
    lstate = digitalRead(lbump);
    
    if((millis() - lastTime) > 1000) {
      lastTime = millis(); 
      if(rstate == HIGH) {
        Serial.println("RH ");
      } else {
        Serial.println("RL ");
      }
    
      if(lstate == HIGH) {
        Serial.println("LH ");
      } else {
        Serial.println("LL ");
      }
    }
    
    if(rstate == HIGH) {
      Serial.println("Right bumper triggered");
      evade();
    }
    else if(lstate == HIGH) {
      Serial.println("Left bumper triggered");
      evade();
    }
}

void start()
{
  digitalWrite(motor1, HIGH);
  digitalWrite(motor2, HIGH);
}

void stopMotors()
{
  digitalWrite(motor1, LOW);
  digitalWrite(motor2, LOW);
}

void forward()
{
  Serial.println("FORWARD");
  turnWheel(m1counter, m1clock, FORWARD);
  turnWheel(m2counter, m2clock, FORWARD);
}

void backward()
{
  Serial.println("BACKWARD");
  turnWheel(m1counter, m1clock, BACKWARD);
  turnWheel(m2counter, m2clock, BACKWARD);
}

void turnLeft() {
  Serial.println("LEFT");
  turnWheel(m2counter, m2clock, FORWARD);
  turnWheel(m1counter, m1clock, BACKWARD);
}

void turnRight() {
  Serial.println("RIGHT");
  turnWheel(m1counter, m1clock, FORWARD);
  turnWheel(m2counter, m2clock, BACKWARD);
}

void turnWheel(int counter, int clock, int dir)
{
  switch(dir) {
    case FORWARD:
      digitalWrite(clock, HIGH);
      digitalWrite(counter, LOW);
      break;
    case BACKWARD:
      digitalWrite(clock, LOW);
      digitalWrite(counter, HIGH);
      break;
    case STOP:
    default:
      digitalWrite(clock, LOW);
      digitalWrite(counter, LOW);
      break;
  }
}


// we ran into something
void evade() {
  backward();
  delay(2000);
  turnLeft();
  delay(900);
  forward();
}
