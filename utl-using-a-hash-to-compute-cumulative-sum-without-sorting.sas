Using a hash to compute cumulative sum without sorting                                                    
                                                                                                          
   Two hash solutions                                                                                     
                                                                                                          
        a. novinosrin                                                                                     
           https://communities.sas.com/t5/user/viewprofilepage/user-id/138205                             
                                                                                                          
        b. kashun (slightly simple uses suminc hash function)                                             
           https://communities.sas.com/t5/user/viewprofilepage/user-id/76157                              
                                                                                                          
GitHub                                                                                                    
https://tinyurl.com/y4jafbhs                                                                              
https://github.com/rogerjdeangelis/utl-using-a-hash-to-compute-cumulative-sum-without-sorting             
                                                                                                          
SAS Forum                                                                                                 
https://tinyurl.com/y4jafbhs                                                                              
https://communities.sas.com/t5/SAS-Programming/Cumulative-Sum-without-sorting/m-p/692952                  
                                                                                                          
I am trying to find a way to create cumulative sum without changing positions of observations.            
                                                                                                          
/*                   _                                                                                    
(_)_ __  _ __  _   _| |_                                                                                  
| | `_ \| `_ \| | | | __|                                                                                 
| | | | | |_) | |_| | |_                                                                                  
|_|_| |_| .__/ \__,_|\__|                                                                                 
        |_|                                                                                               
*/                                                                                                        
                                                                                                          
data have;                                                                                                
input Observation Name $ Amount;                                                                          
cards;                                                                                                    
1 John 10                                                                                                 
2 Mark 20                                                                                                 
3 Mark 10                                                                                                 
4 John 40                                                                                                 
5 John 30                                                                                                 
6 Mark 20                                                                                                 
7 John 10                                                                                                 
;;;;                                                                                                      
run;quit;                                                                                                 
                                                                                                          
                                | RULES (for John)                                                        
WORK.HAVE total obs=7           |                                                                         
                                |                                                                         
 OBSERVATION    NAME    AMOUNT  |  AMOUNT NAME                                                            
                                |                                                                         
      1         John      10    |    10   John                                                            
      2         Mark      20    |                                                                         
      3         Mark      10    |                                                                         
      4         John      40    |    50   John                                                            
      5         John      30    |    80   John                                                            
      6         Mark      20    |                                                                         
      7         John      10    |    90   John                                                            
                                                                                                          
/*           _               _                                                                            
  ___  _   _| |_ _ __  _   _| |_                                                                          
 / _ \| | | | __| `_ \| | | | __|                                                                         
| (_) | |_| | |_| |_) | |_| | |_                                                                          
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                         
                |_|                                                                                       
*/                                                                                                        
                                                                                                          
WORK.WANT total obs=7                                                                                     
                                                                                                          
                                  CUMMULATIVE_                                                            
 OBSERVATION    NAME    AMOUNT         SUM                                                                
                                                                                                          
      1         John      10           10                                                                 
      2         Mark      20           20                                                                 
      3         Mark      10           30                                                                 
      4         John      40           50                                                                 
      5         John      30           80                                                                 
      6         Mark      20           50                                                                 
      7         John      10           90                                                                 
                                                                                                          
/*         _       _   _                                                                                  
 ___  ___ | |_   _| |_(_) ___  _ __  ___                                                                  
/ __|/ _ \| | | | | __| |/ _ \| `_ \/ __|                                                                 
\__ \ (_) | | |_| | |_| | (_) | | | \__ \                                                                 
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/                                                                 
  __ _     _ __   _____   _(_)_ __   ___  ___ _ __(_)_ __                                                 
 / _` |   | `_ \ / _ \ \ / / | `_ \ / _ \/ __| `__| | `_ \                                                
| (_| |_  | | | | (_) \ V /| | | | | (_) \__ \ |  | | | | |                                               
 \__,_(_) |_| |_|\___/ \_/ |_|_| |_|\___/|___/_|  |_|_| |_|                                               
                                                                                                          
*/                                                                                                        
                                                                                                          
data want_a;                                                                                              
 set have;                                                                                                
 if _n_=1 then do;                                                                                        
   dcl hash H () ;                                                                                        
   h.definekey  ("name") ;                                                                                
   h.definedata ("Cummulative_Sum") ;                                                                     
   h.definedone () ;                                                                                      
 end;                                                                                                     
 if h.find() ne 0 then Cummulative_Sum=amount;                                                            
 else Cummulative_Sum=sum(Cummulative_Sum,amount);                                                        
 h.replace();                                                                                             
run;                                                                                                      
                                                                                                          
/*        _             _                                                                                 
| |__    | | ____ _ ___| |__  _   _ _ __                                                                  
| `_ \   | |/ / _` / __| `_ \| | | | `_ \                                                                 
| |_) |  |   < (_| \__ \ | | | |_| | | | |                                                                
|_.__(_) |_|\_\__,_|___/_| |_|\__,_|_| |_|                                                                
                                                                                                          
*/                                                                                                        
                                                                                                          
data want_b;                                                                                              
if _n_=1 then do;                                                                                         
  dcl hash h(suminc:'amount');                                                                            
  h.definekey('name');                                                                                    
  h.definedone();                                                                                         
end;                                                                                                      
set have;                                                                                                 
h.ref();                                                                                                  
h.sum(sum:Cumulative_Sum);                                                                                
run;                                                                                                      
