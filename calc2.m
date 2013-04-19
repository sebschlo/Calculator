%Calculator script

clear all
clc

input = '4*3/23+3';

operators = '';
operands = [];
beginning = 1;

for i=1:length(input)
    if ~isstrprop(input(i),'digit')
        operands(end+1)=str2double(input(beginning:i-1));
        
        operators = strcat(operators, input(i));
        
        beginning = i+1;
        
    end
end

operands(end+1)=str2double(input(beginning:end));

result = 0;
containsMulDiv = 1;

while(containsMulDiv)
    for j=1:length(operators)
        containsMulDiv = 0;
        if operators(j) == '*'
            result = operands(j) * operands(j+1);
            operands(j:j+1) = [];
            if (j > 1)
                operands = [operands(1:j-1) result operands(j:end)];
            else
                operands = [result operands];
            end
            operators(j) = [];
            containsMulDiv = 1;
            break;
        elseif operators(j) == '/'
            result = operands(j) / operands(j+1);
            operands(j:j+1) = [];
            if (j > 1)
                operands = [operands(1:j-1) result operands(j:end)];
            else
                operands = [result operands];
            end
            operators(j) = [];
            containsMulDiv = 1;
            break;
        end  
    end
end    

 
while(~isempty(operators))
    for j=1:length(operators)
        if operators(j) == '+'
            result = operands(j) + operands(j+1);
            operands(j:j+1) = [];
            if (j > 1)
                operands = [operands(1:j-1) result operands(j:end)];
            else
                operands = [result operands];
            end
            operators(j) = [];
            break;
        elseif operators(j) == '-'
            result = operands(j) - operands(j+1);
            operands(j:j+1) = [];
            if (j > 1)
                operands = [operands(1:j-1) result operands(j:end)];
            else
                operands = [result operands];
            end
            operators(j) = [];
            break;
        end  
    end
end   

result