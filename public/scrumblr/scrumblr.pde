/**
  Scrumblr runtime
*/

ArrayList interactables;
Sticky currentSticky;
Column[] COLUMNS = {
    new Column("TODO", color(#FA8072)),
    new Column("In Progress", color(#00FF7F)),
    new Column("Done", color(#1E90FF))
};


void setup(){
    size(window.innerWidth, window.innerHeight);
    // size(500, 500);
    interactables = new ArrayList();
    interactables.add(new PlusButton('+', 0.92, 0.9, 0.07, color(#FAFAD2)));
}


void draw(){
    // println(mouseX, mouseY);
    // Overwrite previous draw loop
    size(window.innerWidth, window.innerHeight);
    background(#FFFAFA);

    // Draw columns
    float columnInterval = ceil(width/COLUMNS.length);
    noStroke();
    for(int counter = 0; counter < COLUMNS.length; counter++){
        fill(COLUMNS[counter].hue);
        rect(counter*columnInterval, 0, columnInterval, height);
        // TODO Add text to top of screen
    }

    // Update everything
    for(int counter = 0; counter < interactables.size(); counter++){
        Interactable interactable = (Interactable) interactables.get(counter);
        interactable.update();
    }
}

void mousePressed(){
    for(int counter = 0; counter < interactables.size(); counter++){
        Interactable interactable = (Interactable) interactables.get(counter);
        if(interactable.isMousedOver()){
            interactable.execute();
            return;
        }
    }
}

void keyPressed(){
    if(currentSticky != null){
        currentSticky.content += key;
    }
}
