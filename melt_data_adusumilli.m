function [M,x,y,t] = melt_data_adusumilli(varargin)
% melt_data_adusumilli loads ice shelf melt rate data from Adusumilli et al., 2020.
% 
%% Syntax
% 
%  [M,x,y] = melt_data_adusumilli
%  [M,x,y,t] = melt_data_adusumilli('timeseries')
% 
%% Description 
% 
% [M,x,y] = melt_data_adusumilli loads the 500 m resolution w_b mosaic of
% basal meltrates (m/yr) that spans 2010-2018. Missing data are filled with
% the w_b_interp variable, which assumes a depth-dependent melt rate that was
% calculated separately for each ice shelf. Output variables x and y are in 
% polar stereographic (ps71) meters. 
% 
% [M,x,y,t] = melt_data_adusumilli('timeseries') loads the 10 km resolution, 
% quarterly (four times a year) data cube of surface elevation anomalies from
% 1992 to 2018, then converts to melt rates. It's important to note that Adusumilli's 
% dataset does not actually contain a timeseries of melt rates, so this function
% uses the ITS_LIVE velocity mosaic and BedMachine ice thickness to account for 
% divergence (which I calculated as constant through time despite possible evidence
% to the contrary). The output variable t is in Matlab's datenum format, which 
% is the number of days since the strike of midnight of the year zero. 
% 
%% Examples
% 
% For examples, type:
% 
%  showdemo melt_data_adusumilli_documentation
% 
%% Example 1: 
% Make a map of basal melt rates: 
% 
% [M,x,y] = melt_data_adusumilli;
% 
% figure
% imagescn(x,y,M) 
% bedmachine % draws gounding lines and coast lines
% cb = colorbar; 
% ylabel(cb,'basal melt rates') 
% caxis([-1 1]*10)
% cmocean balance % colormap
% 
%% Example 2: Map the trend in basal melt rates since 2010: 
% 
% [M,x,y,t] = melt_data_adusumilli('timeseries'); 
% 
% ind = t>datenum('jan 1, 2010'); % indices of dates since 2010.
% M_tr = trend(M(:,:,ind),t(ind)/365); % divide by 365 for melt/yr because datenum units are days.
% 
% figure
% pcolor(x,y,M_tr)
% 
%% Citing this data
% Please cite Susheel's dataset if you use this data! Also, this function does operate on
% the data, so if you don't mind, please also cite Antarctic Mapping Tools. 
% 
% Adusumilli, Susheel; Fricker, Helen A.; Medley, Brooke C.; Padman, Laurie; Siegfried, 
% Matthew R. (2020). Data from: Interannual variations in meltwater input to the Southern
% Ocean from Antarctic ice shelves. UC San Diego Library Digital Collections.
% https://doi.org/10.6075/J04Q7SHT
% 
% Greene, C. A., Gwyther, D. E., & Blankenship, D. D. Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences. 104 (2017) pp.151-157. 
% http://dx.doi.org/10.1016/j.cageo.2016.08.003
% 
%% Author Info
% This function and supporting documentation were written by Chad A. Greene
% of NASA Jet Propulsion Laboratory, October 2020. 
% 
% See also melt_interp_adusumilli.

%% Parse inputs 

load2d = true; % Load the 500 m static map by default. 

tmp = strncmpi(varargin,'timeseries',4); 
if any(tmp) 
   load2d=false; 
   assert(exist('bedmachine_interp.m','file')==2,'Cannot find the bedmachine_interp.m function. If you want a timeseries of melt rates, you will need BedMachine. Otherwise you can still load the 500 m resolution static data.') 
   assert(exist('itslive_interp.m','file')==2,'Cannot find the itslive_interp.m function. If you want a timeseries of melt rates, you will need the velocity mosaic. Otherwise you can still load the 500 m resolution static data.') 
   assert(exist('bb0448974g_2_1.h5','file')==2,'Cannot find bb0448974g_2_1.h5. Get it here: https://doi.org/10.6075/J04Q7SHT (look under the Components heading)')
   assert(exist('cube2rect.m','file')==2,'Cannot find cube2rect, which is a necessary function from Climate Data Toolbox for Matlab. Go get it plz.') 
