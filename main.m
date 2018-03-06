%funcs={@webserver,@redObjectTrack};%
%solutions=cell(1,2);
%parfor i = 1:2
%    solutions{i}=funcs{i}();
%end
% global startDraw
j = batch('webserver');
redObjectTrack();
delete(j)
%spmd(1)
%    webserver()
%end
