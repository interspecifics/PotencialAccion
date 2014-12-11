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

public class SimpleButton
{
    float x, y, width, height;
    boolean on;
    
    SimpleButton ( float xx, float yy, float w, float h )
    {
        x = 70; y = 60; width = w; height = h/3;
        
        Interactive.add( this ); // register it with the manager
    }
    
    // called by manager
    
    void mousePressed () 
    {
        on = !on;
        selectInput("Select a file to process:", "fileSelected");

    }

    void draw () 
    {
        if ( on ) fill( 60 );
        else fill( 255 );
        
        rect(x, y, width, height);
    }
}

