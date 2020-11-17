function new_str = rmdiacritc(old_str)
    
    new_str = char(old_str);
    
    for c = 1 : length(new_str)
        switch lower(new_str(c))
            case {'�','�','�','�'}
                new_str(c) = 'u';
            case {'�','�','�','�'}
                new_str(c) = 'e';
            case {'�','�','�','�','�'}
                new_str(c) = 'a';
            case {'�','�','�','�','�'}
                new_str(c) = 'o';
            case {'�','�','�','�'}
                new_str(c) = 'i';
            case {'�'}
                new_str(c) = 'c';
        end
        
        if lower(old_str(c)) ~= old_str(c)
            new_str(c) = upper(new_str(c));
        end
    end
end