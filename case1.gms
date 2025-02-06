$title: 3.5 Example Network with Two Commodities
*Commodity flow from A to D is 10 
*Commodity flow from C to B is 10 
set i nodes /1*4/; 
set k commodity /1*20/;
alias (i, j);

parameter a(i,j) slopes of Linear flow costs  ;
a('1','2') = 2; a('2','1') = 2;
a('1','3') = 1; a('3','1') = 1;
a('2','4') = 1; a('4','2') = 1;
a('3','4') = 2; a('4','3') = 2;

parameter b(i,j) intercept of Linear flow costs  ;
b(i,j)=0;

parameter origin_node(k,i)  origin nodes of commodity;
origin_node(k,'1')$(ord(k) <= 10 ) = 1;
origin_node(k,'3')$(ord(k) > 10 ) = 1;


parameter destination_node(k,i);
destination_node(k,'4')$(ord(k) <= 10 ) = 1;
destination_node(k,'2')$(ord(k) > 10 ) = 1;


parameter intermediate_node(k,i);
intermediate_node(k,i) = (1- origin_node(k,i))*(1- destination_node(k,i));

parameter u(i,j);
u(i,j)=10;

variable z;
Binary Variable  x(i,j,k)  commodity k travels between i and j ;

equations
obj                               define objective function

flow_on_node_origin(k,i)         origin node flow on node i 
flow_on_node_intermediate(k,i)   intermediate node flow on node i at time t
flow_on_node_destination(k,i)    destination node flow on node i at time t
capacity_on_link(i,j)            capacity on link between i and j

;

obj.. z =e=  sum((i,j)$a(i,j), a(i,j)* sum(k,x(i,j,k))*sum(k,x(i,j,k))+b(i,j)*sum(k,x(i,j,k)));
flow_on_node_origin(k,i)$(origin_node(k,i))..  sum((j)$(a(i,j)), x(i,j,k))=e=1;
flow_on_node_destination(k,i)$(destination_node(k,i))..  sum((j)$(a(j,i)), x(j,i,k))=e=1;
flow_on_node_intermediate(k,i)$(intermediate_node(k,i)).. sum((j)$(a(i,j)), x(i,j,k))-sum((j)$(a(j,i)), x(j,i,k)) =e= 0;
capacity_on_link(i,j)$(a(i,j)).. sum((k),x(i,j,k)) =l= u(i,j);


Model Multicommodity_Flow_with_Capacity_Constraints /ALL/;
solve Multicommodity_Flow_with_Capacity_Constraints using MINLP minimizing z;


display x.l;

display z.l;
