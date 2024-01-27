# More advanced usage

## How to add a Point&Click system

let's disect an example string to make it easier to understand.

` x3508 y1975 l9 2051,2763,331,1257,10, : 2525,3111,1319,1883,100, : 1049,1825,813,1529,100,`

### x/y

now the first 2 values are simple, after the " x" and " y" you put (without a space) the x and y of the total Image.

### l

the " l" value defines the line in which you want to trigger this Point&Click, so if you say " l9" then the Point&Click system triggers on the 9th script.lua line.

### the csv's (comma seperated values)

(for this step I reccomend ms paint or something similar)

- First 2 values: The first value represents the left most pixel the preson can click. In ms paint hover over the left most pixel you want to include and then in the bottom left of the screen note down the x value (the one before the comma) and then note down the value. Now do the same but for the right most pixel.
- 3th/4th value: Next up we got the 3th/4th value in the list. There are similar to the first 2, but now instead of left and right we got bottom and top which in ms paint is the value after the comma in the bottom left.
- 5th value: this one is simply the line in script.lua for it to move you to, similarly to how ggg and qqq work.
- writing it all down: writing it down is pretty simple after the steps that I just explained, you simple write it down like this 1,2,3,4,5, (left,right,bottom,top,line,).

### the ':'

the ' : ' basically let's the system know there will follow another list of csv's (step above).
