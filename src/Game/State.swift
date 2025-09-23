import CCuteFramework

@MainActor
class State {
  var playerBeams: [PlayerBeam] = []
  var enemies: [Enemy] = []
  var explosions: [Explosion] = []
  var debug = false
  var lives = 3
  var player: Player
  var shader: CF_Shader
  var canvas: CF_Canvas

  init(player: Player, shader: CF_Shader, canvas: CF_Canvas) {
    self.player = player
    self.shader = shader
    self.canvas = canvas
  }
}
