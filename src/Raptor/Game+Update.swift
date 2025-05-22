import CuteFramework

/*
 * Game update functions
 *
 * These functions are responsible for updating the game state, including player,
 * enemies, explosions, and stars.
 */
extension Game {
  func updatePlayer() {
    inputPlayer()

    if state.player.didShoot() {
      let position = CF_V2(x: state.player.position.x, y: state.player.position.y + 2)
      state.playerBeams.append(PlayerBeam(at: position))

      cf_play_sound(fireSound, cf_sound_params_defaults())
    }

    state.player.update()
  }

  func updatePlayerBeams() {
    for i in state.playerBeams.indices {
      state.playerBeams[i].update()

      // Mark beam as destroyed when out of bounds
      if state.playerBeams[i].position.y > Float(canvasHeight / 2) + 8 {
        state.playerBeams[i].destroy()
      }
    }
  }

  func updateEnemies() {
    for i in state.enemies.indices {
      state.enemies[i].update()

      // Mark enemy as destroyed when out of bounds
      if state.enemies[i].position.y < Float(-canvasHeight / 2) - 8 {
        state.enemies[i].destroy()
      }
    }
  }

  func updateExplosions() {
    for i in state.explosions.indices {
      state.explosions[i].update()
    }
  }

  func updateStars() {
    for i in stars.indices {
      stars[i].update()
      if stars[i].position.y < Float(-canvasHeight / 2) {
        stars[i].destroy()
      }
    }
    stars.removeAll(where: { $0.isDestroyed })
  }
}
