#!/bin/bash
ls -ltr /$1//TV/ | head -n 2 | awk '{ if (substr($9,0,3) == "CH") {  system("rm /diski1_1/TV/"  $9);   system("rm /diski2_1/TV/" $9); system("rm /diski3_1/TV/" $9); system("rm  /diski4_1/TV/" $9); system("rm /diski5_1/TV/" $9); system("rm /diski6_1/TV/" $9); print "Removed " $9 } }' >> /opt/recserver/output

