/**
  Scrumblr models
*/

class Column {
    public String title;
    public color hue;

    Column(String txt, color hu) {
        this.title = txt;
        this.hue = hu;
    }
}

class Drawable {
    private float xPosDraw;
    private float yPosDraw;
    private float xSizeDraw;
    private float ySizeDraw;

    private void paint();
}


class Interactable extends Drawable {
    private float xPos;
    private float yPos;
    private float xSize;
    private float ySize;
    private float xScale;
    private float yScale;
    private float xSizeScale;
    private float ySizeScale;
    private color hue;

    public void execute();
    public void update();

    private boolean isMousedOver();

    // boolean isMousedOver(){
    //     return this.xPos - this.xSize/2 < mouseX &&
    //            mouseX < this.xPos + this.xSize/2 &&
    //            this.yPos - this.ySize/2 < mouseY &&
    //            mouseY < this.yPos + this.ySize/2;
    // }
}


class Button extends Interactable {
    public String label;
    public float xScale, yScale, dimScale;
    public color hue;

    Button(String txt, float x_scale, float y_scale, float dim_scale, color hu){
        this.label = txt;
        this.xScale = x_scale;
        this.yScale = y_scale;
        this.dimScale = dim_scale;
        this.hue = hu;
    }

    void execute(){
        // println("IT HAPPENED!");
        currentSticky = new Sticky('', mouseX, mouseY, 0.1);
        interactables.add(currentSticky);
    }

    void update(){
        // Update location data
        this.xPos = width * this.xScale;
        this.yPos = height * this.yScale;
        this.xSize = this.ySize = width * this.dimScale;
        // Draw
        this.paint();
    }

    void paint(){
        // Draw shape
        noStroke();
        fill(this.hue);
        ellipse(this.xPos, this.yPos, this.xSize, this.ySize);

        // Highlight if necessary
        if(this.isMousedOver()){
            stroke(#000000);
            noFill();
            ellipse(this.xPos, this.yPos, this.xSize, this.ySize);
        }

        // Draw text
        noStroke();
        fill(color(#000000));
        text(this.label, this.xPos, this.yPos, this.xSize, this.ySize);
    }
}


class Sticky extends Interactable {
    public String content;
    public float xScale, yScale, dimScale;
    public color hue;

    Sticky(String txt, float x_scale, float y_scale, float dim_scale){
        this.content = txt;
        this.xScale = x_scale;
        this.yScale = y_scale;
        this.dimScale = dim_scale;

        this.hue = color(#FAFAD2);
    }

    void execute(){
        if(currentSticky == this){
            currentSticky = null;
            this.xScale = this.xPos/width;
            this.yScale = this.yPos/height;
        }else{
            currentSticky = this;
        }
    }

    void update(){
        if(currentSticky == this){
            this.xPos = mouseX - this.xSize/2;
            this.yPos = mouseY - this.ySize/2;
            this.xSize = this.ySize = width * dimScale;
        }else{
            this.xPos = (width * this.xScale) - this.xSize/2;
            this.yPos = (height * this.yScale) - this.ySize/2;
            this.xSize = this.ySize = width * dimScale;
        }
        this.paint();
    }

    void paint(){
        // Draw shape
        noStroke();
        fill(this.hue);
        rect(this.xPos, this.yPos, this.xSize, this.ySize);

        // Highlight if necessary
        if(this.isMousedOver()){
            stroke(#000000);
            noFill();
            rect(this.xPos, this.yPos, this.xSize, this.ySize);
        }

        // Draw text
        noStroke();
        fill(#000000);
        text(this.xPos - this.xSize/2, this.yPos - this.ySize/2, this.xSize, this.ySize)
    }
}
