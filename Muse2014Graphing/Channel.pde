public class Channel extends ArrayList<Wave> {
                                       
  public Channel() {
    for (int i = 0; i < WAVE_NAMES.length; i++) 
      add(new Wave(WAVE_NAMES[i], WAVE_COLORS.get(i)));
  }
  
  public Wave getWave(String _name) {
    for (Wave w : this) 
      if (_name.equals(w.getName())) return w;
    return null;
  }

}

