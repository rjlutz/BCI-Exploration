public static String[] WAVE_NAMES = {"alpha", "beta",  "gamma",  "delta",  "theta"};
// a little bit of a hack, since processing stores colors in an int and color()
// can't be called from a static context.

public class Channels extends ArrayList<Channel> {

  public Channels(int _n) {
    for (int n =0; n < _n; n++) { // process n data channels
      add(new Channel()); 
    }
  }
  
}
