#!/bin/bash

# https://brewcompetition.com/local-load

mkdir libraries
cd libraries

wget https://code.jquery.com/jquery-2.2.4.min.js

wget -O bootstrap.zip https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip
unzip -qq bootstrap.zip
mv bootstrap-3.3.7-dist bootstrap
rm -f bootstrap.zip

wget -O datatables.zip 'https://datatables.net/download/builder?bs/dt-1.10.21'
mkdir datatables
cd datatables
unzip -qq ../datatables.zip
rm -f ../datatables.zip
find . -name jquery.dataTables.min.js -exec cp {} . \;
find . -name dataTables.bootstrap.min.css -exec cp {} . \;
find . -name dataTables.bootstrap.min.js -exec cp {} . \;
wget https://cdn.datatables.net/plug-ins/1.10.12/integration/font-awesome/dataTables.fontAwesome.css
cd ..

wget -O fancybox.zip https://github.com/fancyapps/fancybox/archive/v2.1.5.zip
unzip -qq fancybox.zip
rm -f fancybox.zip
mv fancybox-2.1.5 fancybox
wget -O easing.zip https://codeload.github.com/gdsmith/jquery.easing/legacy.zip/1.3.2
unzip -qq easing.zip
rm -f easing.zip
find ./gdsmith-jquery.easing-82496a9/ -name jquery.easing.1.3.min.js -exec cp {} ./fancybox/ \;
rm -rf gdsmith-jquery.easing-979dcad

wget -O dtp.zip https://github.com/Eonasdan/bootstrap-datetimepicker/archive/4.17.37.zip
unzip -qq ./dtp.zip
rm -f dtp.zip
mv bootstrap-datetimepicker-4.17.37/build ./date-time-picker
rm -rf bootstrap-datetimepicker-4.17.37/
cd date-time-picker/js/
wget http://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.1/moment-with-locales.js
cd ../..

wget -O tinymce.zip https://download.tiny.cloud/tinymce/community/tinymce_5.3.2.zip
unzip -qq tinymce.zip
rm -f tinymce.zip

wget https://github.com/jasny/bootstrap/releases/download/v3.1.3/jasny-bootstrap-3.1.3-dist.zip
unzip -qq jasny-bootstrap-3.1.3-dist.zip
rm -f jasny-bootstrap-3.1.3-dist.zip

wget -O dropzone.zip https://github.com/enyo/dropzone/archive/v4.2.0.zip
unzip -qq dropzone.zip
rm -f dropzone.zip
mkdir dropzone
cd dropzone
find ../dropzone-4.2.0/ -name dropzone.min.js -exec cp {} . \;
find ../dropzone-4.2.0/ -name dropzone.min.css -exec cp {} . \;
cd ..
rm -rf dropzone-4.2.0

wget -O validator.zip https://github.com/1000hz/bootstrap-validator/archive/v0.9.0.zip
mkdir validator
unzip -qqj -d ./validator/ validator.zip bootstrap-validator-0.9.0/dist/validator.min.js
rm -f validator.zip

wget -O bs.zip https://github.com/snapappointments/bootstrap-select/releases/download/v1.12.0/bootstrap-select-1.12.0.zip
mkdir bootstrap-select
unzip -qqj -d ./bootstrap-select/ bs.zip bootstrap-select-1.12.0/css/bootstrap-select.min.css bootstrap-select-1.12.0/js/bootstrap-select.min.js
rm bs.zip

wget https://fontawesome.com/v4.7.0/assets/font-awesome-4.7.0.zip
unzip -qq font-awesome-4.7.0.zip
mv font-awesome-4.7.0 font-awesome
rm -f font-awesome-4.7.0.zip

wget -O jpb.zip https://github.com/ablanco/jquery.pwstrength.bootstrap/archive/3.0.9.zip
unzip -qq jpb.zip
mv jquery.pwstrength.bootstrap-3.0.9 pwstrength-bootstrap
rm -f jpb.zip

wget -O zxcvbn.zip https://github.com/dropbox/zxcvbn/archive/v4.4.2.zip
unzip -qq ./zxcvbn.zip
rm -f zxcvbn.zip
mv zxcvbn-4.4.2 zxcvbn

cd ..

