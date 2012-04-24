class Organism {
	PVector loc;
	PVector vel;
	PVector acc;
	float r;
	float visionR;
	float maxVel;
	float foodRank;
	float startDiet;
	float calories;
	boolean hunting;
	boolean hunted;

	color c1;
	color c2;

	Organism(float[] orgStats){
		this.foodRank = orgStats[0];
		this.r = orgStats[1]/2;
		this.visionR = orgStats[2]/2;
		this.maxVel = orgStats[3];
		this.startDiet, this.calories = orgStats[4];

		this.hunting = false;
		
		colorize(int(foodRank));

		loc = new PVector(random(r, width - r), random(r, height - r));

		vel = new PVector(random(-maxVel, maxVel),random(-maxVel, maxVel));
		
		acc = new PVector(0,0);
	}

	void colorize(int foodRank){
		switch(foodRank){
			case 0:
				c1 = color(random(0,50),random(150,255),random(0,50));
				break;
			case 1:
				c1 = color(random(0,50),random(0,50),random(150,255));
				break;
			case 2:
				c1 = color(random(150,255),random(0,50),random(0,50));
				break;
		}
		c2 = color(c1, 10);
	}

	void run(ArrayList organisms){
		if (foodRank != 0){
			interact(organisms);
			if (diet >= 2*orgStats[4]) reproduce();
		}
		update();
		render();
	}

	void interact(ArrayList organisms){
		if (foodRank < 2) findPred(organisms);
		if (!hunted) findPrey(organisms);
	}

	void findPred(ArrayList organisms){
		hunted = false;
		for (int i = 0; i < organisms.size(); i++){
			Organism other = (Organism) organisms.get(i);
			if ((this.foodRank == other.foodRank - 1) && (loc.dist(other.loc) < visionR)){
				acc.add(steer(other.loc));
				acc.mult(-1);
				hunted = true;
				break;
			}
		}

	}

	void findPrey(ArrayList organisms){
		hunting = false;
		for (int i = 0; i < organisms.size(); i++){
			Organism other = (Organism) organisms.get(i);
			if ((this.foodRank == other.foodRank + 1) && (loc.dist(other.loc) < visionR)){
				if(loc.dist(other.loc) <= r){
					ecosystem.killOrganism(this.foodRank - 1, i, other.calories*.25, other.loc);
					diet += other.calories*.75;
					hunting = false;
					break;
				}

				acc.add(steer(other.loc));
				hunting = true;
				break;
			}
		}		
	}

	PVector steer(PVector target){
		PVector steer;  // The steering vector
	    PVector desired = target.sub(target,loc);  // A vector pointing from the location to the target
	    float d = desired.mag(); // Distance from the target is the magnitude of the vector
	    // If the distance is greater than 0, calc steering (otherwise return zero vector)
	    if (d > 0) {
			// Normalize desired
			desired.normalize();
			desired.mult(maxVel);
			// Steering = Desired minus Velocity
			steer = target.sub(desired,vel);
			steer.limit(maxVel);  // Limit to maximum steering force
	    } else {
	    	steer = new PVector(0,0);
	    }
	    return steer;
	}

	void reproduce(){
		ecosystem.spawn(ecoStats[int(foodRank)], loc);
		diet -= this.startDiet;
	}

	void update() {
		if ((hunting == false) && (hunted == false)){

			// Update velocity
			vel.add(new PVector(random(-1,1),random(-1,1)));
			vel.limit(maxVel);


		} else{
			vel.add(acc);
			vel.limit(maxVel); 
		}

		checkWallCollision();

		// Update org position
		loc.add(vel);

		acc.mult(0);

	}

	void checkWallCollision(){
		if (loc.x < r ) {
			vel.x = 1;
		}
		if (loc.x > width - r) {
			vel.x = -1;
		}
		if (loc.y < r) {
			vel.y = 1;
		}
		if (loc.y > height - r) {
			vel.y = -1;
		}
	}

	void render(){
		// Draw
		fill(c2);
		ellipse(loc.x, loc.y, visionR*2, visionR*2);
		fill(c1);
		ellipse(loc.x, loc.y, r*2, r*2);

	}

	void move(PVector newLoc){
		loc.set(newLoc);
	}
}