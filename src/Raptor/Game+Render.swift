import CuteFramework

/*
 * Game rendering functions
 *
 * These functions are responsible for rendering the game state, including player,
 * enemies, explosions, and stars.
 */
extension Game {
  func renderStars() {
    for i in stars.indices {
      stars[i].draw()
    }
  }

  func renderBackground() {
    background.draw()
  }

  func renderPlayerBeams() {
    for i in state.playerBeams.indices {
      state.playerBeams[i].draw()
    }
  }

  func renderEnemies() {
    for i in state.enemies.indices {
      state.enemies[i].draw(state: self.state)
    }
  }

  func renderExplosions() {
    for i in state.explosions.indices {
      state.explosions[i].draw()
    }
  }

  func renderDebug() {
    let red = cf_color_red()
    cf_draw_push_color(red)
    for enemy in state.enemies {
      cf_draw_box(enemy.bounds, 0.1, 0)
    }
    for beam in state.playerBeams {
      cf_draw_box(beam.bounds, 0.1, 0)
    }
    cf_draw_pop_color()
  }
}
