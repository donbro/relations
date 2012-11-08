## -*- encoding:utf-8 -*-

##
##  file: "templates/table.mako"
##
##  Mako template to output summary page for table
##
##  Called from (controller) file "do_table.py"
##

##
##      Module-level block
##

<%!
    # no module-level statements
%>

<%doc>

Module-level Blocks

Code within these tags is executed at the module level of the template, and not within the rendering function of the template. 
Therefore, this code does not have access to the template’s context and is only executed when the template is loaded into memory 
(which can be only once per application, or more, depending on the runtime environment). 
Use the <%! %> tags to declare your template’s imports, as well as any pure-Python functions you might want to declare
#import itertools

</%doc>


##
##      Python-level block(s)
##


<%

#   accessing run-time variables must be executed in a python block
#   (the module-level blocks do not have access to the context variable).

cur_rows =  [row for row in cur]
        
%>

<%doc>

Python blocks

Sometimes it is useful to be able to directly write Python code in templates. 
This can be done with Python blocks, although Python code is really best kept to the controllers where possible 
to provide a clean interface between your controllers and view. You can use a Python block like this:

<%
    title = 'Pylons Developer'
    names = [x[0] for x in c.links]
%>


don't need to do a statement like:
      cur = context.get("cur")
because the mako runtime will automatically have executed a statement like:

        cur = context.get('cur', UNDEFINED)
    cur.execute(query) has been called prior to calling this template
    columns = [d[0].decode('utf8') for d in cur.description] 

</%doc>


##
##      Begin HTML Template
##

<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  
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

    p.p47 {margin: 0.0px 0.0px 0.0px 0.0px; text-align: left; font: 12.0px Courier; background-color: #ffefcf}

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
<p class="p2"><br></p>
<p class="p46">${title | entity}</p>
<p class="p2"><br></p>
<p class="p46">The Relation <b>${rel_name}</b></p>
<p class="p2"><br></p>
<p class="p2"><i>${tagline}</i></p>
<p class="p2"><br></p>
<p class="p2">${title}</p>
<p class="p2"><br></p>
<p class="p2">The relation ${rel_name} describes the relation between attributes and domains is:</p>
<p class="p2"><br></p>



<br>
${format_relation(rel_name, columns, cur_rows, in_rowcount=rowcount)}
<br>

<p class="p2"><b></b><br></p>

<p class="p2">The tuples of table ${rel_name} can be read as:</p>
<p class="p2"><br></p>

% for row in cur_rows[ 0 : rowcount]:

<%
if row[0][0] in "aeiouy":
   ar = "an"
else:
   ar = "a"
%>

% if rel_name == "domains":
<p class="p45"><b>${row[1]}</b> is an example of ${ar} <span class="s1">${row[0]}</span></p>
<p class="p45"><span class="s1">${row[0]}</span> is the superclass for <span class="s1">${row[1]}</span></p>
% elif rel_name == "names":
<p class="p45"><b>${row[1]}</b> is the string at id <span class="s1">${row[0]}</span></p>
<p class="p45"><b>${row[0]}</b> is an id for the string <span class="s1">${row[1]}</span></p>
% else:
<p class="p45"><b>${row[1]}</b> is ${ar} <span class="s1">${row[0]}</span></p>
% endif

<p class="p6"><br></p>

% endfor

<br>
${format_relation("mako runtime context", [u"key", u"value"] , dict(context).items(), row_cell_class="p47", in_valign="right" )}

<%text>
<p class="p2"><br>
    This is some Mako syntax which will not be executed: ${variable}
    Neither will this <%doc>be treated as a comment</%doc>
</%text>
</p>


<%text>
<p class="p2"><br>

This tag suspends the Mako lexer’s normal parsing of Mako template directives, and returns its entire body contents as plain text. It is used pretty much to write documentation about Mako:

<tt>
<%text filter="h">
    heres some fake mako ${syntax}
    <%def name="x()">${x}</%def>
</tt>
</p>
</%text>


<%text>
<p class="p2"><br>
Using <%def> Blocks¶
A def block is rather like a Python function in that each def block has a name, can accept arguments, and can be called. 
</p>
</%text>

<%text>
<p class="p2"><br>
<b>Expression Substitution</b>
The simplest expression is just a variable substitution. The syntax for this is the ${} construct, which is inspired by Perl, Genshi, JSP EL, and others.
</p>
</%text>



<p> This output generated by <tt>${calling_filename}</tt>. </p>

<p class="p2">end.</p>
</body>
</html>


##
##  Function Definitons
##

##
##  def format_relation()
##

<%def name="format_relation(rel_name, column_names, in_rows, in_valign='middle', row_cell_class='p4', in_rowcount=None,)">

    <%def name="link(label, url)">
        % if url:
            <a href="${url}">${label}</a>
        % else:
            ${label}
        % endif
    </%def>

    <% 
        if in_rowcount == None:
            in_rowcount = len(in_rows)
    %> 

    ##
    ##      single-cell table for display of relation name
    ##

    <table cellspacing="0" cellpadding="0" class="t1">
    <tbody>
        <tr>
        <td valign="middle" class="td2">
            <p class="p2"><b>${rel_name}</b></p>
        </td>
        </tr>
    </tbody>
    </table>

    <p class="p2"><br></p>

    ##
    ##      main table for relation contents
    ##

    <table cellspacing="0" cellpadding="0" class="t1">
        <tbody>

        ##  relation header

        <tr>
            % for column_name in column_names:
            <td valign="middle" class="td2">
                <p class="p3"><b>${column_name}</b></p>
            </td>
            % endfor
        </tr>

        ##  relation rows

        % for in_row in in_rows[ 0 : in_rowcount]:
            <tr>
                %   for b in in_row:
                    <td valign="${in_valign}" class="td3">
                        <p class=${row_cell_class}>${b|entity}</p>
                    </td>
                %   endfor
            </tr>
        % endfor

    </tbody>
    </table>


</%def>


<%def name="get_article(row)">
    <%
    if row[0][0] in "aeiouy":
        context["ar"] = "an"
    else:
        ar = "a"
    %>
</%def>


<%doc>
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

<p>
% for key in context.keys():
The key is <tt>${key}</tt>, the value is ${str(context.get(key))}. <br />
% endfor
</p>

</%doc>
