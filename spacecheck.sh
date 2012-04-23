#!/bin/bash

df -h /diski1_1/ | awk '{ if ($5 != "Use%") { if (int(substr($5,0,length($5)))>=99) { system("/opt/recserver/removeoldest.sh " $6) } } }'
df -h /diski2_1/ | awk '{ if ($5 != "Use%") { if (int(substr($5,0,length($5)))>=99) { system("/opt/recserver/removeoldest.sh " $6) } } }'
df -h /diski3_1/ | awk '{ if ($5 != "Use%") { if (int(substr($5,0,length($5)))>=99) { system("/opt/recserver/removeoldest.sh " $6) } } }'
df -h /diski4_1/ | awk '{ if ($5 != "Use%") { if (int(substr($5,0,length($5)))>=99) { system("/opt/recserver/removeoldest.sh " $6) } } }'
