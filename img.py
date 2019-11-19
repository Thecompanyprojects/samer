import hashlib
import os

def GetFileMd5(filename):
    if not os.path.isfile(filename):
        return
    myhash = hashlib.md5()
    f = open(filename,'rb')
    while True:
        b = f.read(8096)
        if not b :
            break
        myhash.update(b)
    f.close()
    return myhash.hexdigest()

def fileAppend(filename):
    myfile = open(filename,'a')

    myfile.write("jneth")
    myfile.close

suf_set = ('.png', '.jpg')
project_path = ' ~/Desktop/Shmo2/'

for (root, dirs, files) in os.walk(project_path):
    for file_name in files:
        if file_name.endswith(suf_set):
            short_name = os.path.splitext(file_name)[0]
            realpath = os.path.join(root, file_name)
            print(short_name + ' ==> ' + realpath)
            oldMd5 = GetFileMd5(realpath)
            fileAppend(realpath)
            newMd5 = GetFileMd5(realpath)
            print(oldMd5 + '-->' + newMd5)