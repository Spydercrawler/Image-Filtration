classdef FilterSetting
    %FILTERSETTING Setting for a filter
    
    properties
        Name char = 'Unnamed Filter' % Name of setting
        Default double = 1;
        Bounds (1,2) double = [-Inf, Inf]  % Bounds of setting in format [lowerbound, upperbound]
        ForceInteger logical = false % Is this required to be an integer?
        Inclusivity logical = [true, true] % Are lower and upper limits inclusive?
    end
    
    methods
        function obj = FilterSetting(Name,Default,Bounds,ForceInteger,Inclusivity)
            %FILTERSETTING Construct an instance of this class
            
            if(nargin > 0)
                obj.Name = Name;
            end
            
            if(nargin > 1)
                obj.Default = Default;
            end
            
            if(nargin > 2)
                obj.Bounds = Bounds;
            end
            
            if(nargin > 3)
                obj.ForceInteger = ForceInteger;
            end
            
            if(nargin > 4)
                obj.Inclusivity = Inclusivity;
            end
        end
    end
end

