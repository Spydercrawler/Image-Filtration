classdef Filter_EdgeTaper_Average < AbstractFilter
    %FILTER_Filter_EdgeTaper_Average - Averaging Edge Taper
    
    properties
        Name = 'Averaging Edge Taper';
    end
    
    methods
        function obj = Filter_EdgeTaper_Average()
            % Create settings:
            firstSettingName = 'Kernel Size';
            firstSettingDefault = 3; % Value should not be negative
            firstSettingBounds = [0,100]; % Value of should not be negative
            firstSettingForceInteger = true; % Force to be an integer
            firstSettingInclusivity = [false, true]; % Bounds are partially inclusive cannot be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
        end
        function img_out = process(obj,img_in,settingValues)
            k = settingValues('Kernel Size');
            filter=fspecial('average',k);
            img_out = edgetaper(img_in,filter);
        end
    end
end