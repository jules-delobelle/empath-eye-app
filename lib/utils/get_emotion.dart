String getEmotion(String? emotion){
  switch (emotion?.toLowerCase()) {
    case 'joie' :
      return "Joie";
    case 'tristesse' :
      return "Tristesse";
    case 'colere' :
      return "Colère";
    case 'surprise' :
      return "Surprise";
    default :
      return "Émotion non reconnue";
  }
}