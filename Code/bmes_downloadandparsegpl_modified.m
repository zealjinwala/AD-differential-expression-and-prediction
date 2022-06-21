function gpldata=bmes_downloadandparsegpl_hollis(gplid)
% * Download e.g.,
% http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?form=text&acc=GPL96&view=full
% * geosoftread()

if ~exist('gplid','var'); gplid='GPL96'; end
file = [tempdir '/' gplid '.txt'];

if ~isfile(file)


%Ignore the following line, it only works on Ahmet's computer.
if 0&&any(exist('bmes_downloadandparsegpl_ahmet')==[2 5 6]); gpldata=eval('bmes_downloadandparsegpl_ahmet(gplid)'); return; end

url = sprintf('https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?form=text&acc=%s&view=full',gplid);
urlwrite(url, file);
end
gpldata = geosoftread( file );
