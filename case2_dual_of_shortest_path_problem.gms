Set
   i /1*4/;   

Parameter 
   c12, c13, c24, c34;   

c13 = 1;  
c12 = 2;  
c24 = 1000;  
c34 = 10;  

Variables
   obj_value,  
   p1_val, p2_val, p3_val, p4_val;   

Positive Variables p1_val, p2_val, p3_val, p4_val;  

Equations
   obj,           
   constr1, constr2, constr3, constr4;   

obj.. obj_value =e= -p1_val - p4_val;
constr1.. c13 + p1_val + p3_val =g= 0;
constr2.. c12 + p1_val + p2_val =g= 0;
constr3.. c24 - p2_val + p4_val =g= 0;
constr4.. c34 - p3_val + p4_val =g= 0;


Model MaxFlow /all/;
Solve MaxFlow using LP maximizing obj_value;


Display obj_value.l, p1_val.l, p2_val.l, p3_val.l, p4_val.l;
