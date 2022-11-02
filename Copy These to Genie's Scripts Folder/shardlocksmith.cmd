#shardlocksmith.cmd
# For use with automapper.cmd to deal with getting to the shard locksmith
# by Hanryu (so blame the mac user)
#debug 5

ASK:
  matchre ASK ^\.\.\.wait|^Sorry,
  matchre ORDER ^Malik nods at you
  put ask malik about kilam
  matchwait

ORDER:
  matchre ORDER ^\.\.\.wait|^Sorry,
  matchre OFFER ^Malik nods and says
  put order fife
  matchwait

OFFER:
  matchre OFFER ^\.\.\.wait|^Sorry,|^An offer of
  matchre ASK ^Malik laughs and says
  matchre DONE ^You realize to your
  put offer 10000000000
  matchwait

DONE:
  pause 9
  put #parse MOVE SUCCESSFUL
  exit
