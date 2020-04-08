#!/usr/bin/env bash
# Algorithm parameters
DEVICEWIDTHPOINTS=595
DEVICEHEIGHTPOINTS=420
SCALEFCTOR=0.5
h=$(echo "$SCALEFCTOR*$DEVICEHEIGHTPOINTS" | bc)
echo $h
l=$(echo "$SCALEFCTOR*$DEVICEWIDTHPOINTS/2" | bc) 
echo $l

FILE_LIST=(*.pdf) #Get all pdf files

for file in "${FILE_LIST[@]}"; do

  # Split filenames
  filename="$(cut -d'.' -f1 <<< $file )"
  extention="$(cut -d'.' -f2 <<< $file )"
  # Create output pdf
  newfilePs=$filename"_c.ps"
  newfile=$filename"_c.pdf"
  touch "$newfilePs"; ps2pdf $newfilePs $newfile

  gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dSAFER \
    -dCompatibilityLevel="1.5" -dPDFSETTINGS="/printer"\
    -dColorConversionStrategy=/LeaveColorUnchanged \
    -dSubsetFonts=true -dEmbedAllFonts=true \
    -dDEVICEWIDTHPOINTS=$DEVICEWIDTHPOINTS -dDEVICEHEIGHTPOINTS=$DEVICEHEIGHTPOINTS  \
    -dFIXEDMEDIA -sOutputFile=$newfile -dAutoRotatePages=/All \
    -c "<</BeginPage{$SCALEFCTOR $SCALEFCTOR scale $h $l translate}>> setpagedevice" \
    -f $file
  rm $newfilePs $file
  mv $newfile $file
done
