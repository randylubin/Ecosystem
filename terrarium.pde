
int oSize = 25;
float maxspeed = 8;
int width = 800;
int height = 600;
int plantPop = 40;
int preyPop = 10;
int predPop = 2;
float vision = 10*oSize;


// Rank in the ecosystem, diameter, vision radius, maxspeed, starting diet
float[] plantStats = {0,3,3,maxspeed*.1,1};
float[] preyStats = {1,oSize/2,vision*.6,maxspeed*.8,5};
float[] predStats = {2,oSize,vision,maxspeed,25};
float[][] ecoStats = {plantStats, preyStats, predStats};

Ecosystem ecosystem;


void setup(){
	
	size(width, height);
	ecosystem = new Ecosystem();
	for (int i = 0; i < plantPop; i++){
		ecosystem.addOrganism(new Organism(ecoStats[0]));
	}
	for (int i = 0; i < preyPop; i++){
		ecosystem.addOrganism(new Organism(ecoStats[1]));
	}
	for (int i =0; i < predPop; i++){
		ecosystem.addOrganism(new Organism(ecoStats[2]));
	}
	noStroke();
	smooth();
	frameRate(15);
}

void draw(){
	background(52);
	ecosystem.run();
}

void mousePressed(){
	ecosystem.spawn(ecoStats[1], new PVector(mouseX,mouseY));
}
