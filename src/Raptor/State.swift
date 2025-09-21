import CCuteFramework

struct State {
  var player: Player
  var playerBeams: [PlayerBeam] = []
  var enemies: [Enemy] = []
  var explosions: [Explosion] = []
  var debug = false
  var lives = 3
  var shader: CF_Shader
  var canvas: CF_Canvas
}
