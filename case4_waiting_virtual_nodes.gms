$title: Example Network with Capacity Constraints and Waiting at Virtual Nodes
*Commodity flow from node 1 to node 4 are 4 in time 1
*Commodity flow from node 2 to node 4 are 4 in time 1
*Generate a corresponding virtual node for each real node 1-5 2-6 3-7 

set i nodes /1*7/; 
set t time stamp /1*12/;
set f flow /1*8/;

alias (i, j);
alias (t, s);


parameter arcs(i,j,t,s) flow link travel time ;
arcs('5','3',t,t+4)=4;
arcs('6','3',t,t+3)=3;
arcs('7','4',t,t+2)=2;
arcs(i,i+4,t,t)=0.01;
arcs(i,i,t,t+1)=0.01;

parameter origin_node(f,i,t)  origin nodes ;
origin_node(f,'1','1')$(ord(f) <= 4 )= 1;
origin_node(f,'2','1')$(ord(f) > 4  )= 1;

parameter destination_node(f,i);
destination_node(f,'4')= 1;

parameter intermediate_node(f,i,t);
intermediate_node(f,i,t) = (1- origin_node(f,i,t))*(1- destination_node(f,i));

parameter w(i,j);
w('5','3')=2;
w('6','3')=2;
w('7','4')=2;
w(i,i+4)=8;
w(i,i)=8;

variable z;
positive variable x(f,i,j,t,s)  flow f travels between i and j from time t to time s;


equations
obj                                define objective function

flow_on_node_origin(f,i,t)         origin node flow on node i at time t
flow_on_node_intermediate(f,i,t)   intermediate node flow on node i at time t
flow_on_node_destination(f,i)      destination node flow on node i 
capacity(i,j,t,s)
;

obj.. z =e= sum((f,i,j,t,s)$arcs(i,j,t,s), arcs(i,j,t,s)* x(f,i,j,t,s));
flow_on_node_origin(f,i,t)$(origin_node(f,i,t)).. sum((j,s)$(arcs(i,j,t,s)), x(f,i,j, t,s)) =e= 1;
flow_on_node_destination(f,i)$(destination_node(f,i)).. sum((j,s,t)$(arcs(j,i,s,t)), x(f,j,i,s,t))=e=1;
flow_on_node_intermediate(f,i,t)$(intermediate_node(f,i,t)).. sum((j,s)$(arcs(i,j,t,s)), x(f,i,j,t,s))-sum((j,s)$(arcs(j,i,s,t)), x(f,j,i,s,t)) =e= 0;

capacity(i,j,t,s)$(arcs(i,j,t,s)).. sum(f,x(f,i,j,t,s))=l=w(i,j);




Model  Capacity_Constraints_and_Waiting_at_Own_Nodes /ALL/;

solve  Capacity_Constraints_and_Waiting_at_Own_Nodes using MIP minimizing z;

display x.l;
display z.l;






