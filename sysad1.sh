#!/bin/bash
#curentUser = root
#creating users
useradd -m hod ; echo -e "hod\nhod"| passwd hod
useradd -m prof1 ; echo -e "prof1\nprof1"| passwd prof1
useradd -m prof2 ; echo -e "prof2\nprof2"| passwd prof2
for a in {1..20} ; do useradd -m student$a; echo -e "st$a\nst$a" | passwd student$a; done
#
#creating specified directories
mkdir /home/prof1/Teaching_material ; chown prof1:prof1 /home/prof1/Teaching_material
mkdir /home/prof2/Teaching_material ; chown prof2:prof2 /home/prof2/Teaching_material
for a in {1..20} ; do mkdir /home/student$a/HomeWork;mkdir /home/student$a/prof1_work;mkdir /home/student$a/prof2_work ; chown -R student$a:student$a student$a/HomeWork;done
#
#assigning file permissions to hod 
setfacl -R -m u:hod:rwx /home/prof1/
setfacl -R -m u:hod:rwx /home/prof2/
#
#assgning hod and professor the access to each student
for a in {1..20};do setfacl -R -m u:hod:rwx /home/student$a ; setfacl -R -m u:prof1:rwx /home/student$a; setfacl -R -m u:prof2:rwx /home/student$a; done
#
#prevent other users from connecting to student
for a in {1..20};do chmod 770 -R /home/student$a;done
#
#prevent others from accessing prof acc
chmod 770 /home/prof2/
chmod 770 /home/prof1/
#
#add q1...q50 for prof1
for a in {1..50} ;do tr -dc A-Za-z0-9 </dev/urandom | head -c 100 > /home/prof1/Teaching_material/q$a.txt;done
#
#add q1...q50 for prof2
for a in {1..50} ;do tr -dc A-Za-z0-9 </dev/urandom | head -c 100 > /home/prof2/Teaching_material/q$a.txt;done
#
#put 5 random questions of prof1 in every prof1_work folder
for a in {1..20}; do for j in $(shuf -i 1-20 -n 5) ; do cp /home/prof1/Teaching_material/q$j.txt /home/student$a/prof1_work/ ;done;done;
#
#put 5 random questions of prof2 in every prof2_work folder
for a in {1..20}; do for j in $(shuf -i 1-20 -n 5) ; do cp /home/prof2/Teaching_material/q$j.txt /home/student$a/prof2_work/ ;done;done;
#
#HACKER MODE
#Remove all files from Teaching_material directory
for a in 1 2 ; do rm /home/prof$a/Teaching_material/*.txt;done
#
#downloading files
wget http://inductions.delta.nitt.edu/dataStructure.txt
#
wget http://inductions.delta.nitt.edu/algorithm.txt
#
#allocate folders to prof1
IFS=$'\n'; for a in $(grep '^*' algorithm.txt | sed s/**\ //g) ; do mkdir /home/prof2/Teaching_material/$a ;chmod 770 /home/prof2/Teaching_material/$a; chown -R prof2:prof2 /home/prof2/Teaching_material/$a; done;
#allocate folders to prof2
IFS=$'\n'; for a in $(grep '^*'  dataStructure.txt | sed s/**\ //g) ; do mkdir /home/prof1/Teaching_material/$a ;chmod 770 /home/prof1/Teaching_material/$a; chown -R prof1:prof1 /home/prof1/Teaching_material/$a; done;
#
#allocate questions
sed s/^**\ //g algorithm.txt> al.txt
 awk 'BEGIN {number=1};/^[A-Za-z]/ {dName=$0;print dName}; /^\-/ {print > "/home/prof2/Teaching_material/"dName"/q"number".txt";number=number+1} ' al.txt
#
sed s/^**\ //g dataStructure.txt> ds.txt
awk 'BEGIN {number=1};/^[A-Za-z]/ {dName=$0;print dName}; /^\-/ {print > "/home/prof1/Teaching_material/"dName"/q"number".txt";number=number+1} ' ds.txt
#
#before we add new student files, we will remove the older ones in all student files
rm /home/student*/*/*.txt
#
#now we will add a file for adding work to prof1_work
echo 'for a in {1..20}; do for j in $(shuf -i 1-45 -n 5) ; do find /home/prof1/ -name q$j.txt -exec cp '{}' /home/student$a/prof1_work/q$j.txt \; ;done;done;' > setProf1Work.sh
#
#now we will add a file for adding work to prof2_work
echo 'for a in {1..20}; do for j in $(shuf -i 1-118 -n 5) ; do find /home/prof2/ -name q$j.txt -exec cp '{}' /home/student$a/prof2_work/q$j.txt \; ;done;done;' > setProf2Work.sh
#
#assign crontab
echo '00 17 * * * ./setProf1Work.sh' >> /var/spool/cron/crontabs/root
echo '00 17 * * * ./setProf2Work.sh' >> /var/spool/cron/crontabs/root















