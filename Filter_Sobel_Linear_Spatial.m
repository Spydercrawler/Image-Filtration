classdef Filter_Sobel_Linear_Spatial < AbstractFilter
    %FILTER_Filter_Disk_LinearSpatial - Averaging Filter
    
    properties
        Name = 'Sobel Linear Spatial Filter';
    end
    
    methods
        function obj = Filter_Sobel_Linear_Spatial()
            % No settings
        end
        function img_out = process(obj,img_in,settingValues)
            filter=fspecial('sobel');
            img_out = img_in+imfilter(img_in,filter);
        end
    end
end