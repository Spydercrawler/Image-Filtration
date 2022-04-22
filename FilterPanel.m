classdef FilterPanel < matlab.ui.componentcontainer.ComponentContainer
    %FILTERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
    end
    
    properties (Access = private, Transient, NonCopyable)
        MainLayout matlab.ui.container.GridLayout
        OptionLayout matlab.ui.container.GridLayout
        FilterTypeDropdown matlab.ui.control.DropDown
    end
    
    properties(Access = private) % Filter info
        filterList = {  Filter_Nothing,...
                        Filter_ContrastTransform,...
                        Filter_Gaussian_Linear_Spatial,...
                        Filter_Sobel_Linear_Spatial,...
                        Filter_Prewitt_Linear_Spatial,...
                        Filter_Motion_Linear_Spatial,...
                        Filter_Log_Linear_Spatial,...
                        Filter_Laplacian_Linear_Spatial,...
                        Filter_Disk_Linear_Spatial,...
                        Filter_Average_Linear_Spatial,...
                        Filter_Sharpen,...
                        Filter_Equalized_Histogram,...
                        Filter_Log_Adjust,...
                        Filter_Bandpass,...
                        Filter_BandReject,...
                        Filter_Highpass,...
                        Filter_Lowpass,...
                        Filter_Notchpass,...
                        Filter_Notchreject};
        filterLabels cell = cell.empty
        filterSpinners cell = cell.empty
    end
    
    % UI Component methods
    methods (Access=protected)
        function setup(obj)
            % Set the initial position of this component
            % obj.Position = [100 100 150 22];
            
            % Change background color to make filters easier to distinguish
            obj.BackgroundColor = [0.9 0.9 0.9];
            
            % Create Layout
            obj.MainLayout = uigridlayout(obj,[2,1], ...
                'RowHeight',{'fit','1x'},'ColumnWidth',{'1x'},...
                'Padding',0);
            
            % Get version. If version is greater than or equal to R2020b,
            % change gridlayout background color to make filters equal to
            % distinguish (gridlayouts do not have a background color
            % before R2020b and I want to make this R2020a compatible)
            if(contains(version,{'R2022b','R2022a','R2021b','R2021a','R2020b'}))
                obj.MainLayout.BackgroundColor = [0.9 0.9 0.9];
            end
            
            % Create Labels for each row to confirm things work
            obj.FilterTypeDropdown = uidropdown(obj.MainLayout);
            obj.FilterTypeDropdown.Items = obj.getFilterNames();
            obj.FilterTypeDropdown.ItemsData = obj.filterList;
            obj.FilterTypeDropdown.Value = obj.filterList{1};
            obj.FilterTypeDropdown.Layout.Row = 1;
            obj.FilterTypeDropdown.Layout.Column = 1;
            obj.FilterTypeDropdown.ValueChangedFcn = @obj.filterDropdownChanged;
            
            % Create layout for options
            obj.OptionLayout = uigridlayout(obj.MainLayout,[1,1],...
                'RowHeight',{'1x'}, 'ColumnWidth',{'fit','1x'}, 'Padding',0);
            
            % Change background color of option layout if version allows
            if(contains(version,{'R2022b','R2022a','R2021b','R2021a','R2020b'}))
                obj.OptionLayout.BackgroundColor = [0.9 0.9 0.9];
            end
            
            % Setup UI for filter panel
            obj.updateDisplay();
        end
        
        function update(obj)
            % Do nothing
        end
    end
    
    % Publically accessible methods
    methods
        function img_out = process(obj,img_in)
            % Get set values for filter settings
            filterValues = obj.getFilterValues();
            
            % Use the filter
            currentFilter = obj.FilterTypeDropdown.Value;
            img_out = currentFilter.process(img_in,filterValues);
        end
    end
    
    % Other methods
    methods (Access=protected)
        
        function filterDropdownChanged(obj,src,event)
            obj.updateDisplay();
        end
        
        function updateDisplay(obj)
            % Get filter information
            currentFilter = obj.FilterTypeDropdown.Value;
            numSettings = length(currentFilter.Settings);
            
            % Update number of rows to match number of settings
            obj.OptionLayout.RowHeight = repmat({'1x'},1,max(numSettings,1));
            
            % Remove previous labels and spinners
            for i = 1:length(obj.filterLabels)
                delete(obj.filterLabels{i});
            end
            for i = 1:length(obj.filterSpinners)
                delete(obj.filterSpinners{i});
            end
            obj.filterLabels = cell(1,numSettings);
            obj.filterSpinners = cell(1,numSettings);
            
            % Create new labels and spinners for each setting
            for i = 1:numSettings
                % Make label showing setting name
                obj.filterLabels{i} = uilabel(obj.OptionLayout);
                obj.filterLabels{i}.Layout.Row = i;
                obj.filterLabels{i}.Layout.Column = 1;
                obj.filterLabels{i}.Text = [currentFilter.Settings(i).Name,':'];
                
                % Make spinner allowing value selection
                obj.filterSpinners{i} = uispinner(obj.OptionLayout);
                obj.filterSpinners{i}.Layout.Row = i;
                obj.filterSpinners{i}.Layout.Column = 2;
                obj.filterSpinners{i}.Value = currentFilter.Settings(i).Default;
                obj.filterSpinners{i}.Limits = currentFilter.Settings(i).Bounds;
                if(currentFilter.Settings(i).ForceInteger)
                    obj.filterSpinners{i}.RoundFractionalValues = 'on';
                else
                    obj.filterSpinners{i}.RoundFractionalValues = 'off';
                end
                if(currentFilter.Settings(i).Inclusivity(1))
                    obj.filterSpinners{i}.LowerLimitInclusive = 'on';
                else
                    obj.filterSpinners{i}.LowerLimitInclusive = 'off';
                end
                if(currentFilter.Settings(i).Inclusivity(2))
                    obj.filterSpinners{i}.UpperLimitInclusive = 'on';
                else
                    obj.filterSpinners{i}.UpperLimitInclusive = 'off';
                end
            end
        end
        
        function valueMap = getFilterValues(obj)
            if(isempty(obj.filterSpinners))
                % No settings, so just return empty list to save time
                valueMap = [];
                return;
            else
                % There are settings, so return a map containing setting
                % values
                currentFilter = obj.FilterTypeDropdown.Value;
                
                settingNames = cell(1,length(currentFilter.Settings));
                settingValues = zeros(1,length(currentFilter.Settings));
                for i = 1:length(currentFilter.Settings)
                    settingNames{i} = currentFilter.Settings(i).Name;
                    settingValues(i) = obj.filterSpinners{i}.Value;
                end
                
                valueMap = containers.Map(settingNames,settingValues);
            end
        end
        
        function filterNames = getFilterNames(obj)
            filterNames = cell(size(obj.filterList));
            for i = 1:length(obj.filterList)
                filterNames{i} = obj.filterList{i}.Name;
            end
        end
    end
end

