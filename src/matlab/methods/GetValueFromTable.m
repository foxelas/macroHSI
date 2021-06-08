function [value] = GetValueFromTable(tab, field, id)
%%GETVALUEFROMTABLE get a value from specific column in a table

    column = tab.(field);
    value = column{id};
end 