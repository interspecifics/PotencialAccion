void fileSelected(File selection) {
  
  filename = selection.getAbsolutePath();

  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
      try {
    mBr = new BufferedReader(new FileReader(selection.getAbsolutePath()));
    mBr.readLine();
  }
  catch(Exception e) {}
    println("User selected " + selection.getAbsolutePath());
  }
}


