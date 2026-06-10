---
created: 2026-02-14
---

//@version=5
 
strategy("markov", overlay=true, default_qty_type=strategy.percent_of_equity, default_qty_value=100)
 
//Defining the inside day  
condition = close\<close[1] and close[1]\<close[2] and close[2]\<close[3] and close[3]\<close[4] and close[4]\<close[5] and close[5]\<close[6]  
//Preparing exit condition
 
if condition  
strategy.entry("long",strategy.long)   if close\>close[1]  
strategy.close("long")
    ![Exported image](Quant%20Knowledge-20260608%201.png)   
![Exported image](Quant%20Knowledge-20260608.png)  

Heston Model
    
**Better RSI**
 
//@version=5
indicator(title="RSI Divergence Indicator")
RSI_PER = 15
pivot_right = 5
pivot_left = 5
max_range=50
min_range=5
  
// Creating rsi indicator
rsi_value = ta.rsi(close, RSI_PER)
  
plot(rsi_value, title="RSI", linewidth=2, color=color.black)
hline(50, linestyle=hline.style_dotted)
rsi_ob = hline(70, linestyle=hline.style_dotted)
rsi_os = hline(30, linestyle=hline.style_dotted)
fill(rsi_ob, rsi_os, color=color.rgb(5, 4, 5))
  
//check if we have pivot low in rsi
pivot_low_true = na(ta.pivotlow(rsi_value, pivot_left, pivot_right)) ? false : true //returns price of the pivot low point. It returns 'NaN', if there was no pivot low point.
  
//Create a function that returns true/false
confirm_range(x) =\>
 bars = ta.barssince(x == true) //Counts the number of bars since the last time the condition was true
 min_range \<= bars and bars \<= max_range // makes ure bars is less than 60 and less than 5 and returns true
  
//------------------------------------------------------------------------------
// RSI higher low check
  
RSI_HL_check = rsi_value[pivot_right] \> ta.valuewhen(pivot_low_true, rsi_value[pivot_right], 1) and confirm_range(pivot_low_true[1])
  
// Price Lower Low check
  
price_ll_check = low[pivot_right] \< ta.valuewhen(pivot_low_true, low[pivot_right], 1)
  
bullCond = price_ll_check and RSI_HL_check and pivot_low_true
  
//Plot the areas, terneary conditional operator
plot(pivot_low_true ? rsi_value[pivot_right] : na, offset=-pivot_right,linewidth=3,color=(bullCond ? color.green : color.new(color.white, 100)))
plotshape(bullCond ? rsi_value[pivot_right] : na,
 offset=-pivot_right,
 text=" BUY ",
 style=shape.labelup,
 location=location.absolute,
 color=color.green,
 textcolor=color.white
 
 )
 \> Από \<[https://s3.amazonaws.com/kajabi-storefronts-production/file-uploads/sites/181167/themes/2153125457/downloads/cc86a47-7050-ee38-bb1-80014ca65da_RSIDIV_V5.txt](https://s3.amazonaws.com/kajabi-storefronts-production/file-uploads/sites/181167/themes/2153125457/downloads/cc86a47-7050-ee38-bb1-80014ca65da_RSIDIV_V5.txt)\>