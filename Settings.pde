static class Settings
{
  static float MAX_SPEED = 10;
  static float ENERGY_CONSERVED = .5;
  static float DEAD_ZONE = 10;
  static float SAMPLE_DIAMETER = 66.7;
  static float SAMPLE_RADIUS = SAMPLE_DIAMETER / 2;
  static Study app;
  static PImage zoomImage;
  static float zoom = false;
  static boolean zoomReleased = false;
  static float ratio = 0;
  static boolean GroupMove = false;
}
