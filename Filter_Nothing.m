classdef Filter_Nothing < AbstractFilter
    %FILTER_NOTHING Filter that does nothing
    properties
        Name = 'Nothing';
    end
    
    methods
        function img_out = process(obj,img_in,settingValues)
            img_out = img_in;
        end
    end
end

