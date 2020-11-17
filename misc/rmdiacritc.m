function new_str = rmdiacritc(old_str)
    
    new_str = char(old_str);
    
    for c = 1 : length(new_str)
        switch lower(new_str(c))
            case {'ü','ú','ù','û'}
                new_str(c) = 'u';
            case {'ë','é','è','ê'}
                new_str(c) = 'e';
            case {'ä','á','à','â','ã'}
                new_str(c) = 'a';
            case {'ö','ó','ò','ô','õ'}
                new_str(c) = 'o';
            case {'ï','í','ì','î'}
                new_str(c) = 'i';
            case {'ç'}
                new_str(c) = 'c';
        end
        
        if lower(old_str(c)) ~= old_str(c)
            new_str(c) = upper(new_str(c));
        end
    end
end