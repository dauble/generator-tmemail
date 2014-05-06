'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var chalk = require('chalk');


var TmemailGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    this.on('end', function () {
      if (!this.options['skip-install']) {
        this.installDependencies();
      }
    });
  },

  askFor: function () {
    var done = this.async();

    // have Yeoman greet the user
    this.log(this.yeoman);

    // replace it with a short and sweet description of your generator
    this.log(chalk.magenta('You\'re using the fantastic Tmemail generator.'));

    var prompts = [{
      name: 'projectName',
      message: 'What is the project name?'
    }];

    this.prompt(prompts, function (props) {
      this.projectName = props.projectName;

      done();
    }.bind(this));
  },

  app: function () {
    this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
    this.copy('_package.json', 'package.json');
    this.copy('_package.json', 'package.json');

    this.mkdir('app');
    this.mkdir('app/images');

    this.copy('_template.html', 'app/template.html');
    this.copy('_basic.html', 'app/basic.html');

    this.directory('stylesheets', 'app/stylesheets');
  },

  projectfiles: function () {
    this.copy('_gitignore', '.gitignore');
  }
});

module.exports = TmemailGenerator;