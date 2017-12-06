Population my_population;

Table training_inputs_table;
Table training_outputs_table;

float[][] training_inputs;
float[][] training_outputs;

float[][] validation_inputs;
float[][] validation_outputs;

int validation_input_index = 0;


void setup(){
  size(1280,900);
  my_population = new Population(100,9,2);
  
  training_data_init();
  validation_inputs = training_inputs;
  validation_outputs = training_outputs;
  
}


void draw(){

  background(0);
  
  // evaluate fitness function
  for(int chromosome_index = 0; chromosome_index<my_population.chromosomes.length; chromosome_index++){
    float cost = 0.0;
    float error = 0.0;
    for (int training_set_index=0; training_set_index<training_inputs.length; training_set_index++) {

      float[] training_input = training_inputs[training_set_index];
      float[] training_output = training_outputs[training_set_index];
      float[] network_output  = my_population.chromosomes[chromosome_index].think(training_input);
      for (int output_index=0; output_index<training_output.length; output_index++) {
        error += abs(training_output[output_index] - network_output[output_index]);
        cost += 0.5 * (training_output[output_index] - network_output[output_index]) * (training_output[output_index] - network_output[output_index]);
      }
    }
    my_population.chromosomes[chromosome_index].fitness = -error;
  }
  
  // display the first few networks
  int row_count = 4;
  int column_count = 3;
  for(int row=0; row<row_count; row++){
    for(int column=0; column<column_count; column++){
      
      int chromosome_index = column_count*row+column;
      float[] network_output = my_population.chromosomes[chromosome_index].think(validation_inputs[validation_input_index]);
      
      
      float pos_x = map(column,-1,column_count,0,width);
      float pos_y = map(row,-1,row_count,0,height);
      float w = width/(column_count+2);
      float h = height/(row_count+2);
      
      my_population.chromosomes[chromosome_index].display(pos_x,pos_y,w,h);
    }
  }
  

  // Display info
  fill(255);
  textSize(18);
  textAlign(LEFT,UP);
  text("Generation: " + my_population.generation,25,50);
  text("Validation input: " + (validation_input_index+1),200,50);
  text("Min error: " + nf(-100*my_population.max_fitness/training_inputs.length,2,2) +"%",450,50);
  
  // Natural selection
  my_population.natural_selection();
  println("Generation: " + my_population.generation + " max fitness: " + my_population.max_fitness + " mean fitness: " + my_population.mean_fitness + ", min fitness: " + my_population.min_fitness + ", death_toll: " + my_population.death_toll);
  
}




void keyPressed(){
  
  if(keyCode == UP){
    validation_input_index ++;
    if(validation_input_index >= validation_inputs.length){
      validation_input_index = 0;
    }
  }
  else if (keyCode == DOWN){
    validation_input_index --;
    if(validation_input_index < 0){
      validation_input_index = validation_inputs.length-1;
    }
  }
  
}
