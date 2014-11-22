// The following short CSV file called "mammals.csv" is parsed 
//Load CVS file from url
//interspecifics.cc/potencial/dataset


Table table;

void setup() {
  
  table = loadTable("http://interspecifics.cc/potencial/dataset/01gibran/gibran-02-18.11.2014.10.44.42.csv", "header");

  println(table.getRowCount() + " total rows in table"); 

  
}

