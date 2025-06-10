struct State {
  var player: Player
  var playerBeams: [PlayerBeam] = []
  var enemies: [Enemy] = []
  var explosions: [Explosion] = []
  var debug = false
  var lives = 3
}
