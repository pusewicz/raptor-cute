@main
class App {
  static func main() async {
    let game = await Game()
    await game.run()
  }
}
