void training_data_init(){
  
  training_inputs_table = loadTable("training_inputs.csv");
  training_outputs_table = loadTable("training_outputs.csv");
  
  // initialize training arrays
  training_inputs = new float[training_inputs_table.getColumnCount()][training_inputs_table.getRowCount()];
  training_outputs = new float[training_outputs_table.getColumnCount()][training_outputs_table.getRowCount()];
  
  for (int column=0; column<training_inputs_table.getColumnCount(); column++) {
    for (int row=0; row<training_inputs_table.getRowCount(); row++){
      training_inputs[column][row] = training_inputs_table.getFloat(row,column);
    }
  }
  
  for (int column=0; column<training_outputs_table.getColumnCount(); column++) {
    for (int row=0; row<training_outputs_table.getRowCount(); row++){
      training_outputs[column][row] = training_outputs_table.getFloat(row,column);
    }
  }
  
}
