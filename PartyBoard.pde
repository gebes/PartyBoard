ArrayList < Particle > pts;
boolean onPressed;

void setup() {
    fullScreen();
    smooth();
    rectMode(CENTER);

    pts = new ArrayList < Particle > ();
    clearBoard();
}

void draw() {


    if (onPressed) {
        for (int i = 0; i < 10; i++) {
            Particle newP = new Particle(mouseX, mouseY, i + pts.size(), i + pts.size());
            pts.add(newP);
        }
    }

    for (int i = 0; i < pts.size(); i++) {
        Particle p = pts.get(i);
        p.update();
        p.display();
    }

    for (int i = pts.size() - 1; i > -1; i--) {
        Particle p = pts.get(i);
        if (p.dead) {
            pts.remove(i);
        }
    }
}

void clearBoard() {
    pts.clear();
    background(255);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(48);
    text("Party Board v1.2020.14", width / 2, 100);
    textSize(24);
    text("by Christoph Krassnigg", width / 2, 140);
    textSize(20);
    text("Linksklick zum Zeichnen / Left click to draw", width / 2, 200);
    textSize(20);
    text("\"c\" drückem um die Leinwand zu leeren / press \"c\" to clear the canvas", width / 2, 225);
}

void mousePressed() {
    onPressed = true;
}

void mouseReleased() {
    onPressed = false;
}

void keyPressed() {
    if (key == 'c') {
        clearBoard();
    }
}

class Particle {
    PVector loc, vel, acc;
    int lifeSpan, passedLife;
    boolean dead;
    float alpha, weight, weightRange, decay, xOffset, yOffset;
    color c;

    Particle(float x, float y, float xOffset, float yOffset) {
        loc = new PVector(x, y);

        float randDegrees = random(360);
        vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
        vel.mult(random(5));

        acc = new PVector(0, 0);
        lifeSpan = int(random(30, 90));
        decay = random(0.75, 0.9);
        c = color(random(255), random(255), random(255));
        weightRange = random(3, 50);

        this.xOffset = xOffset;
        this.yOffset = yOffset;
    }

    void update() {
        if (passedLife >= lifeSpan) {
            dead = true;
        } else {
            passedLife++;
        }

        alpha = float(lifeSpan - passedLife) / lifeSpan * 70 + 50;
        weight = float(lifeSpan - passedLife) / lifeSpan * weightRange;

        acc.set(0, 0);

        float rn = (noise((loc.x + frameCount + xOffset) * 0.01, (loc.y + frameCount + yOffset) * 0.01) - 0.5) * 4 * PI;
        float mag = noise((loc.y + frameCount) * 0.01, (loc.x + frameCount) * 0.01);
        PVector dir = new PVector(cos(rn), sin(rn));
        acc.add(dir);
        acc.mult(mag);

        float randDegrees = random(360);
        PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
        randV.mult(0.5);
        acc.add(randV);

        vel.add(acc);
        vel.mult(decay);
        vel.limit(3);
        loc.add(vel);
    }

    void display() {
        strokeWeight(weight + 1.5);
        stroke(0, alpha);

        noStroke();
        point(loc.x, loc.y);

        strokeWeight(weight);
        stroke(c);
        point(loc.x, loc.y);
    }
}
