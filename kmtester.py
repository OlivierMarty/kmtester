import urllib.request
import json
import time
import sys
from subprocess import run


url    = "https://ws.ovh.com/dedicated/r2/ws.dispatcher/getAvailability2"
models = ["160sk1"]
mail   = ""
sleep  = 10 # quota: 500 queries per 3600s -> 1 every 7.2s
sleep_after = 300

def notify(model, zone):
  msg = "model " + model + " available in zone " + zone
  print(msg)
  run(['mail', '-s', 'Alert kimsufi !', mail], input=msg.encode(), check=True)


def check():
  j = json.loads(urllib.request.urlopen(url).read().decode())
  found = False
  for m in j['answer']['availability']:
    if m['reference'] in models:
      for z in m['zones']:
        if z['availability'] not in ['unavailable', 'unknown']:
          notify(m['reference'], z['zone'])
          found = True
  if found:
    time.sleep(sleep_after)
  else:
    print("nothing...")

while True:
  try:
    check()
  except:
    print("Unexpected error:", sys.exc_info())
  time.sleep(sleep)
