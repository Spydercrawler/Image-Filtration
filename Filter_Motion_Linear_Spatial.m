classdef Filter_Motion_Linear_Spatial < AbstractFilter
    %FILTER_Filter_Disk_LinearSpatial - Averaging Filter
    
    properties
        Name = 'Motion Linear Spatial Filter';
    end
    
    methods
        function obj = Filter_Motion_Linear_Spatial()
            % Create settings:
            firstSettingName = 'Linear Motion'; %Along horizontal axis
            firstSettingDefault = 9; % Value can be negative
            firstSettingBounds = [-100,100]; % Value of K can be negative
            firstSettingForceInteger = true; % Force K to be an integer
            firstSettingInclusivity = [true, true]; % Bounds are not inclusive. K can not be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Direction of Motion'; % CCW relative to horizontal axis
            secondSettingDefault = 0;
            secondSettingBounds = [-180,180]; % Value can be negative
            secondSettingForceInteger = false; % Don't force E to be an integer
            secondSettingInclusivity = [true, true]; % Bounds are partially inclusive. E can be 0.
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
        end
        function img_out = process(obj,img_in,settingValues)
            lm = settingValues('Linear Motion');
            dm = settingValues('Direction of Motion');
            filter=fspecial('motion',lm,dm);
            img_out = imfilter(img_in,filter);
        end
    end
end