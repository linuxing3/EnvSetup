#!/bin/sh
SYSTEM=`uname -s`
if [ $SYSTEM = "Linux" ] ; then 
    echo "Linux"
    FILE=qiniu-devtools-linux_amd64-current.tar.gz
elif [ $SYSTEM = "Darwin" ] ; then 
    echo "Mac OS"
    FILE=qiniu-devtools-darwin_amd64-current.tar.gz
else
    echo "What?"
fi

echo Downloading qiniu toolset for linux_amd64
echo $FILE
wget http://devtools.qiniu.io/$FILE
echo tar xvf $FILE.tar.gz
echo copy $FILE/* /usr/bin/
echo Done downloading and installing!
echo You must login first to use qiniu toolset
echo Usage:
echo qboxrsctl login
echo qboxrsctl put -c $1 $2 $2
echo You may put commands in bashrc
echo User information:
echo UserId:          linuxing3@qq.com
echo Uid:             1380293629
echo Email:           linuxing3@qq.com
echo Done!
