class Chromosome{
  
  float fitness;
  boolean alive;
  float mutation_factor = 0.01;
  float new_neuron_probability = 0.05 * mutation_factor;
  
  Neuron[] neurons;
  int input_count, output_count;
  
  Chromosome(int in_count, int out_count) {
    // Constructor
    
    alive = true;
    fitness = 0;
    
    input_count = in_count;
    output_count = out_count;
    
    // start with only one neuron, the output neuron
    neurons = new Neuron[input_count + output_count + 1];
    
    // initialize neurons
    for(int neuron_index = 0; neuron_index< neurons.length; neuron_index++){
      neurons[neuron_index] = new Neuron(neurons.length);
    }
    
    // input and bias neurons
    for(int neuron_index = 0; neuron_index< input_count+1; neuron_index++){
      neurons[neuron_index].position_x = 0; // first neurons are the inputs and the bias, on the far left of the network
      neurons[neuron_index].position_y = map(neuron_index,-1,input_count+1,0,1);
    }
    
    
    

    // output neurons
    for(int neuron_index = input_count+1; neuron_index< neurons.length; neuron_index++){
      neurons[neuron_index].position_x = 1; // the other neurons are output neurons, on the far right of the network
      neurons[neuron_index].position_y = map(neuron_index,input_count,neurons.length,0,1);
    }

  }
  
  
  
  float[] think(float[] input) {
    // Processes input vector and yield output vector
    
    // store the input in the first neurons
    for(int neuron_index = 0; neuron_index< input_count; neuron_index++){
      neurons[neuron_index].output = input[neuron_index];
    }
    
    // set bias neuron to 1
    neurons[input_count].output = 1;
    
    // must start with neurons on the left
    int current_neuron_index = get_next_neuron_index(0);
    
    while(current_neuron_index != -1) {
            
      for(int input_index = 0; input_index<neurons.length; input_index++ ){
        if(neurons[input_index].position_x<neurons[current_neuron_index].position_x){
          neurons[current_neuron_index].synaptic_sum += neurons[input_index].output*neurons[current_neuron_index].synapses[input_index];
        }
      }
      neurons[current_neuron_index].activate();
      
      current_neuron_index = get_next_neuron_index(neurons[current_neuron_index].position_x);
    }
    
    
    float[] output = new float[output_count];
    for(int neuron_index = input_count+1; neuron_index< input_count+1+output_count; neuron_index++){
      
      // process output
      for(int input_index = 0; input_index<neurons.length; input_index++ ){
        if(neurons[input_index].position_x<neurons[neuron_index].position_x){
          neurons[neuron_index].synaptic_sum += neurons[input_index].output*neurons[neuron_index].synapses[input_index];
        }
      }
      neurons[neuron_index].activate();
      output[neuron_index-input_count-1] = neurons[neuron_index].output;
    }
    
    return output;

  }
  
  
  void add_neuron(){
    
    // create a new neuron object with as many synapses as the others
    Neuron[] current_neurons = neurons;
    neurons = new Neuron[neurons.length+1];

    
    // prepare a new neuron
    Neuron new_neuron = new Neuron(neurons.length);
    
    for(int current_neuron_index= 0; current_neuron_index<current_neurons.length; current_neuron_index++){
      neurons[current_neuron_index] = current_neurons[current_neuron_index];
    }
    
    neurons[neurons.length-1] = new_neuron;

    // add a synapse to all old neurons
    for(int neuron_index = 0; neuron_index< neurons.length-1; neuron_index++){
      neurons[neuron_index].synapses = append(neurons[neuron_index].synapses,random(-1,1));
    }
    
  }
  
  
  int get_next_neuron_index(float current_position){
    
    int next_neuron_index = -1;
    float next_neuron_position_x = 1;
    
    for(int neuron_index = 0; neuron_index<neurons.length; neuron_index ++){
      if(neurons[neuron_index].position_x > current_position){
        if(neurons[neuron_index].position_x < next_neuron_position_x) {
          next_neuron_position_x = neurons[neuron_index].position_x;
          next_neuron_index = neuron_index;
        }
      }
    }
    return next_neuron_index;
  }
  
  
  
  void born_from(Chromosome parent){
    
    neurons = new Neuron[parent.neurons.length];
    for(int neuron_index = 0; neuron_index<neurons.length; neuron_index ++){
      neurons[neuron_index] = new Neuron(parent.neurons[neuron_index].synapses.length);
      neurons[neuron_index].position_x = parent.neurons[neuron_index].position_x;
      neurons[neuron_index].position_y = parent.neurons[neuron_index].position_y;
      for(int synapse_index = 0; synapse_index<neurons[neuron_index].synapses.length; synapse_index++){
        neurons[neuron_index].synapses[synapse_index] = parent.neurons[neuron_index].synapses[synapse_index] + mutation_factor * randomGaussian();
      }
    }
    
    if(random(0,1) < new_neuron_probability){
      add_neuron();
    }
  }
  

  void display(float pos_x, float pos_y, float w, float h){
    fill(255);
    ellipseMode(CENTER);

    // inter-neuron synapses
    for(int neuron_index = 0; neuron_index< neurons.length; neuron_index++){
      
      float line_start_x = map(neurons[neuron_index].position_x,0,1,pos_x-0.5*w,pos_x+0.5*w);
      float line_start_y = map(neurons[neuron_index].position_y,0,1,pos_y-0.5*h,pos_y+0.5*h);

      for(int input_index = 0; input_index<neurons.length; input_index++ ){
        // take only neurons before self as input
        if(neurons[input_index].position_x<neurons[neuron_index].position_x){

          float line_end_x = map(neurons[input_index].position_x,0,1,pos_x-0.5*w,pos_x+0.5*w);
          float line_end_y = map(neurons[input_index].position_y,0,1,pos_y-0.5*h,pos_y+0.5*h);
          
          if(neurons[neuron_index].synapses[input_index] > 0) {
            stroke(255,255,255,127);
          }
          else {
            stroke(255,0,0,127);
          }
          line(line_start_x,line_start_y, line_end_x, line_end_y);
        
        }
      }
      
      float radius = 0.05*min(w,h);
      neurons[neuron_index].display(line_start_x, line_start_y, radius);
    }
  }
}
