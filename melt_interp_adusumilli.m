function mi = melt_interp_adusumilli(lati_or_xi,loni_or_yi,varargin)
% melt_interp_adusumilli interpolates ice shelf basal melt rates using
% 500 m resoltuion data from Adusumilli et al, 2020. 
% 
%% Syntax
% 
%  mi = melt_interp_adusumilli(lati,loni)
%  mi = melt_interp_adusumilli(xi,yi)
%  mi = melt_interp_adusumilli(...,'antialias',wavelength)
% 
%% Description
% 
% mi = melt_interp_adusumilli(lati,loni) interpolates the composite melt rates
% (representing the years 2010-2018) at the geographic locations lati,loni. 
% 
% mi = melt_interp_adusumilli(xi,yi) as above, but for the query points xi,yi
% in south polar stereographic meters. 
%
% mi = melt_interp_adusumilli(...,'antialias',wavelength) performs spatial
% antialiasing before interpolation. This option is provided because the raw
% data is distributed at 500 m resolution, but you may be interpolating to a 
% coarser resolution grid. For antialiasing, a decent rule of thumb is to 
% lowpass filter to a wavelength of twice the resolution of the query grid. 
% In other words, if you are interpolating to a 3 km grid, use 6000 as the 
% wavelength value to meet Nyquist. The antialiasing option uses the filt2 
% function from Climate Data Toolbox, and may take a couple seconds to compute. 
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
% See also melt_data_adusumilli.


%% Parse inputs

narginchk(2,Inf)
assert(isequal(size(lati_or_xi),size(loni_or_yi)),'Dimensions of query coordinates must agree.') 

% Are inputs georeferenced coordinates or polar stereographic?
if islatlon(lati_or_xi,loni_or_yi)
   [xi,yi] = ll2ps(lati_or_xi,loni_or_yi); % The ll2ps function is in the Antarctic Mapping Tools package.
else
   xi = lati_or_xi;
   yi = loni_or_yi;    
end

antialias = false; % by default
tmp = strncmpi(varargin,'antialias',4); 
if any(tmp)
   antialias = true; 
   wavelength = varargin{find(tmp)+1}; 
   assert(isscalar(wavelength),'Specified wavelength must be a scalar in meters.') 
end

%% Load data 

[M,x,y] = melt_data_adusumilli; 

%% Perform mathematics: 

if antialias
   isn = isnan(M); 
   M = filt2(M,500,wavelength,'lp'); 
   M(isn) = NaN; % Because filt2 fills edges that should remain as nans
end

mi = interp2(x,y,M,xi,yi); 


end