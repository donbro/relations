## -*- coding: utf-8 -*-

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

##
##  file: "templates/table.mako"
##
##  Mako template to output summary page for table
##
##  Used by do_table.py
##

<%!

import mysql.connector
from pprint import pprint

cnx = mysql.connector.connect(user='root', password='',host='127.0.0.1',database='relations')

cur = cnx.cursor()

"""You can't slice a generator directly in python. 
    You could use itertools.islice() as a helper function to do so. 
    itertools.islice(generator, start, stop, step) 
    Remember, slicing a generator will exhaust it partially. 
    If you want to keep the entire generator intact, 
    perhaps turn it into a tuple or list first: result = tuple(generator)
    """
import itertools
%>

<%doc>

Module-level Blocks

Code within these tags is executed at the module level of the template, and not within the rendering function of the template. 
Therefore, this code does not have access to the template’s context and is only executed when the template is loaded into memory 
(which can be only once per application, or more, depending on the runtime environment). 
Use the <%! %> tags to declare your template’s imports, as well as any pure-Python functions you might want to declare

Sometimes it is useful to be able to directly write Python code in templates. This can be done with Python blocks, although as has already been described, Python code is really best kept to the controllers where possible to provide a clean interface between your controllers and view. You can use a Python block like this:

<%
    title = 'Pylons Developer'
    names = [x[0] for x in c.links]
%>

</%doc>

<br>
Mako template context is:
<%


#pprint(dict(context))

#print("${context.keys()} is:")

#pprint(context.__dict__)

#print relation_name
if relation_name == u"relations":
    query = "select attr1,dom1,dom2,attr2 from relations_view"
elif relation_name == u"domains":
    query = "select dom_name, attr_name from domains_view"
else:
    query = "SELECT * from " + relation_name

cur.execute( query )

# print cur.description
# [('attr1', 253, None, None, None, None, 0, 4097), ('dom1', 253, None, None, None, None, 0, 4097), ('dom2', 253, None, None, None, None, 0, 4097), ('attr2', 253, None, None, None, None, 0, 4097)]

columns = [d[0].decode('utf8') for d in cur.description] 

#   [u'attr1', u'dom1', u'dom2', u'attr2']

result = []

for row in cur:
    result.append(row)
    # print row
    #   (u'Albert Einstein', u'author', u'work', u'Electrodynamics of Moving Bodies')

#zz = result[0]  # list of dicts
#zzd = zz.keys()
#zzv0 = zz.values()

# {u'id': u'n000001', u'name': u'gronk'}

pprint( result )

        
%>



