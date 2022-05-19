classdef Filter_PepperNoise < AbstractFilter
    %FILTER_BandReject Filter that does BandReject filtering in the frequency
    %domain
    
    properties
        Name = 'Pepper Only Noise';
    end
    
    methods
        function obj = Filter_PepperNoise()
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
            temp= rand(size(img_in));
           pepii=temp>(1-C);
           img_out=img_in;
           img_out(pepii)=0;
           
           
        end
    end
end

