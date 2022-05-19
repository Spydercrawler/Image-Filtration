classdef Filter_SaltAndPeperNoise < AbstractFilter
    %FILTER_BandReject Filter that does BandReject filtering in the frequency
    %domain
    
    properties
        Name = 'Salt and Pepper Noise';
    end
    
    methods
        function obj = Filter_SaltAndPeperNoise()
            % Create settings:
            firstSettingName = 'Density';
            firstSettingDefault = 0.05; % Value of D should be a probability
            firstSettingBounds = [0,1]; 
            firstSettingForceInteger = false; % Don't force D to be an integer
            firstSettingInclusivity = [true, true]; 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            
              end
        
        function img_out = process(obj,img_in,settingValues)
            C = settingValues('Density');
            
            img_out = imnoise(img_in, "salt & pepper",C);
        end
    end
end

