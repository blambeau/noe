# Noe - A simple and extensible project generator

Noe is a tool that generates projects from predefined skeletons (aka project/application 
templates). Skeletons are designed for building specific products (a ruby library, a static 
or dynamic web site, ...). Noe instantiates them then helps you maintaining your product 
thanks to meta-information provided by a yaml file called the project's .noespec file. 

Noe comes bundled with a skeleton for creating and maintaining a ruby gem. This skeleton is
written and maintained to follow ruby best practices and may also be tuned for your own needs.
Read more about it and related projects as well as the underlying philosophy in the sections 
below.

## Getting started and Usage summary

    [sudo] gem install noe
    [noe --help]
    [noe help install]
    noe install 
    
Have a loot at ~/.noerc and ~/.noe for configuration and a default ruby template. To instantiate
a ruby project simply execute the following commands in turn:

    # Given a template ruby under ~/.noe/ruby, install by default
    noe create --template=ruby foo
    cd foo
  
    # Edit the template configuration foo/foo.noespec
    edit foo/foo.noespec
  
    # Launch template instantiation
    noe go
  
That's it! But also have a look at 'noe help create' and 'not help go' for additional
options.

## Philosophy

Noe is designed to follow a certain number of good principles and help you following them 
as well.

### Separation of concerns

Noe maintains a strong separation of concerns. In particular one has to make the distinction 
between a) Noe itself, b) a skeleton and c) an instantiated product. This fact has two main 
consequences:

* Noe itself **is not dedicated to specific products** (like a ruby library). Even if Noe 
  comes bundled with a default template for ruby projects, writing skeletons for something
  else should not be a problem. In other words, Noe itself is agnostic: the semantics of 
  generated products is the secret of the skeleton, under the responsibility of it's 
  maintainer. 

* Noe **should not be a runtime dependency** of the product. Good skeletons maintain this 
  separation. As an example the default ruby skeleton is strictly independent of Noe itself.

### Master the tools YOU use

The separation of concerns described previously also drives what you have to learn and what
tools you have to master:

* As an ordinary Noe user (vs. skeleton maintainer) and because Noe itself (unlike skeletons) is 
  project agnostic, you only have to know **basic Noe commands** (see 'noe --help') and should never
  have to study Noe's API and internals. In contrast, you have to **master the tools and best practices
  of your product's ecosystem**. A good skeleton should help you along this task. As an example, the 
  default ruby skeleton is fully documented to help you gaining understanding of ***rake*, *spec*, 
  *yard*, *bundler*** and so on but **not noe itself**.

* Being a skeleton creator/maintainer is another story of course. To write a skeleton you'll also have 
  to learn **Noe's API and internals**. To write a good/reusable one, you'll certainly have to **master 
  the full ecosystem and best practices of the targetted product**, which is a good opportunity for 
  learning and sharing it!

### Magic Only If Flexible

"Don't Repeat Yourself" and "Convention over Configuration" are certainly good principles. However 
tuning, configuration and options exist, are useful and should certainly not be hidden to the user.
Instead configuration and options should come with default values, and should be fully documented. 
Providing magic is great if there is a user-centric way (in contrast to a developer one) of 
understanding and controlling the magic and underlying assumptions.

As an example, the default ruby template comes with magic: you can create a project and immediately
invoke 'rake test', 'rake yard', ... and not investigating further. You can also have a look at the
_tasks_ folder to understand and control the tasks that your project will use... In fact, you **must** 
investigate: the generated product is yours, not mine and YOU have to master your build chain!
  
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

## Ruby skeleton and Related projects

Noe is inspired by existing projects, mostly from the ruby community. In particular, the default
ruby template has been influenced by the projects below as well as feedback of their authors:

* [hoe](http://seattlerb.rubyforge.org/hoe/), Ryan Davis and Eric Hodel 
* [echoe](https://github.com/fauna/echoe), Evan Weaver 
* [bones](https://github.com/TwP/bones), Tim Pease

These projects help you generating and maintaining ruby projects (generally gem libraries, 
in fact). All provide powerful tools that supports you along the different steps of your 
ruby software lifecycle (creating, testing, releasing, announcing, and so on.). They mostly
differ in the way you can tune/configure the generated project for specific needs.

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
