abstract class AbstractOnlineGameController {
  void getAvailableGames();
  void joinGame({required String uuid});
  void announceAvailableGame();
  void move();
  void init();
  void mapMessageToFunction();
}