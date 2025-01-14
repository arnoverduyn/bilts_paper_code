function [folders, number_of_folders] = find_all_subfolders_in_folder(folder)
    folders = dir(folder);
    folders = folders(arrayfun(@(x) ~strcmp(x.name(1),'.'),folders));
    number_of_folders = length(folders);
end