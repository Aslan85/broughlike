let project = new Project('BroughLike');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addShaders('Shaders/**');
project.addLibrary('raccoon');
project.addLibrary('delta');
resolve(project);