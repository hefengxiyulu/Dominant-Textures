function varnames=makevarnames(varname1,model)

p = size(varname1,1);
varname2 = [];
for i = 1:p-1 
    varname2 = [varname2;strcat(varname1(i),'*',varname1(i+1:end))];
end
varname3 = strcat(varname1,'*',varname1); 
switch model    
    case 'linear'         
        varnames = varname1; 
    case 'interaction'         
        varnames = [varname1;varname2];     
    case 'quadratic'        
        varnames = [varname1;varname2;varname3];  
    case 'purequadratic'         
        varnames = [varname1;varname3]; 
end
end