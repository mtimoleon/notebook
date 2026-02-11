- Hard Validation
    - Equipment
        - AreaValue \>= 0
        - minimumBatchSizeValue \>= 0
        - maximumBatchSizeValue \>= 0
    - Operation Duration
        - ConstantDuration \>= 0
        - AmountProcessed \>= 0
- Soft Validation
    - Equipment
        - If enableLimit then
            - areaValue \>0
            - must have either min, max batch size value
    - Operation
        - HasRateBasedTerm && ProcessingRate \> 0
- Annotations

Use annotations for endpoint action members validation  
For example to prevent empty strings
    
Determine which type of validation performed.  
Rules that must be applied

## Equipment validation rules
 ![Makis 201 PM iMichaliS Kannonpa Mixkn. MLkfioagE B...](Exported%20image%2020260209134117-0.png)  

**3 types of validation**  
-controller -\> add validation in annotation in poco  
-behaviour in domain  
-handler for db etc