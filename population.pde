class Population {

  Chromosome[] chromosomes;
  float min_fitness, max_fitness, mean_fitness;
  int death_toll, generation;
  
  Population(int chromosome_count, int in_count, int out_count) {
    // Constructor
    generation = 0;
    chromosomes = new Chromosome[chromosome_count];
    for(int chromosome_index=0; chromosome_index<chromosomes.length; chromosome_index++){
      chromosomes[chromosome_index] = new Chromosome(in_count,out_count);
    }
  }
  
  void natural_selection() {
    get_fitness_min_max();
    survival_of_the_fittest();
    offspring_of_the_fittest();
    generation ++;
  }

  void get_fitness_min_max() {
    // Gets the best and worst fitness in the population
    
    min_fitness = chromosomes[0].fitness;
    max_fitness = chromosomes[0].fitness;
    mean_fitness = 0;
    
    for(int chromosome_index = 0; chromosome_index < chromosomes.length; chromosome_index ++) {
      if(chromosomes[chromosome_index].fitness < min_fitness) {
        min_fitness = chromosomes[chromosome_index].fitness;
      }
      if(chromosomes[chromosome_index].fitness > max_fitness) {
        max_fitness = chromosomes[chromosome_index].fitness;
      }
      mean_fitness += chromosomes[chromosome_index].fitness/chromosomes.length;
    }
  }
  
  
  void survival_of_the_fittest() {
    // Chromosomes with higher fitness are more likely to survive
    
    death_toll = 0;
    for(int chromosome_index = 0; chromosome_index < chromosomes.length; chromosome_index ++) {
      float survival_probability = 0.00;
      if(min_fitness != max_fitness){
        // Probability of survival depends on how creature compares to others
         survival_probability = map(chromosomes[chromosome_index].fitness, min_fitness, max_fitness,0.00,1.00);
      }
      else {
        // Deal with the case where all chromosomes are identical: 50% chance of dying for everyone
        println("All chromosomes have the same genes");
        survival_probability = 0.5;
      }
      
      // Killing population according to their survival probability
      if(survival_probability < random(0,1)) {
        chromosomes[chromosome_index].alive = false;
        death_toll ++;
      }
    }
  }
  
  
  void offspring_of_the_fittest() {
    // Replacing dead chromosomes with offspring of the survivors
    for(int chromosome_index = 0; chromosome_index < chromosomes.length; chromosome_index ++) {
      if(!chromosomes[chromosome_index].alive) {
        // Try one random creature as a parent
        Chromosome potential_parent = chromosomes[round(random(0,chromosomes.length-1))];
        
        while(!potential_parent.alive) {
          // Keep looking for a parent if the current one is dead
          potential_parent = chromosomes[int(random(0,chromosomes.length-1))];
        }
        // Once a parent is found, generate offspring
        chromosomes[chromosome_index].born_from(potential_parent);
      }
    }
    
    for(int chromosome_index = 0; chromosome_index < chromosomes.length; chromosome_index ++) {
      chromosomes[chromosome_index].alive = true;
      chromosomes[chromosome_index].fitness = 0;
    }
  }
}
