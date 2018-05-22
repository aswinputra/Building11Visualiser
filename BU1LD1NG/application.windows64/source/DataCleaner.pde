class DataCleaner {
  String inFileName;
  String outFileName;
  PeopleCounter sensor;
  final String DATE = "DATE";
  final String TIME = "TIME";
  final String IN = "In";
  final String OUT = "Out";

  DataCleaner(String inFileName, String outFileName, PeopleCounter sensor) {
    this.inFileName = inFileName;
    this.outFileName = outFileName;
    this.sensor = sensor;
  }

  public void cleanInData() {
    Table cleanTable = new Table();
    cleanTable.addColumn(DATE, Table.STRING);
    cleanTable.addColumn(TIME, Table.STRING);
    cleanTable.addColumn(IN, Table.INT);
    cleanTable.addColumn(OUT, Table.INT);

    Table rawInTable = loadTable(inFileName);
    Table rawOutTable = loadTable(outFileName);
    int dateTimeCol = 0;
    int countCol = 1;
    for (int rowNum = 0; rowNum < rawInTable.getRowCount(); rowNum++) {
      String dateTime = rawInTable.getString(rowNum, dateTimeCol);
      String[] splittedDateTime = dateTime.split(" ");

      TableRow row = cleanTable.addRow();
      row.setString(DATE, splittedDateTime[0]);
      row.setString(TIME, splittedDateTime[1]);
      row.setInt(IN, rawInTable.getInt(rowNum, countCol));
      row.setInt(IN, rawOutTable.getInt(rowNum, countCol));
    }

    println(cleanTable.getRowCount() + " total rows in cleanTable"); 

    saveDataInSensorObject(cleanTable);
  }

  private void saveDataInSensorObject(Table cleanTable) {
    ArrayList<PCDay> days = new ArrayList<PCDay>();
    PCTime pcTime = null;
    for (TableRow row : cleanTable.rows()) {
      PCDay pcDay = null;
      //checking for the any existing date
      for (PCDay d : days) {
        if (d.isThisDate(row.getString(DATE))) {
          pcDay = d;
        }
      }

      //if it doesn't exist yet, create one and add it to the list
      if (pcDay == null) {
        pcDay = new PCDay(row.getString(DATE));
        days.add(pcDay);
      }

      pcTime = new PCTime(row.getString(TIME));
      pcTime.inCount = row.getInt(IN);
      pcTime.outCount = row.getInt(OUT);
      pcDay.addTime(pcTime);
    }
    sensor.setDays(days);
  }
}