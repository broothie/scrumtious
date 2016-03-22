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
    // Initialize data structures
    interactables = new ArrayList();
    interactables.add(new PlusButton(0.92, 0.90, 0.05));
    currentSticky = null;

    // Set up backspace KeyTrap
    KeyTrap.trap(document.getElementById('stage'), [8], function(){
        if(currentSticky != null){
            currentSticky.content = currentSticky.content.substr(0, currentSticky.content.length - 1);
        }
    });
}


void draw(){
    size(window.innerWidth, window.innerHeight);

    // Draw columns
    float columnInterval = ceil(width/COLUMNS.length);
    noStroke();
    textAlign(CENTER, TOP);
    textSize(30);
    for(int counter = 0; counter < COLUMNS.length; counter++){
        // Draw columns
        fill(COLUMNS[counter].hue);
        rect(counter*columnInterval, 0, columnInterval, height);
        // Draw titles
        fill(#000000);
        text(COLUMNS[counter].title, counter*columnInterval, 0, columnInterval, height);
    }

    // Update everything
    for(int counter = 0; counter < interactables.size(); counter++){
        Interactable interactable = (Interactable) interactables.get(counter);
        interactable.paint();
    }
}


void mousePressed(){
    // Execute whatever interactable is current
    for(int counter = 0; counter < interactables.size(); counter++){
        Interactable interactable = (Interactable) interactables.get(counter);
        if(interactable.isMousedOver()){
            interactable.execute();
            return;
        }
    }
}


boolean shiftDown = false;
void keyPressed(){
    if(key == CODED){
        if(keyCode == SHIFT){
            shiftDown = true;
        }
    }else{
        if(currentSticky != null){
            currentSticky.content += shiftDown ? str(key).toUpperCase() : str(key).toLowerCase();
        }
    }
}
void keyReleased(){
    if(key == CODED){
        if(keyCode == SHIFT){
            shiftDown = false;
        }
    }
}