else
   assert(exist('bb0448974g_3_1.h5','file')==2,'Cannot find bb0448974g_3_1.h5. Get it here: https://doi.org/10.6075/J04Q7SHT (look under the Components heading)')
end

%% Load data

if load2d
   
   fn = 'bb0448974g_3_1.h5';
   x = h5read(fn,'/x'); 
   y = h5read(fn,'/y'); 
   M = permute(h5read(fn,'/w_b'),[2 1]); 
   
   % Fill missing data with w_b_interp: 
   w_b_interp = permute(h5read(fn,'/w_b_interp'),[2 1]); 
   M(isnan(M)) = w_b_interp(isnan(M)); 
   
   % I like this convention: 
   M = flipud(M); 
   y = fliplr(y); 

else
   
   fn = 'bb0448974g_2_1.h5';
   X = h5read(fn,'/x')'; 
   Y = flipud(h5read(fn,'/y')'); 
   x = X(1,:); 
   y = Y(:,1); 
   t = datenum(h5read(fn,'/time'),0,0); 
   h = flipud(permute(h5read(fn,'/h_alt'),[2 1 3]));
   h(h==0) = NaN; 
   FAC = flipud(permute(h5read(fn,'/h_firn'),[2 1 3])); 
   SMB = flipud(permute(h5read(fn,'/smb_discharge'),[2 1 3])); 
   
end

%% Convert surface elevation anomalies to basal melt rates: 

if ~load2d

   % Convert measured surface height anomaly into an ice thickness anomaly:  
   H = (h-FAC)*9.3; 
   
   % Calculate the thickness rate: 
   isf = any(isfinite(H),3); % mask is true wherever there's any data
   H2 = cube2rect(H,isf);  % reshapes using Climate Data Toolbox function
   dHdt2 = gradient(H2')'*4; % quarterly sampling, so multiplying thickness gradient by four converts to m/yr
   dHdt = rect2cube(dHdt2,isf); % gets it back into shape.
   
   % Calculate ice divergence: 
   % Ideally we would use a time-varying thickness and time-varying velocity, 
   % but in this function we will just assume they're constant. The divergence
   % calculation appears at the bottom of this function, for reference. 

   D = load('divergence_adusumilli_grid.mat'); 
   
   M = -(dHdt - SMB + D.div);

end

%% Divergence Calculation
% This calculation takes about three minutes on my laptop, and it also requires
% BedMachine data, my BedMachine functions, ITS_LIVE velocity data, my ITS_LIVE 
% functions, and Climate Data Toolbox for Matlab. Rather than require users 
% to do all that, it's faster and easier just to save the filtered divergence
% grid and load it as needed. 
% 
% % 10 km grid points: 
% fn = 'bb0448974g_2_1.h5';
% X = h5read(fn,'/x')'; 
% Y = flipud(h5read(fn,'/y')'); 
%    
% % Load velocity and thickness datasets: 
% vx = itslive_data('vx'); 
% [vy,xi,yi] = itslive_data('vy'); 
% [H0,xb,yb] = bedmachine_data('thickness'); 
% 
% % Lowpass filter and interpolate to Susheel's grid: (Lowpass filter first to 2*res = 20e3 m:  
% vx_lp = filt2(vx,diff(xi(1:2)),20e3,'lp'); % filt2 is in the Climate Data Toolbox for Matlab
% vy_lp = filt2(vy,diff(xi(1:2)),20e3,'lp'); 
% H0_lp = filt2(H0,diff(xb(1:2)),20e3,'lp'); 
% 
% % Intepolate: 
% H0s = interp2(xb,yb,H0_lp,X,Y); 
% vxs = interp2(xi,yi,vx_lp,X,Y); 
% vys = interp2(xi,yi,vy_lp,X,Y); 
% 
% % Calculate divergence:
% % Including thickness and velocity in the divergence term accounts for both advection and stretching:  
% div = divergence(X,Y,H0s.*vxs,H0s.*vys); 
% 
% readme = 'anti-aliased divergence pattern for calculating melt rates from dH/dt rates. Find the calculation at the bottom of the melt_data_adusumilli function.'; 
% 
% save('divergence_adusumilli_grid.mat','X','Y','div','readme')

