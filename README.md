# Noe - A simple and extensible project generator

Noe helps development via support for well-designed templates.

## Getting started

    [sudo] gem install noe
    [noe --help]
    [noe help install]
    noe install 
    
Have a loot at ~/.noerc and ~/.noe for configuration and a default ruby 
template.
  
## Usage summary

Maintain your templates under ~/.noe (or what you provided at installation time). Have a 
look at github to find xxx.noe projects to find well-designed/documented templates for
specific needs.

To create a fresh new project:

  # Given a template xxx under ~/.noe/xxx
  noe create --template=xxx foo
  cd foo
  
  # Edit the template configuration foo/foo.noespec
  edit foo/foo.noespec
  
  # Launch template instantiation
  noe go
  
That's it! But also have a look at 'noe help create' and 'not help go' for additional
options.

## About templates

Under ~/.noe, a valid template folder (say xxx) has the following structure

xxx                         # Template name
  README(.md|.txt|...)      #   Information about the template and it's usage
  CHANGELOG(.md|.txt|...)   #   Change information
  noespec.yaml              #   Template specification
  src                       #   Source folder, contains files to be instantiated
    ...                     #     [everything that will be instantiated]

### noespec.yaml

The noespec.yaml file of a template is used to formally describe the template. When a project 
(say foo) is created (see 'noe create') using a template (say ruby) the file 
~/.noe/ruby/noespec.yaml is used to generate foo/foo.noespec. The later is then used by 
'noe go' to instantiate the project.

The noespec.yaml file should ressemble something like this:

    # DO NOT TOUCH 'name' entry and specify the other
    template-info:
      name: !{template_name}
      description: ...
      version: ...
      author: ...

    #
    # The following is a hash of template-related variables. They are
    # used to provide dynamic file names and instantiate file contents.
    #
    # Current version of Noe only supports variable names matching /[a-z]+/
    #
    variables:
      ...

Have a look at ~/.noe/ruby/noespec.yaml and ~/.noe/ruby/src for an example.