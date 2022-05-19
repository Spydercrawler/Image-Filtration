classdef Filter_NoiseReducingFilter < AbstractFilter
    %FILTER_NoiseReductions  implements spfilt as seen in the textbook
    % When the "Action" dropdown is set to "Black", returns a black image.
    % When the "Action" dropdown is set to "Gray", returns a gray image
    %   with a constant value set by the spinner.
    % When the "Action" dropdown is set to "histeq", does histogram
    %   equalization
    
    properties
        Name = 'Noise Reducing Filter';
    end
    
    methods
        function obj = Filter_NoiseReducingFilter()
            % Create dropdowns
            firstDropdownName = 'Filter Type';
                % Items = values displayed in the dropdown to the user
            
            firstDropdownItems = {'Arithmatic Mean','Geometric Mean','Harmonic Mean', 'Contraharmonic Mean', 'Median', 'Max', 'Min', 'Midpoint', 'Alpha Trimed Mean'};
            firstDropdownData= {'amean','gmean','hmean', 'chmean', 'median', 'max', 'min', 'midpoint', 'atrimmed'};
            % Can also specify an 'ItemsData' and 'DefaultValue'.
            % 'ItemsData' is same size as 'Items' array and gives the
            %   actual values that are passed into the 'process' method when
            %   an item is selected. 
            % 'DefaultValue' gives the default selected item.
            obj.Dropdowns(1) = FilterDropdownSetting(firstDropdownName,firstDropdownItems,firstDropdownData);
            
            % Create settings:
            firstSettingName = 'Horizontal Kernel Size';
            firstSettingDefault = 3; % Value of K should not be negative
            firstSettingBounds = [0,Inf]; % Don't set max size, just cap it in the call
            firstSettingForceInteger = true; 
            firstSettingInclusivity = [true, false]; % Bounds are inclusive. 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);

            firstSettingName = 'Vertical Kernel Size';
            firstSettingDefault = 3; % Value of K should not be negative
            firstSettingBounds = [0,Inf]; % Don't set max size, just cap it in the call
            firstSettingForceInteger = true; 
            firstSettingInclusivity = [true, false]; % Bounds are inclusive. 
            obj.Settings(2) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            firstSettingName = 'D or Q';
            firstSettingDefault = 1; % Value of K should not be negative
            firstSettingBounds = [-Inf,Inf]; % Don't set max size, just cap it in the call
            firstSettingForceInteger = false; 
            firstSettingInclusivity = [false,false]; % Bounds are inclusive. 
            obj.Settings(3) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);


        end
        
        function img_out = process(obj,img_in,settingValues)
            Action = settingValues('Filter Type');
            N = settingValues('Horizontal Kernel Size');
            M = settingValues('Vertical Kernel Size');
            DQ= settingValues('D or Q');
            [m,n]=size(img_in);
            M=min(m,M);
            N=min(n,N);
            if(strcmp(Action,'atrimmed'))
                if(mod(DQ,2)==1)
                    DQ=2;
                end
            end

            img_out=spfilt(img_in,Action,M,N,DQ);
        end
    end
end

