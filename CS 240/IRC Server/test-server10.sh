#/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: `basename $0` server-prog port"
  exit 1
fi

SERVER=$1
PORT=$2

echo "Start Test 10"

#echo Killing Server if any
PID=`ps | grep IRCServer | awk '{ print $1;}'`
kill -9 $PID 2> /dev/null
sleep 2

#Start server in the background
rm -f userPass.txt
rm -f password.txt
$SERVER $PORT > talk-server.out &
sleep 1

echo Add Users
./TestIRCServer localhost $PORT "ADD-USER superman clarkkent"
./TestIRCServer localhost $PORT "ADD-USER spiderman peterpark"
./TestIRCServer localhost $PORT "ADD-USER mary poppins"

echo Create Room
./TestIRCServer localhost $PORT "CREATE-ROOM superman clarkkent java-programming"

echo Create Room
./TestIRCServer localhost $PORT "CREATE-ROOM spiderman peterpark c-programming"

echo Enter room
./TestIRCServer localhost $PORT "ENTER-ROOM superman clarkkent python-programming"
./TestIRCServer localhost $PORT "ENTER-ROOM aquaman xyz python-programming"

./TestIRCServer localhost $PORT "ENTER-ROOM spiderman peterpark c-programming"
./TestIRCServer localhost $PORT "ENTER-ROOM aquaman xyz c-programming"
./TestIRCServer localhost $PORT "ENTER-ROOM mary poppins c-programming"

echo Print users in room
./TestIRCServer localhost $PORT "GET-USERS-IN-ROOM unknown clarkkent java-programming"
./TestIRCServer localhost $PORT "GET-USERS-IN-ROOM mary poppins java-programming"

echo Enter another user
./TestIRCServer localhost $PORT "ENTER-ROOM spiderman peterpark c-programming"

echo Print users in room
./TestIRCServer localhost $PORT "GET-USERS-IN-ROOM unknown peterpark c-programming"

echo Send message
./TestIRCServer localhost $PORT "SEND-MESSAGE superman clarkkent c-programming Hi everybody!"
./TestIRCServer localhost $PORT "SEND-MESSAGE unknown poppins c-programming Welcome to the talk program!"

echo Send message
./TestIRCServer localhost $PORT "SEND-MESSAGE superman clarkkent java-programming Welcome to java-programming!"
./TestIRCServer localhost $PORT "SEND-MESSAGE aquaman xyz java-programming Java is based on C++!"

echo Get messages
./TestIRCServer localhost $PORT "GET-MESSAGES mary poppins 0 java-programming"

echo Get messages
./TestIRCServer localhost $PORT "GET-MESSAGES superman clarkkent 0 c-programming"

echo Get messages from 0
./TestIRCServer localhost $PORT "GET-MESSAGES mary poppins 10000 c-programming"

./TestIRCServer localhost $PORT "LEAVE-ROOM mary poppins c-programming"

echo Get messages from 2
./TestIRCServer localhost $PORT "GET-MESSAGES superman clarkkent 4 java-programming"

# Kill server
echo Killing Server
PID=`ps | grep IRCServer | awk '{ print $1;}'`
kill -9 $PID

