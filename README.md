# PartyGames
## Mini-Games
- [x] Racing
- [x] Timer
- [ ] Tanks
- [ ] Spaceships
- [x] Stack Tower
- [x] Reflex Circle
- [ ] Sprint
- [ ] Hot Potato
- [ ] Hidden in Plain Sight
- [ ] Pong
- [ ] Flappy Bird
- [ ] Evaluate the count
- [ ] Snap Crocodile
- [ ] Reflex Grab

## TO-DO
- Let multiple people win
- Update Graphics
- Player can win point for scoreboard or take a benifit he can play against another player later in the prozess 

## Important notes for later
- netsh advfirewall firewall add rule name="ALLOW PARTYGAMES PORT" dir=in action=allow protocol=TCP localport=28960 (From [Link](https://techexpert.tips/de/windows-de/windows-oeffnen-eines-ports-auf-der-firewall-mithilfe-der-befehlszeile/) for Installer later)

## Protokoll Dokumentation
### 100s (Client to Server)
- 100 => Request to Participate, Sending back response
- 101 => Receive username, Server sends back Color
- 110 => Reflex Button Down
- 111 => Reflex button Up
- 120 => Driving Button Left Down
- 121 => Driving Button Left Up
- 122 => Driving Button Right Down
- 123 => Driving Button Right up
### 200s (Server to Client)
- 200 => Participate Response
- 201 => Receive Color
- 210 => Change Controller to Reflex Button
- 220 => Change Controller to Driving Buttons
