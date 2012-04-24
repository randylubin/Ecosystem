class Ecosystem{
	ArrayList organisms;

	Ecosystem(){
		organisms = new ArrayList();
	}

	void run() {
		for (int i = 0; i < organisms.size(); i++){
			Organism o = (Organism) organisms.get(i);
			o.run(organisms);
		}
	}

	void addOrganism(Organism o){
		organisms.add(o);
	}

	void spawn(float[] oS, PVector l){	
		Organism o;
		o = new Organism(oS);
		l.add(new PVector(random(-3,3),random(-3,3)));
		o.move(l);
		addOrganism(o);	
	}

	void decompose(PVector l, int pop){
		for (int i = 0; i < pop; i++){
			Organism o;
			o = new Organism(ecoStats[0]);
			l.add(new PVector(random(-3,3),random(-3,3)));
			o.move(l);
			addOrganism(o);	
		}
	}

	void killOrganism(float fr, int i, float cal, PVector l){
		organisms.remove(i);
		if (fr > 0){
			decompose(l, int(cal));
		}
	}
}