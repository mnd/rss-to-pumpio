#!/bin/bash
LAST_MSG="/home/pumpio/lorbot/lastmsg.log"
wget http://feeds.feedburner.com/org/LOR -O- 2>/dev/null | xsltproc /home/pumpio/lorbot/lor_process.xsl - \
  | sed '/feeds.feedburner.com/ { s,^.*<img src=[^>]*>,, }' \
  | awk -v "OLD=`head -n1 $LAST_MSG`" -v "LAST_MSG=$LAST_MSG" '
/<msg>/ {
  getline;
  if (! /<date>/) exit 1;
   if (!SAVED) {
     print $0 > LAST_MSG; 
     SAVED=1 
   }; 
   if ($0 == OLD) exit;
}
/<title>/ {
   TITLE[N+1] = substr($0, 12, (length($0) - 19))
} 
/<body>/,/<\/body>/ {
          TEMP_BODY = TEMP_BODY "\n" $0
}
/<\/msg>/ {
  BODY[N+1] = substr(TEMP_BODY, 12, (length(TEMP_BODY) - 18));
  TEMP_BODY = ""; N+=1;
}

END {
  for (I=N; I>0; I--) {
    ("/home/pumpio/pump.io/bin/pump-post-note-with-header -u lor -s pump.mndet.net -P 443 -t '\''" TITLE[I] "'\'' -n '\''" BODY[I] "'\''") | getline
  }
}
'
