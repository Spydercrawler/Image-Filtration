classdef Filter_GaussianNoise < AbstractFilter
    %FILTER_BandReject Filter that does BandReject filtering in the frequency
    %domain
    
    properties
        Name = 'Gaussian Noise';
    end
    
    methods
        function obj = Filter_GaussianNoise()
            % Create settings:
            firstSettingName = 'Mean';
            firstSettingDefault = 0; 
            firstSettingBounds = [-Inf,Inf];%mean can be any value, even outside the range of the image 
            firstSettingForceInteger = false; 
            firstSettingInclusivity = [true, true]; 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
             secondSettingName = 'Variance';
            secondSettingDefault = 0.01; 
            secondSettingBounds = [0,Inf];%variance must be positive
            secondSettingForceInteger = false; 
            secondSettingInclusivity = [false, true]; 
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);

              end
        
        function img_out = process(obj,img_in,settingValues)
            M = settingValues('Mean');
            V=settingValues("Variance");
            img_out = imnoise(img_in, "gaussian",M,V);
        end
    end
end

