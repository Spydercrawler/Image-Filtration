classdef FilterDropdownSetting
    %FILTERDROPDOWNSETTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name char = 'Unnamed Dropdown' % Name of setting
        Items cell = {'Item 1','Item 2','Item 3'};
        ItemsData cell = {1,2,3};
        DefaultValue = 1;
    end
    
    properties(Hidden)
        isItemsDataSet_ = false;
        isDefaultValueSet_ = false;
    end
    
    methods
        function obj = FilterDropdownSetting(Name,Items,ItemsData,DefaultValue)
            %FILTERSETTING Construct an instance of this class
            
            if(nargin > 0)
                obj.Name = Name;
            end
            
            if(nargin > 1)
                obj.Items = Items;
            end
            
            if(nargin > 2)
                obj.ItemsData = ItemsData;
                obj.isItemsDataSet_ = true;
            end
            
            if(nargin > 3)
                obj.DefaultValue = DefaultValue;
                obj.isDefaultValueSet_ = true;
            end
        end
    end
end

