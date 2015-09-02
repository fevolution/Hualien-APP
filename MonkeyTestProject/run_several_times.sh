#!/bin/bash
COUNTER=0
while [  $COUNTER -lt 10 ]; do
  #java -jar monkeytalk-runner.jar -agent iOS yourtestfilename.mt
  ant -lib /Users/chuntachen/Downloadmonkeytalkpro/ant/monkeytalkpro-ant-2.0.10.beta.jar myScript
  let COUNTER=COUNTER+1
  echo $COUNTER
done
