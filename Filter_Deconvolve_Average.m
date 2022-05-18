classdef Filter_Deconvolve_Average < AbstractFilter
    %FILTER_Filter_Deconvolve_Gaussian - Deconvolve Gaussian PSF
    
    properties
        Name = 'Deconvolve Averaging PSF';
    end
    
    methods
        function obj = Filter_Deconvolve_Average()
            % Create dropdown:
            firstDropdownName = 'Deconvolution Type';
            firstDropdownItems = {  'Weiner',...
                                    'Regularized Filter',...
                                    'Lucy-Richardson',...
                                    'Blind'};
            obj.Dropdowns(1) = FilterDropdownSetting(firstDropdownName,...
                                                     firstDropdownItems);
            
            % Create settings:
            firstSettingName = 'NSR (WEINER)';
            firstSettingDefault = 0;
            firstSettingBounds = [0,Inf];
            firstSettingForceInteger = false;
            firstSettingInclusivity = [true, false]; 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
                                        
            secondSettingName = 'Noise Power (REG)';
            secondSettingDefault = 0;
            secondSettingBounds = [0,Inf];
            secondSettingForceInteger = false; 
            secondSettingInclusivity = [true, false]; 
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
                                        
            thirdSettingName = 'Num Iters (L-R/BLIND)';
            thirdSettingDefault = 10; % Number of iterations
            thirdSettingBounds = [1,Inf];
            thirdSettingForceInteger = true; 
            thirdSettingInclusivity = [true, false]; 
            obj.Settings(3) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
                                        
            fourthSettingName = 'Kernel Size';
            fourthSettingDefault = 3; % Number of iterations
            fourthSettingBounds = [0,100];
            fourthSettingForceInteger = true; 
            fourthSettingInclusivity = [false, true]; 
            obj.Settings(4) = FilterSetting(fourthSettingName,...
                                            fourthSettingDefault,...
                                            fourthSettingBounds,...
                                            fourthSettingForceInteger,...
                                            fourthSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            deconvType = settingValues('Deconvolution Type');
            nsr = settingValues('NSR (WEINER)');
            np = settingValues('Noise Power (REG)');
            iters = settingValues('Num Iters (L-R/BLIND)');
            kernel_size = settingValues('Kernel Size');
            
            kernel = fspecial('average',kernel_size);
            
            switch deconvType
                case 'Weiner'
                    img_out = deconvwnr(img_in,kernel,nsr);
                case 'Regularized Filter'
                    img_out = deconvreg(img_in,kernel,np);
                case 'Lucy-Richardson'
                    img_out = deconvlucy(img_in,kernel,iters);
                case 'Blind'
                    img_out = deconvblind(img_in,kernel,iters);
                otherwise
                    % By default use blind
                    img_out = deconvblind(img_in,kernel,iters);
            end
        end
    end
end