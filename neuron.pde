class Neuron{
  
  float synaptic_sum;
  
  float[] synapses;
  float position_x;
  float position_y;
  
  float output;
  
  Neuron(int synapse_count) {
    // Constructor
    
    // neuron created at a random position in the layer
    position_x = random(0.1,0.9); 
    position_y = random(0.1,0.9);
    
    synaptic_sum = 0;

    synapses = new float[synapse_count];
    
    for(int synapse_index = 0; synapse_index < synapses.length; synapse_index++) {
      synapses[synapse_index] = random(-10,10);
    }
  }
  
  void activate(){
    output = activation(synaptic_sum);
    synaptic_sum = 0;
  }
  
  float activation(float x){
    return 1.0/(1.0+exp(-x)); 
  }

  
  void display(float pos_x, float pos_y, float radius){
    
    
    float col = map(output, 1, 0, 0, 255);
    fill(255,col,col);
    noStroke();
    ellipse(pos_x,pos_y,radius,radius);

  }
}
