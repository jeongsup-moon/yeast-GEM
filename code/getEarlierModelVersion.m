function model=getEarlierModelVersion(version)
% getEarlierModelVersion
%   Loads an earlier model version from the local yeast-GEM git repository.
%
%   version     Should either be "main" or "develop" to get the most recent
%               model from either branch, or a specific model version in
%               the format "8.1.2".
%
%   Usage:  model=getEarlierModelVersion(version)
%

if any(regexp(version,'^\d+\.\d+\.\d+$')) % Tag is a version number
    tagpath=['git show refs/tags/v' version ':'];
elseif any(contains(version,{'main','develop'}))
    tagpath=['git show ' version ':'];
else
    error('version should be ''main'', ''develop'', or a specific release, e.g. ''8.1.0''')
end


[~,msg]=evalc(['system(''' tagpath 'model/yeast-GEM.xml > _earlierModel.xml'')']);
switch msg
    case 0
    case 1
        error('This function only works if the yeast-GEM git repository is present')
    case 128 % Try old folder structure
        system([tagpath 'ModelFiles/xml/yeastGEM.xml > _earlierModel.xml']);
    otherwise
        error(['Unrecognized error from git: ' num2str(msg)])
end

model=importModel('_earlierModel.xml');
delete '_earlierModel.xml'
disp(['Loaded model version: ''' regexprep(model.id,'yeastGEM_v?','') ''''])