classdef MidtermProject < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        MainLayout                    matlab.ui.container.GridLayout
        DisplayLayout                 matlab.ui.container.GridLayout
        TabGroup                      matlab.ui.container.TabGroup
        ImageTab                      matlab.ui.container.Tab
        ImageTabLayout                matlab.ui.container.GridLayout
        ImageTabSelectLayout          matlab.ui.container.GridLayout
        ImageTabProcessedImageButton  matlab.ui.control.StateButton
        ImageTabOriginalImageButton   matlab.ui.control.StateButton
        ImageDisplay                  matlab.ui.control.Image
        FFTTab                        matlab.ui.container.Tab
        FFTTabLayout                  matlab.ui.container.GridLayout
        FFTDisplay                    matlab.ui.control.Image
        FFTTabSelectLayout            matlab.ui.container.GridLayout
        FFTTabOriginalImageButton     matlab.ui.control.StateButton
        FFTTabProcessedImageButton    matlab.ui.control.StateButton
        HistogramTab                  matlab.ui.container.Tab
        HistTabLayout                 matlab.ui.container.GridLayout
        HistTabSelectLayout           matlab.ui.container.GridLayout
        HistTabOriginalImageButton    matlab.ui.control.StateButton
        HistTabProcessedImageButton   matlab.ui.control.StateButton
        HistogramAxis                 matlab.ui.control.UIAxes
        InfoLabel                     matlab.ui.control.Label
        ControlLayout                 matlab.ui.container.GridLayout
        SaveProcessedImageButton      matlab.ui.control.Button
        ProcessImageButton            matlab.ui.control.Button
        FilterSettingsPanel           matlab.ui.container.Panel
        FilterSettingsLayout          matlab.ui.container.GridLayout
        NumFiltersLayout              matlab.ui.container.GridLayout
        NumFiltersSpinner             matlab.ui.control.Spinner
        EnterNumberofFiltersLabel     matlab.ui.control.Label
        BrowseforImageButton          matlab.ui.control.Button
    end

    
    properties (Access = private)
        previousSpinnerValue = 0 % Previous value of Num Filter Spinner
        filters = {};
        loadedImage; % Image loaded from the browse button
        loadedImageFFT; % FFT of loaded image
        loadedImageBinLocs; % Histogram plot bins
        loadedImageBinCounts; % Histogram plot bin counts
        processedImage; % Image after processing is done
        processedImageFFT; % FFT of processed image
        processedImageBinLocs; % Histogram plot bins
        processedImageBinCounts; % Histogram plot bin counts
        
        isImageLoaded = false;
        displayProcessedImage = true; % Display processed image, or original image?
    end
    
    methods (Access = private)
        
        function processImage(app)
            app.processedImage = app.loadedImage;
            
            for i = 1:length(app.filters)
                currentFilter = app.filters{i};
                app.processedImage = currentFilter.process(app.processedImage);
                % Bound values between 0 and 1 in case some filter does
                % something weird
                app.processedImage(app.processedImage > 1) = 1;
                app.processedImage(app.processedImage < 0) = 0;
            end
            
            processed_FFT = abs(fft2(app.processedImage));
            processed_FFT = fftshift(processed_FFT);
            processed_FFT_log = log(1+processed_FFT); % Log transform
            processed_FFT_log = (processed_FFT_log - min(processed_FFT_log,[],'all')) ...
                ./ (max(processed_FFT_log,[],'all')-min(processed_FFT_log,[],'all'));
            app.processedImageFFT = im2uint8(mat2gray(processed_FFT_log));
            
            app.processedImage = im2uint8(app.processedImage);
            
            %app.processedImageFFT = (processed_FFT - mean(processed_FFT,'all'))/std(processed_FFT,[],'all');
            [app.processedImageBinCounts,app.processedImageBinLocs] = imhist(app.processedImage);
            
            app.displayImage();
        end
        
        function displayImage(app)
            imageToDisplay = app.loadedImage;
            fftToDisplay = app.loadedImageFFT;
            binCountsToDisplay = app.loadedImageBinCounts;
            binLocsToDisplay = app.loadedImageBinLocs;
            if(app.displayProcessedImage)
                imageToDisplay = app.processedImage;
                fftToDisplay = app.processedImageFFT;
                binCountsToDisplay = app.processedImageBinCounts;
                binLocsToDisplay = app.processedImageBinLocs;
            end
            
            app.ImageDisplay.ImageSource = repmat(imageToDisplay,[1,1,3]);
            app.FFTDisplay.ImageSource = repmat(fftToDisplay,[1,1,3]);
            app.showHistogram(binCountsToDisplay,binLocsToDisplay);
        end
        
        function showHistogram(app,counts,locs)
            stemPlot = stem(app.HistogramAxis,locs,counts);
            set(stemPlot,'Marker','none');
            %colorbar(app.HistogramAxis,'southoutside');
            %colormap(app.HistogramAxis,'gray');
            
            % Set axis limits using the same code imhist uses
            limits = axis(app.HistogramAxis);
            numBins = length(locs);
            if numBins ~= 1
              limits(1) = max(min(locs),0);
            else
              limits(1) = 0;
            end
            limits(2) = min(max(locs),255);
            var = sqrt(counts'*counts/length(counts));
            limits(4) = 2.5*var;
            axis(app.HistogramAxis,limits);
        end
        
        function updateImageButtons(app)
            % Change button states
            app.ImageTabProcessedImageButton.Value = app.displayProcessedImage;
            app.FFTTabProcessedImageButton.Value = app.displayProcessedImage;
            app.HistTabProcessedImageButton.Value = app.displayProcessedImage;
            app.ImageTabProcessedImageButton.Enable = ~app.displayProcessedImage;
            app.FFTTabProcessedImageButton.Enable = ~app.displayProcessedImage;
            app.HistTabProcessedImageButton.Enable = ~app.displayProcessedImage;
            
            app.ImageTabOriginalImageButton.Value = ~app.displayProcessedImage;
            app.FFTTabOriginalImageButton.Value = ~app.displayProcessedImage;
            app.HistTabOriginalImageButton.Value = ~app.displayProcessedImage;
            app.ImageTabOriginalImageButton.Enable = app.displayProcessedImage;
            app.FFTTabOriginalImageButton.Enable = app.displayProcessedImage;
            app.HistTabOriginalImageButton.Enable = app.displayProcessedImage;
        end
        
        function updateFilterHeight(app,index,pixelHeight)
            app.FilterSettingsLayout.RowHeight{index} = pixelHeight;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changing function: NumFiltersSpinner
        function NumFiltersSpinnerValueChanging(app, event)
            newValue = event.Value;
            valueDifference = newValue - app.previousSpinnerValue;
            if(valueDifference > 0) % Add filters
                % Add rows to filter settings layout to match the number of
                % filters
                newRowHeights = repmat({22},valueDifference,1);
                app.FilterSettingsLayout.RowHeight = ...
                    [app.FilterSettingsLayout.RowHeight,newRowHeights];
                
                % Add filters
                for i = 1:valueDifference
                    newPanel = FilterPanel(app.FilterSettingsLayout);
                    newPanel.Layout.Row = length(app.filters)+1;
                    newPanel.Layout.Column = 1;
                    % Allow height changing
                    newPanel.filterIndex = length(app.filters)+1;
                    newPanel.filterHeightUpdateFcn = ...
                        @(index,height) app.updateFilterHeight(index,height);
                    
                    app.filters{end+1} = newPanel;
                end
            elseif(valueDifference < 0) % Remove filters
                % Remove rows from filter settings layout so it matches the
                % number of filters
                numRows = length(app.FilterSettingsLayout.RowHeight);
                app.FilterSettingsLayout.RowHeight = ...
                    app.FilterSettingsLayout.RowHeight(1:numRows+valueDifference);
                
                for i = 1:abs(valueDifference)
                    delete(app.filters{end}); % Remove last filter panel
                    app.filters(end) = []; % Remove from list
                end
            end
            app.previousSpinnerValue = newValue;
        end

        % Button pushed function: BrowseforImageButton
        function BrowseforImageButtonPushed(app, event)
            % Load a file by user selection
            fileTypes = '*.png;*.tif;*.bmp;*.jpg;*.gif;*.tiff;*.jpeg;*.jfif';
            fileTypeName = 'Image File (png, tif, bmp, jpg, gif)';
            [file,path] = uigetfile({fileTypes,fileTypeName;'*.*',  'All Files (*.*)'});
            figure(app.UIFigure); % Return focus to app
            
            % Handle what happens if user cancels
            if(isnumeric(file) && file==0)
                return;
            end
            
            % Read the image
            filePath = fullfile(path,file);
            app.loadedImage = im2double(imread(filePath));
            
            % Convert to grayscale if needed
            imageSize = size(app.loadedImage);
            if(length(imageSize) > 2 && imageSize(3) > 1)
                % Image is rgb, convert to gray
                app.loadedImage = rgb2gray(app.loadedImage);
            end
            
            % Preload FFT info
            loaded_FFT = abs(fft2(im2double(app.loadedImage)));
            loaded_FFT = fftshift(loaded_FFT);
            loaded_FFT_log = log(1+loaded_FFT); % Log transform
            loaded_FFT_log = (loaded_FFT_log - min(loaded_FFT_log,[],'all')) ...
                ./ (max(loaded_FFT_log,[],'all')-min(loaded_FFT_log,[],'all'));
            app.loadedImageFFT = im2uint8(mat2gray(loaded_FFT_log));
            %loaded_FFT = abs(fft2(app.loadedImage));
            %loaded_FFT = fftshift(loaded_FFT);
            %app.loadedImageFFT = (loaded_FFT - mean(loaded_FFT,'all'))/std(loaded_FFT,[],'all');
            
            % Preload histogram info
            [app.loadedImageBinCounts,app.loadedImageBinLocs] = imhist(im2uint8(app.loadedImage));
            
            % Display file information
            imageInfo = imfinfo(filePath);
            displayNameText = ['Filename: ',file];
            modifyDateText = ['; Last Modified: ',imageInfo.FileModDate];
            resolutionText = ['; Resolution: ',num2str(size(app.loadedImage,2)),...
                'x',num2str(size(app.loadedImage,1))];
            bitDepthText = ['; Bit Depth: ',num2str(imageInfo.BitDepth)];
            colortypeText = ['; Color Type: ',imageInfo.ColorType];
            fullInfoText = [displayNameText,modifyDateText,...
                resolutionText,bitDepthText,colortypeText];
            app.InfoLabel.Text = fullInfoText;
            
            % Allow user to do more things since an image is loaded
            app.ProcessImageButton.Enable = true;
            app.SaveProcessedImageButton.Enable = true;
            app.isImageLoaded = true;
            
            % Process the image
            app.processImage();
        end

        % Button pushed function: ProcessImageButton
        function ProcessImageButtonPushed(app, event)
            app.displayProcessedImage = true;
            app.updateImageButtons();
            app.processImage();
        end

        % Button pushed function: SaveProcessedImageButton
        function SaveProcessedImageButtonPushed(app, event)
            fileTypeFilter = {...
                '*.png','PNG (*.png)';...
                '*.jpg','JPG (*.jpg)';...
                '*.bmp','BMP (*.bmp)';...
                '*.tif','TIFF (*.tif)';...
                '*.gif','GIF (*.gif)'};
            
            
            [file,path] = uiputfile(fileTypeFilter);
            filePath = fullfile(path,file);
            imwrite(app.processedImage,filePath);
        end

        % Value changed function: FFTTabProcessedImageButton, 
        % HistTabProcessedImageButton, ImageTabProcessedImageButton
        function ImageTabProcessedImageButtonValueChanged(app, event)
            showProcessedImage = event.Value;
            
            app.displayProcessedImage = showProcessedImage;
            app.updateImageButtons();
            
            drawnow;
            
            if(app.isImageLoaded)
                app.displayImage();
            end
        end

        % Value changed function: FFTTabOriginalImageButton, 
        % HistTabOriginalImageButton, ImageTabOriginalImageButton
        function ImageTabOriginalImageButtonValueChanged(app, event)
            showProcessedImage = ~event.Value;
            
            app.displayProcessedImage = showProcessedImage;
            app.updateImageButtons();
            
            drawnow;
            if(app.isImageLoaded)
                app.displayImage();
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Midterm Project (Authors: John Bass, Margaret Luffman, Matthew Callahan)';

            % Create MainLayout
            app.MainLayout = uigridlayout(app.UIFigure);
            app.MainLayout.ColumnWidth = {'1x', 'fit'};
            app.MainLayout.RowHeight = {'1x'};

            % Create ControlLayout
            app.ControlLayout = uigridlayout(app.MainLayout);
            app.ControlLayout.ColumnWidth = {'1x'};
            app.ControlLayout.RowHeight = {'fit', 'fit', '1x', 'fit', 'fit'};
            app.ControlLayout.Padding = [0 0 0 0];
            app.ControlLayout.Layout.Row = 1;
            app.ControlLayout.Layout.Column = 2;

            % Create BrowseforImageButton
            app.BrowseforImageButton = uibutton(app.ControlLayout, 'push');
            app.BrowseforImageButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseforImageButtonPushed, true);
            app.BrowseforImageButton.Layout.Row = 1;
            app.BrowseforImageButton.Layout.Column = 1;
            app.BrowseforImageButton.Text = 'Browse for Image';

            % Create NumFiltersLayout
            app.NumFiltersLayout = uigridlayout(app.ControlLayout);
            app.NumFiltersLayout.ColumnWidth = {'1x'};
            app.NumFiltersLayout.RowHeight = {'fit', 'fit'};
            app.NumFiltersLayout.Padding = [0 0 0 0];
            app.NumFiltersLayout.Layout.Row = 2;
            app.NumFiltersLayout.Layout.Column = 1;

            % Create EnterNumberofFiltersLabel
            app.EnterNumberofFiltersLabel = uilabel(app.NumFiltersLayout);
            app.EnterNumberofFiltersLabel.Layout.Row = 1;
            app.EnterNumberofFiltersLabel.Layout.Column = 1;
            app.EnterNumberofFiltersLabel.Text = 'Enter Number of Filters:';

            % Create NumFiltersSpinner
            app.NumFiltersSpinner = uispinner(app.NumFiltersLayout);
            app.NumFiltersSpinner.UpperLimitInclusive = 'off';
            app.NumFiltersSpinner.ValueChangingFcn = createCallbackFcn(app, @NumFiltersSpinnerValueChanging, true);
            app.NumFiltersSpinner.Limits = [0 100];
            app.NumFiltersSpinner.RoundFractionalValues = 'on';
            app.NumFiltersSpinner.Layout.Row = 2;
            app.NumFiltersSpinner.Layout.Column = 1;

            % Create FilterSettingsPanel
            app.FilterSettingsPanel = uipanel(app.ControlLayout);
            app.FilterSettingsPanel.Layout.Row = 3;
            app.FilterSettingsPanel.Layout.Column = 1;

            % Create FilterSettingsLayout
            app.FilterSettingsLayout = uigridlayout(app.FilterSettingsPanel);
            app.FilterSettingsLayout.ColumnWidth = {'1x', 11};
            app.FilterSettingsLayout.RowHeight = {22};
            app.FilterSettingsLayout.Padding = [0 0 0 0];
            app.FilterSettingsLayout.Scrollable = 'on';

            % Create ProcessImageButton
            app.ProcessImageButton = uibutton(app.ControlLayout, 'push');
            app.ProcessImageButton.ButtonPushedFcn = createCallbackFcn(app, @ProcessImageButtonPushed, true);
            app.ProcessImageButton.Enable = 'off';
            app.ProcessImageButton.Layout.Row = 4;
            app.ProcessImageButton.Layout.Column = 1;
            app.ProcessImageButton.Text = 'Process Image';

            % Create SaveProcessedImageButton
            app.SaveProcessedImageButton = uibutton(app.ControlLayout, 'push');
            app.SaveProcessedImageButton.ButtonPushedFcn = createCallbackFcn(app, @SaveProcessedImageButtonPushed, true);
            app.SaveProcessedImageButton.Enable = 'off';
            app.SaveProcessedImageButton.Layout.Row = 5;
            app.SaveProcessedImageButton.Layout.Column = 1;
            app.SaveProcessedImageButton.Text = 'Save Processed Image';

            % Create DisplayLayout
            app.DisplayLayout = uigridlayout(app.MainLayout);
            app.DisplayLayout.ColumnWidth = {'1x'};
            app.DisplayLayout.RowHeight = {'1x', 'fit'};
            app.DisplayLayout.RowSpacing = 0;
            app.DisplayLayout.Padding = [0 0 0 0];
            app.DisplayLayout.Layout.Row = 1;
            app.DisplayLayout.Layout.Column = 1;

            % Create InfoLabel
            app.InfoLabel = uilabel(app.DisplayLayout);
            app.InfoLabel.WordWrap = 'on';
            app.InfoLabel.FontSize = 8;
            app.InfoLabel.Layout.Row = 2;
            app.InfoLabel.Layout.Column = 1;
            app.InfoLabel.Text = '';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.DisplayLayout);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create ImageTab
            app.ImageTab = uitab(app.TabGroup);
            app.ImageTab.Title = 'Image';

            % Create ImageTabLayout
            app.ImageTabLayout = uigridlayout(app.ImageTab);
            app.ImageTabLayout.ColumnWidth = {'1x'};
            app.ImageTabLayout.RowHeight = {'fit', '1x'};
            app.ImageTabLayout.Padding = [0 0 0 0];

            % Create ImageDisplay
            app.ImageDisplay = uiimage(app.ImageTabLayout);
            app.ImageDisplay.Layout.Row = 2;
            app.ImageDisplay.Layout.Column = 1;

            % Create ImageTabSelectLayout
            app.ImageTabSelectLayout = uigridlayout(app.ImageTabLayout);
            app.ImageTabSelectLayout.RowHeight = {'1x'};
            app.ImageTabSelectLayout.Padding = [0 0 0 0];
            app.ImageTabSelectLayout.Layout.Row = 1;
            app.ImageTabSelectLayout.Layout.Column = 1;

            % Create ImageTabOriginalImageButton
            app.ImageTabOriginalImageButton = uibutton(app.ImageTabSelectLayout, 'state');
            app.ImageTabOriginalImageButton.ValueChangedFcn = createCallbackFcn(app, @ImageTabOriginalImageButtonValueChanged, true);
            app.ImageTabOriginalImageButton.Text = 'Show Original Image';
            app.ImageTabOriginalImageButton.Layout.Row = 1;
            app.ImageTabOriginalImageButton.Layout.Column = 1;

            % Create ImageTabProcessedImageButton
            app.ImageTabProcessedImageButton = uibutton(app.ImageTabSelectLayout, 'state');
            app.ImageTabProcessedImageButton.ValueChangedFcn = createCallbackFcn(app, @ImageTabProcessedImageButtonValueChanged, true);
            app.ImageTabProcessedImageButton.Enable = 'off';
            app.ImageTabProcessedImageButton.Text = 'Show Processed Image';
            app.ImageTabProcessedImageButton.Layout.Row = 1;
            app.ImageTabProcessedImageButton.Layout.Column = 2;
            app.ImageTabProcessedImageButton.Value = true;

            % Create FFTTab
            app.FFTTab = uitab(app.TabGroup);
            app.FFTTab.Title = 'FFT';

            % Create FFTTabLayout
            app.FFTTabLayout = uigridlayout(app.FFTTab);
            app.FFTTabLayout.ColumnWidth = {'1x'};
            app.FFTTabLayout.RowHeight = {'fit', '1x'};
            app.FFTTabLayout.Padding = [0 0 0 0];

            % Create FFTTabSelectLayout
            app.FFTTabSelectLayout = uigridlayout(app.FFTTabLayout);
            app.FFTTabSelectLayout.RowHeight = {'1x'};
            app.FFTTabSelectLayout.Padding = [0 0 0 0];
            app.FFTTabSelectLayout.Layout.Row = 1;
            app.FFTTabSelectLayout.Layout.Column = 1;

            % Create FFTTabProcessedImageButton
            app.FFTTabProcessedImageButton = uibutton(app.FFTTabSelectLayout, 'state');
            app.FFTTabProcessedImageButton.ValueChangedFcn = createCallbackFcn(app, @ImageTabProcessedImageButtonValueChanged, true);
            app.FFTTabProcessedImageButton.Enable = 'off';
            app.FFTTabProcessedImageButton.Text = 'Show Processed Image';
            app.FFTTabProcessedImageButton.Layout.Row = 1;
            app.FFTTabProcessedImageButton.Layout.Column = 2;
            app.FFTTabProcessedImageButton.Value = true;

            % Create FFTTabOriginalImageButton
            app.FFTTabOriginalImageButton = uibutton(app.FFTTabSelectLayout, 'state');
            app.FFTTabOriginalImageButton.ValueChangedFcn = createCallbackFcn(app, @ImageTabOriginalImageButtonValueChanged, true);
            app.FFTTabOriginalImageButton.Text = 'Show Original Image';
            app.FFTTabOriginalImageButton.Layout.Row = 1;
            app.FFTTabOriginalImageButton.Layout.Column = 1;

            % Create FFTDisplay
            app.FFTDisplay = uiimage(app.FFTTabLayout);
            app.FFTDisplay.Layout.Row = 2;
            app.FFTDisplay.Layout.Column = 1;

            % Create HistogramTab
            app.HistogramTab = uitab(app.TabGroup);
            app.HistogramTab.Title = 'Histogram';

            % Create HistTabLayout
            app.HistTabLayout = uigridlayout(app.HistogramTab);
            app.HistTabLayout.ColumnWidth = {'1x'};
            app.HistTabLayout.RowHeight = {'fit', '1x'};
            app.HistTabLayout.Padding = [0 0 0 0];

            % Create HistogramAxis
            app.HistogramAxis = uiaxes(app.HistTabLayout);
            title(app.HistogramAxis, 'Image Histogram')
            xlabel(app.HistogramAxis, 'Pixel Value')
            ylabel(app.HistogramAxis, 'Count')
            zlabel(app.HistogramAxis, 'Z')
            app.HistogramAxis.Layout.Row = 2;
            app.HistogramAxis.Layout.Column = 1;

            % Create HistTabSelectLayout
            app.HistTabSelectLayout = uigridlayout(app.HistTabLayout);
            app.HistTabSelectLayout.RowHeight = {'1x'};
            app.HistTabSelectLayout.Padding = [0 0 0 0];
            app.HistTabSelectLayout.Layout.Row = 1;
            app.HistTabSelectLayout.Layout.Column = 1;

            % Create HistTabProcessedImageButton
            app.HistTabProcessedImageButton = uibutton(app.HistTabSelectLayout, 'state');
            app.HistTabProcessedImageButton.ValueChangedFcn = createCallbackFcn(app, @ImageTabProcessedImageButtonValueChanged, true);
            app.HistTabProcessedImageButton.Enable = 'off';
            app.HistTabProcessedImageButton.Text = 'Show Processed Image';
            app.HistTabProcessedImageButton.Layout.Row = 1;
            app.HistTabProcessedImageButton.Layout.Column = 2;
            app.HistTabProcessedImageButton.Value = true;

            % Create HistTabOriginalImageButton
            app.HistTabOriginalImageButton = uibutton(app.HistTabSelectLayout, 'state');
            app.HistTabOriginalImageButton.ValueChangedFcn = createCallbackFcn(app, @ImageTabOriginalImageButtonValueChanged, true);
            app.HistTabOriginalImageButton.Text = 'Show Original Image';
            app.HistTabOriginalImageButton.Layout.Row = 1;
            app.HistTabOriginalImageButton.Layout.Column = 1;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MidtermProject

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end