classdef Filter_Adaptive_Histogram_Uniform < AbstractFilter
    %FILTER_CONTRASTTRANSFORM Filter that does contrast transformations
    
    properties
        Name = 'Adaptive Uniform Histogram Transformation';
    end
    
    methods
        function obj = Filter_Adaptive_Histogram_Uniform()
            % Create settings:
            secondSettingName = 'Contrast Enhancement Limit';
            secondSettingDefault = 0.01; % 
            secondSettingBounds = [0,1]; % 
            secondSettingForceInteger = false; % Must be integer
            secondSettingInclusivity = [true, true]; % Bounds are inclusive
            obj.Settings(1) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
            thirdSettingName = 'Bins';
            thirdSettingDefault = 200; % 
            thirdSettingBounds = [2,256]; % values 2 to 256
            thirdSettingForceInteger = true; % Must be integer
            thirdSettingInclusivity = [true, true]; % Bounds are inclusive
            obj.Settings(2) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
            fourthSettingName = 'Distribution Parameter';
            fourthSettingDefault = 0.4; % 
            fourthSettingBounds = [0,inf]; % 
            fourthSettingForceInteger = false; % 
            fourthSettingInclusivity = [false, false]; % 
            obj.Settings(3) = FilterSetting(fourthSettingName,...
                                            fourthSettingDefault,...
                                            fourthSettingBounds,...
                                            fourthSettingForceInteger,...
                                            fourthSettingInclusivity);

        end
        
        function img_out = process(obj,img_in,settingValues)
            c = settingValues('Contrast Enhancement Limit');
            b = settingValues('Bins');
            d = settingValues('Distribution Parameter');
            img_out = adapthisteq(img_in,'NumTiles',[8 8],'ClipLimit',c,'NBins',b);
        end
    end
end