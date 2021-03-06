function par = structargs(varargin)
% par = structargs(defaults, varargin)
%
% Overwrites fields in struct defaults with those specified by:
%  - if arg(1) is a structure, the values therein
%  - the values specified in 'name', value pairs in the arguments list
%    (these values take precedence over arg(1)
%  - 
% Returns defaults with its values overwritten or new values added
%
% par = structargs(varargin)
% 
% Same functionality as above, except uses all existing variables in the 
% calling workspace as defaults
%
% Author: Dan O'Shea (dan@djoshea.com), (c) 2008

if(nargin < 1)
    error('You must provide at least 1 arguments. Call help structargs');
end

if(nargin == 1) 
    
    defaults = varargin{1};
    arg = {};
else
    defaults = varargin{1};
    arg = varargin{2:end};
end

if(iscell(defaults))
    % construct defaults from all variables in the calling workspace
    arg = defaults;
    defaults = [];
    callingWorkspaceVars = evalin('caller', 'who');
    
    for i = 1:length(callingWorkspaceVars)
        defaults.(callingWorkspaceVars{i}) = evalin('caller', callingWorkspaceVars{i});
    end
end

% no overrides?
if(isempty(arg))
    par = defaults;
    return;
end

% start with the defaults
par = defaults;

% SDS: 
if isstruct( arg )
    newval = arg;
    fields = fieldnames(newval);
    
    for i = 1:length(fields)
        par.(fields{i}) = newval.(fields{i});
    end
    
    return
end
% /SDS

% overwrite with struct values from arg(1)
if(isstruct(arg{1})) 
    newval = arg{1};
    fields = fieldnames(newval);
    
    for i = 1:length(fields)
        par.(fields{i}) = newval.(fields{i});
    end
    
    if(length(arg) > 1)
        arg = arg(2:end);
    else
        return;
    end
end

% overwrite with name/value pairs
for i = 1:2:length(arg)
    if(ischar(arg{i}))
        if(length(arg) >= i+1)
            par.(arg{i}) = arg{i+1};
        else
           warning('STRUCTARGS:argParseError', 'Cannot find value for field "%s"', arg(i));
        end
    else
       warning('STRUCTARGS:argParseError', 'Cannot parse arg(%d) as a field name', i); 
    end 
end

end

