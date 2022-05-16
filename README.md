# PartyGames
## Mini-Games
- [x] Racing
- [x] Timer
- [ ] Tanks
- [ ] Spaceships
- [ ] Stack Tower
- [ ] Reflex Circle
- [ ] Sprint

## TO-DO
- Let multiple people win
- Update Graphics to 3D

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
