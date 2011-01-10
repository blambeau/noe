# Noe - A simple and extensible project generator

Noe helps development by providing support for project templates and instantiation.

## Why?

I'm pretty sure I have seen announcements for similar projects on ruby-lang in the past, 
but I could not find them anymore... so I started mine. Please let me know alternatives
and I'll add them below:

See also: 

* ...
    
Other reasons:

* Noe is agnostic: it does not make any assumption about project semantics
* Noe does not restrict itself to generation of ruby projects
* Noe is not required at runtime: once your project is generated you're done
* I don't like magic

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

### Instantiation process

The instantiation process is really simple. Given the variables described in the noespec.yaml 
file (for which values are specified in your .noespec file) templates can use the following
meta-constructions:

* Template files and directories containing `__variable__` in their name are automatically 
  renamed (`__variable__` is replaced by the corresponding value).
* All template files are instantiated by [wlang](https://github.com/blambeau/wlang). You don't
  have to know wlang in depth. You simply have to know that `!{ruby_expression}` in a file is 
  replaced by the expression evaluation. Variables are automatically in scope of such expressions,
  so that `!{variable}` is replaced by its value.

## Contributing

Fork Noe on github! I'm particularly interested in the following enhancements:

* Extend test coverage, which is ugly so far.
* Enhance the default ruby template, but remember "documentation matters, not magic!"
* Add support for other generators than _wlang_
* Add support for multi-generated files from arrays in .noespec files
* ...

If you think that your template is worth considering for (ruby, rails, js, latex, or anything 
else) please let me known and I'll add it to the list below.

* ...
