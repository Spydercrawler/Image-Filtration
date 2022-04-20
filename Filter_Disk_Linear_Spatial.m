classdef Filter_Disk_Linear_Spatial < AbstractFilter
    %FILTER_Filter_Disk_LinearSpatial
    
    properties
        Name = 'Disk Linear Spatial Filter';
    end
    
    methods
        function obj = Filter_Disk_Linear_Spatial()
            % Create settings:
            firstSettingName = 'Radius';
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
            r = settingValues('Radius');
            filter=fspecial('disk',r);
            img_out = imfilter(img_in,filter);
        end
    end
end