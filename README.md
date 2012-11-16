![Buckshot Logo](http://www.buckshotui.org/sandbox/web/resources/buckshot_logo.png)

### Buckshot [buhk-shot] *noun* When darts land wildly all over the board. ###
Buckshot is a multi-platform application framework. This core library provides
the foundations for other target platforms to build from. Some of the core
features provided include a template parser, data-binding, events,
actions, style templates, and more.  Most developers will not import this core
library directly, but will instead choose one of the platform extension
libraries (see "Platform Choices" below).

If you've worked with .net WPF or Silverlight then this framework will feel very 
familiar to you.

## Status: Alpha ##
Project is currently in the **alpha** stage of development.  It will likely not
move to beta or v1.0 until after Dart ships v1.0. This is to ensure that that 
library is working correctly with the Dart APIs, which are still in flux.

## Buckshot is a Multi-Platform Framework##
This means that Buckshot can target virtually any rendering technology where
the Dart VM is available.

### Platforms Choices ###
* HTML5 - [Buckshot HTML Platform](https://github.com/prujohn/buckshot_html)

Coming soon...

* SVG
* HTML5 Canvas
* WebGL

Coming eventually...

* Native GUI

## Getting Started ##
See the "getting_started" document in the platform library of your choice.

## Features ##
<table>
<tr>
<td>Template-Centric</td>
<td>Similar to Xaml, but more simplified and flexible.  Supports XML and JSON formats.</td>
</tr>
<tr>
<td>Multi-Platform</td>
<td>Dozens of controls included with the core library, everything from primitive shapes to complex template-supporting controls, like ListBox and TreeView</td>
</tr>
<tr>
<td>Actions</td>
<td>Event-driven actions, like playing animations, changing properties, etc, in XML templates instead of code (you can also do it in code too, if desired)</td>
</tr>
<tr>
<td>Data Binding</td>
<td>
Buckshot supports 4 different types of binding from XML templates (or in code):  Resource binding, element-to-element binding, data binding, and template binding</td>
</tr>
<tr>
<td>Events</td>
<td>.net folks will find this model to be very familiar.  We use it to wrap DOM events and for other internal events, but you can use it in your own apps</td>
</tr>
<tr>
<td>Style Templates</td>
<td>Use a common style library among multiple elements.  Individual changes to style property values will automatically update any elements using that style</td>
</tr>
<tr>
<td>Extensibility</td>
<td>Everything in Buckshot is designed to be extensible, so you can create libraries of your own controls, resources, and more</td>
</tr>
</table>

**And Much, Much More** [More Details Here] (https://github.com/prujohn/Buckshot/wiki/What-is-Buckshot%3F)

## License ##
Apache 2.0. See license.txt for project licensing information.

## Contact ##
Buckshot Discussion Group: <https://groups.google.com/forum/#!forum/buckshot-ui>

Buckshot on G+: <https://plus.google.com/b/105133271658972815666/105133271658972815666/posts>

Blog: <http://phylotic.blogspot.com>
