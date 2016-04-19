/**
  Scrumblr models
*/

final color STICKY_COLOR = color(#FAFAD2);

class Column {
    public String title;
    public color hue;

    Column(String txt, color hu) {
        this.title = txt;
        this.hue = hu;
    }
}

class Drawable {
    private float xDrawPos;
    private float yDrawPos;
    private float xDrawSize;
    private float yDrawSize;

    public void paint();
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

    Interactable(float x_scale, float y_scale, float x_size_scale, float y_size_scale, color hu){
        this.xScale = x_scale;
        this.yScale = y_scale;
        this.xSizeScale = x_size_scale;
        this.ySizeScale = y_size_scale;
        this.hue = hu;
    }

    private void update();
    private boolean isMousedOver();

    public void execute();
}


class Button extends Interactable {
    private String label;
    private float sizeScale;
    private float size;
    private float drawSize;

    Button(String txt, float x_scale, float y_scale, float size_scale, color hu){
        super(x_scale, y_scale, size_scale, size_scale, hu);
        this.label = txt;
        this.sizeScale = size_scale;
    }

    private boolean isMousedOver(){
        return dist(this.xPos, this.yPos, mouseX, mouseY) < this.xSize/2;
    }

    private void update(){
        // Update location data
        this.xPos = width * this.xScale;
        this.yPos = height * this.yScale;
        this.size = this.xSize = this.ySize = width * this.sizeScale;
        // Update draw location data
        this.xDrawPos = this.xPos;
        this.yDrawPos = this.yPos;
        this.xDrawSize = this.yDrawSize = this.size;
    }

    public void paint(){
        // Update
        this.update();
        // Draw shape
        noStroke();
        fill(this.hue);
        ellipse(this.xDrawPos, this.yDrawPos, this.xDrawSize, this.yDrawSize);

        // Highlight if necessary
        if(this.isMousedOver()){
            stroke(#000000);
            noFill();
            ellipse(this.xDrawPos, this.yDrawPos, this.xDrawSize, this.yDrawSize);
        }

        // Draw text
        noStroke();
        fill(color(#000000));
        textAlign(CENTER, CENTER);
        textSize(20);
        text(this.label, this.xDrawPos-this.xDrawSize/2, this.yDrawPos-this.yDrawSize/2, this.xDrawSize, this.yDrawSize);
    }
}


class PlusButton extends Button {
    final String LABEL = "+";
    final color HUE = STICKY_COLOR;

    PlusButton(x_scale, y_scale, size_scale){
        super(this.LABEL, x_scale, y_scale, size_scale, this.HUE);
    }

    // private void update(){
    //     super();
    //     if(currentSticky == null){
    //         this.label = "+";
    //     }else{
    //         this.label = "-";
    //     }
    // }

    public void execute(){
        if(currentSticky == null){
            currentSticky = new Sticky('', mouseX, mouseY, 0.1);
            interactables.add(currentSticky);
        }else{
            interactables.remove(currentSticky);
            currentSticky = null;
        }
    }
}


class Sticky extends Interactable {
    public String content;
    final color HUE = STICKY_COLOR;
    private float sizeScale;
    private float size;
    private float drawSize;
    public int index;

    public static int count;

    Sticky(String txt, float x_scale, float y_scale, float size_scale){
        super(x_scale, y_scale, size_scale, size_scale, this.HUE);
        this.content = txt;
        this.sizeScale = size_scale;
        this.index = Sticky.count++;
    }

    private boolean isMousedOver(){
        return this.xDrawPos < mouseX &&
               mouseX < this.xDrawPos + this.xDrawSize &&
               this.yDrawPos < mouseY &&
               mouseY < this.yDrawPos + this.yDrawSize;
    }

    public void execute(){
        if(currentSticky == this){
            currentSticky = null;
            this.xScale = this.xPos/width;
            this.yScale = this.yPos/height;
        }else{
            currentSticky = this;
        }
    }

    private void update(){
        if(currentSticky == this){
            this.xPos = mouseX;
            this.yPos = mouseY;
        }else{
            this.xPos = width * this.xScale;
            this.yPos = height * this.yScale;
        }
        this.size = this.xSize = this.ySize = width * sizeScale;
        this.xDrawPos = this.xPos - this.xSize/2;
        this.yDrawPos = this.yPos - this.ySize/2;
        this.xDrawSize = this.yDrawSize = this.size;
    }

    public void paint(){
        // Update
        this.update();
        // Draw shape
        noStroke();
        fill(this.hue);
        rect(this.xDrawPos, this.yDrawPos, this.xDrawSize, this.yDrawSize);

        // Highlight if necessary
        if(this.isMousedOver()){
            stroke(#000000);
            noFill();
            rect(this.xDrawPos, this.yDrawPos, this.xDrawSize, this.yDrawSize);
        }

        // Draw text
        noStroke();
        fill(#000000);
        textAlign(CENTER, CENTER);
        textSize(17);
        text(this.content, this.xDrawPos, this.yDrawPos, this.xDrawSize, this.yDrawSize);
    }
}
