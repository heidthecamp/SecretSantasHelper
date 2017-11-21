#!/bin/bash


checkIn() {
  var=("$1")
  arr=("$@")
  pass=true
  for i in "${arr[@]:1}";
  do
    if [[ $var -eq $i ]]; then
      echo "$var = $i"
      pass=false
    fi
  done
  echo $pass
  # echo $val
}

setNames() {
count=0
while IFS=, read -r col1 col2
do
  if [[ $count -ge 1 ]]; then
    NAMES+=($col1)
    EMAILS+=($col2)
  fi
  count=$(($count + 1))
done < example.csv
}

randomize() {
gavesize=0
receivedsize=0
while [[ $gavesize -lt $size && $receivedsize -lt $size ]]
do
  giver=$(($size + 1))
  getter=$(($size + 1))
  while [[ $giver = $getter ]]
  do
    pass=false
    while [[ ${pass} != "true" ]]
    do
      giver=$(($RANDOM % $size))
      checkIn $giver ${givers[@]}
    done
    pass=false
    while [[ ${pass} != "true" ]]
    do
      getter=$(($RANDOM % $size))
      checkIn $getter ${receivers[@]}
    done
    if [[ $(($size - 1)) -eq $gavesize && $giver -eq $getter ]]; then
      pass=false
      exit [1]
    fi
  done
  givers+=($giver)
  receivers+=($getter)
  gavesize=${#gave[@]}
  receivedsize=${#receivers[@]}
done
pass=true
}

sendMessage() {
count=0
while [[ $count -lt ${#givers[@]} ]]
do
  giver=${givers[$count]}
  receiver=${receivers[$count]}
  sed -e "s/\${santa}/${NAMES[$giver]}/" -e "s/\${receiver}/${NAMES[$receiver]}/" -e"s/\${price}/50/" body.txt
  count=$(($count + 1))
done
}

setNames
size=${#NAMES[@]}
pass=false
while [[ ${pass} != "true" ]]
do
  randomize
done
sendMessage
