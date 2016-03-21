/**
  Scrumboard Processing file
*/

Column[] COLUMNS = {
    new Column("TODO", color(#FFFFFF, 0)),
    new Column("In Progress", color(#00FF00)),
    new Column("Done", color(#0000FF))
};

void setup(){
    size(window.innerWidth, window.innerHeight);

    // createButton = new Button(width, height);
}


void draw(){
    // Overwrite previous draw loop
    size(window.innerWidth, window.innerHeight);
    background(#FFFFFF);

    // Draw columns
    float columnInterval = width/COLUMNS.length;
    noStroke();
    for(int counter = 0; counter < COLUMNS.length; counter++){
        fill(COLUMNS[counter].hue);
        rect(counter*columnInterval, 0, columnInterval, height);
        // TODO Add text to top of screen
    }
}

class Column {
    public String title;
    public color hue;

    Column(String t, color h) {
        title = t;
        hue = h;
    }
}


static class StickyButton {
    color BUTTON_COLOR = color(#FF0000);
    float xPosition, yPosition;

    StickyButton(x, y) {
        xPosition = x;
        yPosition = y;
    }

    void update(){
        rect(xPosition, yPosition, bw, by);
    }
}
