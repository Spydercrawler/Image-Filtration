classdef Filter_Laplacian_Linear_Spatial < AbstractFilter
    %FILTER_Filter_Laplacian_LinearSpatial 
    
    properties
        Name = 'Laplacian Linear Spatial Filter';
    end
    
    methods
        function obj = Filter_Laplacian_Linear_Spatial()
            % Create settings:
            firstSettingName = 'alpha';
            firstSettingDefault = 0.2; % Value between 0 and 1
            firstSettingBounds = [0,1]; 
            firstSettingForceInteger = false; % Not integer
            firstSettingInclusivity = [false, false]; % Bounds are not inclusive.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
        end
        function img_out = process(obj,img_in,settingValues)
            a = settingValues('alpha');
            filter=fspecial('laplacian',a);
            img_out = img_in+imfilter(img_in,filter);
        end
    end
end