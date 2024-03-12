import de.bezier.guido.*;
public final static int NUMS_ROWS = 10;
public final static int NUMS_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>() ; //ArrayList of just the minesweeper buttons that are mined
//private int countFlagged = 0;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUMS_ROWS][NUMS_COLS];
  for (int r = 0; r<NUMS_ROWS; r++) {
    for (int c = 0; c<NUMS_COLS; c++) {
      buttons[r][c]= new MSButton (r, c);
    }
  }

  for (int i= 0; i<10; i++) {
    setMines();
  }
}
public void setMines()
{
  int row = (int)(Math.random()*NUMS_ROWS);
  int col = (int)(Math.random()*NUMS_COLS);
  if (!mines.contains(buttons[row][col])) {
    mines.add(buttons[row][col]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int countUntouchedMines= 0 ;
  int spaces = 0;
  for (int r= 0; r<NUMS_ROWS; r++) {
    for (int c = 0; c<NUMS_COLS; c++) {
      if (buttons[r][c].clicked == false && mines.contains(buttons[r][c])== true) {
        countUntouchedMines++;
      }  
      if (buttons[r][c].clicked==true&&mines.contains(buttons[r][c])==false) {
        spaces++;
      }
    }
  }
  if (countUntouchedMines == mines.size() && spaces == (NUMS_ROWS*NUMS_COLS-mines.size())) {
    return true;
  }else{
  return false;
  }
}
public void displayLosingMessage()
{
  for(int r = 0; r<NUMS_ROWS; r++){
    for(int c= 0; c<NUMS_COLS; c++){
      if(!buttons[r][c].clicked){
        buttons[r][c].mousePressed();
      }
    }
  }
     
  buttons[NUMS_ROWS/2][NUMS_COLS/2].setLabel("LOSER");
}
public void displayWinningMessage()
{
  buttons[NUMS_ROWS/2][NUMS_COLS/2].setLabel("WINNER!!!");
}
public boolean isValid(int r, int c)
{
  if (r>=0&&r<NUMS_ROWS&&c>=0&&c<NUMS_COLS)
  {


    return true;
  }


  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++) {
      if (isValid(r, c)==true&& mines.contains(buttons[r][c])) {
        numMines++;
      }
      if (mines.contains(buttons[row][col])) {
        numMines--;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUMS_COLS;
    height = 400/NUMS_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {
    //if (clicked==true) {
    //  return;
    //}
    clicked = true;


    if (mouseButton==RIGHT) {
      if (flagged==true) {
        flagged = false;
        clicked = false;
      } else if (flagged==false) {
        flagged = true;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0) {
      setLabel(countMines(myRow, myCol));
    } else {
      if (isValid(myRow, myCol)&&!mines.contains(buttons[myRow][myCol])) {
        for (int r = myRow-1; r<=myRow+1; r++) {    
          for (int c = myCol-1; c<=myCol+1; c++) {
            if (isValid(r, c)==true&&!buttons[r][c].clicked) {
              buttons[r][c].mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw ()
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(219, 107, 195);
    else if (clicked)
      fill(200,200,200);
    else
      fill(100);

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
