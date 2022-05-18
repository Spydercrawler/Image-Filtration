classdef Filter_EdgeTaper_Disk < AbstractFilter
    %FILTER_Filter_EdgeTaper_Disk - Disk Edge Taper
    
    properties
        Name = 'Disk Edge Taper';
    end
    
    methods
        function obj = Filter_EdgeTaper_Disk()
            % Create settings:
            firstSettingName = 'Disk Radius';
            firstSettingDefault = 3; % Value should not be negative
            firstSettingBounds = [0,100]; % Value of should not be negative
            firstSettingForceInteger = true; % Force K to be an integer
            firstSettingInclusivity = [false, false]; % Bounds are not inclusive. K can not be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
        end
        function img_out = process(obj,img_in,settingValues)
            r = settingValues('Disk Radius');
            filter=fspecial('disk',r);
            img_out = edgetaper(img_in,filter);
        end
    end
end