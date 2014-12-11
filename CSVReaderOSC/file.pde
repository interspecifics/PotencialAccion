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

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  n = 0;

}

// function colorA will receive changes from 
// controller with name colorA
public void colorA(int theValue) {
  println("a button event from Select a file to process:: "+theValue);
  c1 = c2;
  c2 = color(0,160,100);
 selectInput("Select a file to process:", "fileSelected");

}


