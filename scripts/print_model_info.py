import sys
import os
import json


model_filename = sys.argv[1]
progress_filename = os.curdir + '/' + model_filename + '.progress.json'
progress_info = json.loads(open(progress_filename, 'r').read())
uidx = progress_info['uidx']
print model_filename, 'after', uidx, 'updates'
