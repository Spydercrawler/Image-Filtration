classdef Filter_Affine_Transformation < AbstractFilter
    %FILTER_CONTRASTTRANSFORM Filter that does contrast transformations
    
    properties
        Name = 'Affine Transformation';
    end
    
    methods
        function obj = Filter_Affine_Transformation()
            % Create settings:
            firstSettingName = 'Vertical Scaling Factor';
            firstSettingDefault = 1; % 
            firstSettingBounds = [0,1000]; % 
            firstSettingForceInteger = false; % 
            firstSettingInclusivity = [false, true]; % Bounds are inclusive
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Horizontal Scaling Factor';
            secondSettingDefault = 1; % 
            secondSettingBounds = [0,1000]; % 
            secondSettingForceInteger = false; % 
            secondSettingInclusivity = [false, true]; % Bounds are inclusive
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
            thirdSettingName = 'Angle of Rotation (Degrees)';
            thirdSettingDefault = 0; % 
            thirdSettingBounds = [0,360]; % values 2 to 256
            thirdSettingForceInteger = false; % Must be integer
            thirdSettingInclusivity = [true, true]; % Bounds are inclusive
            obj.Settings(3) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            v = settingValues('Vertical Scaling Factor');
            h = settingValues('Horizontal Scaling Factor');
            theta = settingValues('Angle of Rotation (Degrees)');
            T = [h*cosd(theta),h*sind(theta),0; -v*sind(theta),v*cosd(theta),0; 0,0,1];
            tform=affine2d(T);
            img_out = imwarp(img_in,tform);
        end
    end
end