<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  ##<title>${title}</title>
  <title>${title | entity}</title>
  <meta name="Generator" content="Cocoa HTML Writer">
  <meta name="CocoaVersion" content="1138.51">
  <style type="text/css">
    p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; font: 14.0px 'Myriad Pro'}
    p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; font: 14.0px 'Myriad Pro'; min-height: 18.0px}
    p.p3 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: center; font: 14.0px 'Myriad Pro'; color: #103888}
    p.p4 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: center; height: 12.0px; font: 14.0px 'Myriad Pro' }
    p.p45 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: center; font: 14.0px 'Myriad Pro' }
    
    p.p46 {margin: 0.0px 0.0px 0.0px 0.0px; font: 30.0px 'Chaparral Pro'; background-color: #b6b5b5}

    p.p5 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: center; height: 12.0px; font: 14.0px 'Myriad Pro'}
    p.p6 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: center; font: 14.0px 'Myriad Pro'; min-height: 18.0px}
    span.s1 {font: 14.0px 'Avenir Next LT Pro'; color: #00296f}
    table.t1 {border-collapse: collapse}
    td.td1 {background-color: #d9d9d9; padding: 0.0px 5.0px 0.0px 5.0px}
    td.td2 {background-color: #d9d9d9; border-style: solid; border-width: 1.0px 1.0px 1.0px 1.0px; border-color: #c4c4c4 #c4c4c4 #c4c4c4 #c4c4c4; padding: 0.0px 5.0px 0.0px 5.0px}
    td.td3 {height: 42.0px; border-style: solid; border-width: 1.0px 1.0px 1.0px 1.0px; border-color: #c4c4c4 #c4c4c4 #c4c4c4 #c4c4c4; padding: 0.0px 5.0px 0.0px 5.0px}
    td.td4 {border-style: solid; border-width: 1.0px 1.0px 1.0px 1.0px; border-color: #c4c4c4 #c4c4c4 #c4c4c4 #c4c4c4; padding: 0.0px 5.0px 0.0px 5.0px}
  </style>
</head>

<body>
<p class="p2"><br>
<b>Expression Substitution</b>
The simplest expression is just a variable substitution. The syntax for this is the \$\{\} construct, which is inspired by Perl, Genshi, JSP EL, and others.
</p>

<p class="p3"><br></p>
<p class="p3"><br></p>
<p class="p46">${title | entity}</p>
<p class="p3"><br></p>
<p class="p46">The Relation <b>${relation_name}</b></p>
<p class="p3"><br></p>
<p class="p2"><i>${tagline}</i></p>
<p class="p3"><br></p>
<p class="p3"><br></p>

<p class="p1">${title}</p>
<p class="p2"><br></p>
<p class="p2"><br></p>
<p class="p1">The relation ${relation_name} describes the relation between attributes and domains is:</p>
<p class="p2"><br></p>
<p class="p2"><br></p>


<p>
% for key in context.keys():
The key is <tt>${key}</tt>, the value is ${str(context.get(key))}. <br />
% endfor
</p>


<ul>
% for a in dict(context):
    <li>
    <p class="p2">
    Item ${loop.index}:

    ${a}, ${repr(context[a]) | entity}

    <br></p>
    </li>
% endfor
</ul>


<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>

      % for a in dict(context):
    <tr>
      <td valign="middle" class="td3">
        <p class="p4">${a|entity}</p>
      </td>

      <td valign="middle" class="td3">
        <p class="p4">${repr(context[a])|entity}</p>
      </td>

    </tr>
        % endfor

  </tbody>
</table>

<%doc>

#pprint(dict(context))

<ul>
% for a in result:
    <li>
    <p class="p2">
    Item ${loop.index}:
%   for b in a.values():
    ${b},
%   endfor
    <br></p>
    </li>
% endfor
</ul>

</%doc>

##
##      Relation Name
##

<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>
    <tr>
      <td valign="middle" class="td1">
        <p class="p1"><b>${relation_name}</b></p>
      </td>
    </tr>
  </tbody>
</table>

<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>

    ##
    ##  Header
    ##

    <tr>
        %   for b in columns:
      <td valign="middle" class="td2">
        <p class="p3"><b>${b}</b></p>
      </td>
        %   endfor
    </tr>

    ##
    ##  First row
    ##
<%doc>
    <tr>
      <td valign="middle" class="td3">
        <p class="p4">${zzv0[0]}</p>
      </td>
      <td valign="middle" class="td3">
        <p class="p4">${zzv0[1]}</p>
      </td>
    </tr>
</%doc>


    ##
    ##  Template row(s)
    ##

        ## % for a in result:
        % for a in itertools.islice(result, 0, 3): # grab the first three elements
    <tr>
        %   for b in a:
      <td valign="middle" class="td3">
        <p class="p4">${b|entity}</p>
      </td>
        %   endfor
    </tr>
        % endfor

<%doc>
    <tr>
      <td valign="middle" class="td4">
        <p class="p5">work</p>
      </td>
      <td valign="middle" class="td4">
        <p class="p6"><i></i><br></p>
        <p class="p4"><i>Electrodynamics of Moving Bodies</i></p>
        <p class="p6"><br></p>
      </td>
    </tr>
</%doc>

  </tbody>
</table>

<p class="p2"><b></b><br></p>
##<p class="p1">The first tuple in this relation could be read as</p>
##<p class="p1">the tuples of table <b>${relation_name}</b> can be read as:</p>
<p class="p1">The tuples of table ${relation_name} can be read as:</p>
<p class="p2"><br></p>

## % for row in result[0:3]:
% for row in itertools.islice(result, 0, 3): # grab the first three elements

<%
if row[0][0] in "aeiouy":
   ar = "an"
else:
   ar = "a"
%>

% if relation_name == "domains":
<p class="p45"><b>${row[1]}</b> is an example of ${ar} <span class="s1">${row[0]}</span></p>
<p class="p45"><span class="s1">${row[0]}</span> is the superclass for <span class="s1">${row[1]}</span></p>
% elif relation_name == "names":
<p class="p45"><b>${row[1]}</b> is the string at id <span class="s1">${row[0]}</span></p>
<p class="p45"><b>${row[0]}</b> is an id for the string <span class="s1">${row[1]}</span></p>
% else:
<p class="p45"><b>${row[1]}</b> is ${ar} <span class="s1">${row[0]}</span></p>
% endif

<p class="p6"><br></p>

% endfor

<%text>
    This is some Mako syntax which will not be executed: ${variable}
    Neither will this <%doc>be treated as a comment</%doc>
</%text>

<p class="p1">end.</p>
</body>
</html>
