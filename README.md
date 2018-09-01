# ArtNet-for-Delphi
Stripped down ArtNet module to send DMX levels
This came about from searching and searching for a module that would allow me to communicate with ArtNet lighting controllers. 
Much of the previous material included a lot of code for receiving artnet packets which was confusing (to me) and added complexity
that I didn't need. Some of the prior work was based on Indy9 instead of Indy10 and none was configured for Delphi Tokyo 10.2.3. 
What is here will give you the code to send a packet of 512 bytes to an ArtNet ready controller. It has been tested with a DMX King
eDMX 1 Pro unit. I expect a later update will allow use with a 2 universe model.
