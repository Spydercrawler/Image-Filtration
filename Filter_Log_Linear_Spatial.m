classdef Filter_Log_Linear_Spatial < AbstractFilter
    %FILTER_Filter_Log_LinearSpatial - Averaging Filter
    
    properties
        Name = 'Log Linear Spatial Filter';
    end
    
    methods
        function obj = Filter_Log_Linear_Spatial()
            % Create settings:
            firstSettingName = 'Kernel Size';
            firstSettingDefault = 5; % Value should not be negative
            firstSettingBounds = [0,100]; % Value of should not be negative
            firstSettingForceInteger = true; % Force K to be an integer
            firstSettingInclusivity = [false, false]; % Bounds are not inclusive. 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Standard Deviation';
            secondSettingDefault = 2;
            secondSettingBounds = [0,6]; % Between 0 and 6
            secondSettingForceInteger = false; % Don't force E to be an integer
            secondSettingInclusivity = [false, true]; % Bounds are partially inclusive. 0 is bad
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
        end
        function img_out = process(obj,img_in,settingValues)
            k = settingValues('Kernel Size');
            sd = settingValues('Standard Deviation');
            filter=fspecial('log',k,sd);
            img_out = img_in+imfilter(img_in,filter);
        end
    end
end