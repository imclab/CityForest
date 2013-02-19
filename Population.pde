//Thank you Daniel Shiffman

class Population { 
  float mutationRate;
  ArrayList<Building> buildings;
  ArrayList<Building> darwin;
  int generations;
  int xConstrain;
  int zConstrain;
  int spread; 

  int breedingAge;
  int breedingFreq;

  int order;
  color c1;

  Population(float m, 
             int num, 
             color c1_, 
             int xConstrain_, 
             int zConstrain_, 
             int breedingAge_, 
             int breedingFreq_) {
    c1 = c1_;
    xConstrain = xConstrain_;
    zConstrain = zConstrain_;
    breedingAge = breedingAge_;
    breedingFreq = breedingFreq;
    spread = 700;

    mutationRate = m;
    buildings = new ArrayList<Building>();
    darwin = new ArrayList<Building>();
    generations = 0;

    for (int i = 0; i < num; i++) {
      int beginX = int(random(-spread, spread));
      int beginZ = int(random(-spread, spread));
      PVector location = new PVector(beginX, height-20, beginZ);



      ExtrudeShape e = new ExtrudeShape(c1);


      int numVertex = 4;
      int random1 = int(random(30, 100));
      int random2 = int(random(30, 100));
      e.addVertex(0, 0);
      e.addVertex(random1, 0);
      e.addVertex(random1, random2);
      e.addVertex(0, random2);
      //add vertexes
      int nls = int(random(30, 200));
      int growthRate = int(random(-2, 7));
      int heightCap = int(random(400, 700));
      int seedSpread = int(random(500, 800));

      DNA dna = new DNA(e, 
                        location,
                        seedSpread,
                        nls,
                        growthRate);

      Building b = new Building(dna, nls, growthRate, heightCap);
      buildings.add(b);
    }
  }

  void live() {
    for (Building b: buildings) {
      b.isColliding(buildings);
      b.run(buildings);
      //b.breed();
    }
    for (int i = 0; i < buildings.size(); i++) {
      if (buildings.get(i).dead) {
        buildings.remove(i);
      }
    }
  }
  
  void breed() {
   
  }

  void calcFitness() {
    for (int i = 0; i < buildings.size(); i++) {
      buildings.get(i).calcFitness();
    }
    order = 1;
  }

  void naturalSelection() {
    println("select");
    darwin.clear();

    float totalFitness = getTotalFitness();

    for (int i = 0; i < buildings.size(); i++) {
      float fitnessNormal = buildings.get(i).fitness / totalFitness;
      int n = (int) (fitnessNormal * 50000);  // Arbitrary multiplier, consider mapping fix
      for (int j = 0; j < n; j++) {
        darwin.add(buildings.get(i));
      }
    }
  }

  void generate() {
    for (int i = 0; i < buildings.size(); i++) {
      int m = int(random(darwin.size()));
      int d = int(random(darwin.size()));
      Building mom = darwin.get(m);
      Building dad = darwin.get(d);

      DNA momgenes = mom.dna;
      DNA dadgenes = dad.dna;
      DNA child = momgenes.crossover(dadgenes);
      child.mutate(mutationRate);
      //PVector location = new PVector(start.r.x+start.r.width/2,start.r.y+start.r.height/2);
      //buildings[i] = new Building(child);
      
    }
    generations++;
  }

  int getGenerations() {
    return generations;
  }

  //compute total fitness for the buildings
  float getTotalFitness() {
    float total = 0;
    for (int i = 0; i < buildings.size(); i++) {
      total += buildings.get(i).fitness;
    }
    return total;
  }
}

/*
-symbiotic relationships
 -build on dead buildings
 */
