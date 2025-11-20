<?xml version="1.0" ?>

<!DOCTYPE xsl:stylesheet [
  <!-- Mozilla does not process external entities.
  <!ENTITY % AOMLentities SYSTEM "AOML.ent">
  %AOMLentities;
  -->

<!-- Useful symbols. -->
<!ENTITY copy     "&#169;">
<!ENTITY plusmn   "&#177;">

<!-- Greek. Needed for star names. -->
<!ENTITY alpha    "&#945;">
<!ENTITY beta     "&#946;">
<!ENTITY gamma    "&#947;">
<!ENTITY delta    "&#948;">
<!ENTITY epsilon  "&#949;">
<!ENTITY zeta     "&#950;">
<!ENTITY eta      "&#951;">
<!ENTITY theta    "&#952;">
<!ENTITY iota     "&#953;">
<!ENTITY kappa    "&#954;">
<!ENTITY lambda   "&#955;">
<!ENTITY mu       "&#956;">
<!ENTITY nu       "&#957;">
<!ENTITY xi       "&#958;">
<!ENTITY omicron  "&#959;">
<!ENTITY pi       "&#960;">
<!ENTITY rho      "&#961;">
<!ENTITY sigma    "&#963;">
<!ENTITY tau      "&#964;">
<!ENTITY upsilon  "&#965;">
<!ENTITY phi      "&#966;">
<!ENTITY chi      "&#967;">
<!ENTITY psi      "&#968;">
<!ENTITY omega    "&#969;">

]>

<!-- FILE    : AOML.xsl
     AUTHOR  : (C) Copyright 2024 by Peter Chapin
     SUBJECT : Style sheet to convert AOML into HTML.
     
TO DO:

+ Include the primary datetime in the title. This is tough to do in general because observations
  sets might be factored on a different parameter than datetime.

+ This style sheet is extremely pathetic. It needs more help than I have space to mention here.

-->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:aoml="https://www.pchapin.org/XML/AOML" exclude-result-prefixes="xsi aoml">

  <xsl:output method="xml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="yes"/>

  <xsl:template match="aoml:entry-set">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en-US">
      <head>
        <!-- Probably eventually the title should come from the AOML document. -->
        <title>Observation Log</title>
        <link rel="stylesheet" href="default.css" type="text/css"/>
      </head>
      <body>
        <h1>Observation Log</h1>
        <hr/>

        <!-- Note that I don't handle nested entry-sets at this time. -->
        <xsl:apply-templates select="aoml:entry"/>

        <hr/>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="aoml:observation-set">
    <!-- TODO: The language should come from the AOML document. -->
    <html lang="en-US">
      <head>
        <!-- TODO: The title should come from the AOML document. -->
        <title>Observations</title>
        <link rel="stylesheet" href="default.css" type="text/css"/>
      </head>
      <body>
        <h1>Observations</h1>
        <hr/>

        <!-- If this observation set applies to a single object, handle that. -->
        <xsl:if test="aoml:object">
          <xsl:apply-templates select="aoml:object"/>
        </xsl:if>

        <!-- If this observation set applies to an object group, handle that. Note that the
             schema doesn't currently (2003-07-21) allow object groups to be children of
             observation-set. This should probably be corrected eventually. Actually, as I look
             at this (2025-11-20), I can see that not even object elements are allowed as
             direct children of observation-set. I wonder what I/we was/were thinking. -->
        <xsl:if test="aoml:object-group">
          <xsl:apply-templates select="aoml:object-group"/>
        </xsl:if>

        <!-- Create a table of common information, if relevant. -->
        <table>
          <xsl:if test="aoml:datetime">
            <tr>
              <td valign="top">
                <b>Date/Time</b>
              </td>
              <td valign="top">:</td>
              <td>
                <xsl:apply-templates select="aoml:datetime"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="aoml:datetimerange">
            <tr>
              <td valign="top">
                <b>Date/Time</b>
              </td>
              <td valign="top">:</td>
              <td>
                <xsl:apply-templates select="aoml:datetimerange"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="aoml:observer">
            <tr>
              <td valign="top">
                <b>Observer</b>
              </td>
              <td valign="top">:</td>
              <td>
                <xsl:value-of select="aoml:observer"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="aoml:equipment">
            <tr>
              <td valign="top">
                <b>Equipment</b>
              </td>
              <td valign="top">:</td>
              <td>
                <xsl:value-of select="aoml:equipment/aoml:notes/p[1]"/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="aoml:location">
            <tr>
              <td valign="top">
                <b>Location</b>
              </td>
              <td valign="top">:</td>
              <td>
                <xsl:value-of select="aoml:location/aoml:notes/p[1]"/>
              </td>
            </tr>
          </xsl:if>
        </table>

        <xsl:if test="aoml:notes">
          <xsl:for-each select="aoml:notes/*">
            <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
              <xsl:apply-templates select="node()"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:if>

        <!-- Note that I don't handle nested observation-sets at this time. -->
        <xsl:apply-templates select="aoml:observation"/>

        <hr/>
      </body>
    </html>
  </xsl:template>


  <!-- The following template formats an entry. -->
  <xsl:template match="aoml:entry">
    <xsl:apply-templates select="aoml:localdatetime"/>
    <xsl:if test="aoml:text">
      <xsl:for-each select="aoml:text/*">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <!-- The following template formats an observation. -->

  <xsl:template match="aoml:observation">
    <hr/>
    <xsl:apply-templates select="aoml:object"/>
    <xsl:apply-templates select="aoml:object-group"/>
    <xsl:if test="aoml:datetime">
      <p>
        <xsl:apply-templates select="aoml:datetime"/>
      </p>
    </xsl:if>
    <xsl:if test="aoml:datetimerange">
      <p>
        <xsl:apply-templates select="aoml:datetimerange"/>
      </p>
    </xsl:if>
    <p>NOTES</p>

    <xsl:if test="aoml:notes">
      <xsl:for-each select="aoml:notes/*">
        <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>


  <!-- The following template formats object information. Note that the schema allows an object
       to have multiple IDs or names. This template currently doesn't handle that.-->

  <xsl:template match="aoml:object">
    <table border="1">
      <tbody>

        <xsl:if test="aoml:id">
          <tr>
            <td>Object</td>
            <td class="object-id"><xsl:value-of select="aoml:id/@catalog"/>-<xsl:value-of
                select="aoml:id/@id"/></td>
          </tr>
        </xsl:if>

        <xsl:if test="aoml:name">
          <tr>
            <td>Name</td>
            <td>
              <b>
                <xsl:value-of select="aoml:name"/>
              </b>
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="aoml:type">
          <tr>
            <td>Type</td>
            <td>
              <b>
                <xsl:value-of select="aoml:type"/>
              </b>
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="aoml:position">
          <tr>
            <td>Position</td>
            <td>
              <xsl:apply-templates select="aoml:position"/>
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="aoml:constellation">
          <tr>
            <td>Constellation</td>
            <td>
              <b>
                <xsl:value-of select="aoml:constellation"/>
              </b>
            </td>
          </tr>
        </xsl:if>

        <!-- Now deal with formatting for the specific types. -->
        <xsl:if test="@xsi:type = 'starMultipleObjectType'">
          <tr>
            <td>Magnitudes</td>
            <td>
              <b>
                <xsl:for-each select="aoml:component">
                  <xsl:value-of select="@designation"/>=<span class="highlight">
                    <xsl:value-of select="aoml:magnitude"/>
                  </span><xsl:text> </xsl:text>
                </xsl:for-each>
              </b>
            </td>
          </tr>
          <tr>
            <td>Separations</td>
            <td>
              <b>
                <xsl:for-each select="aoml:separation">
                  <xsl:value-of select="@designation-1"/><xsl:value-of select="@designation-2"
                    />=<span class="highlight"><xsl:value-of select="@distance"/>"<xsl:if test="@PA">
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="@PA"/>
                      <xsl:text> degrees) </xsl:text>
                    </xsl:if></span><xsl:text> </xsl:text>
                </xsl:for-each>
              </b>
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template>

  <!-- The following template formats object information for an object group. -->
  <xsl:template match="aoml:object-group">
    <xsl:apply-templates select="aoml:object"/>
  </xsl:template>

  <!-- The following template formats a position. -->
  <xsl:template match="aoml:position">
    <xsl:if test="aoml:equatorial">
      <b>RA=<xsl:value-of select="aoml:equatorial/@right-ascension"/>
        <xsl:text>, </xsl:text> DEC=<xsl:value-of select="aoml:equatorial/@declination"/>
        <xsl:text> </xsl:text> (<xsl:value-of select="aoml:equatorial/@equinox"/>)</b>
    </xsl:if>
  </xsl:template>

  <!-- The following template formats a local datetime. -->
  <xsl:template match="aoml:localdatetime">
    <h1>ENTRY: <xsl:value-of select="aoml:date"/></h1>
  </xsl:template>

  <!-- The following template formats an absolute datetime. -->
  <xsl:template match="aoml:datetime | aoml:start | aoml:end">
    <xsl:value-of select="."/>
    <xsl:if test="@resolution"> &plusmn; <xsl:value-of select="substring(@resolution, 2)"/>
    </xsl:if>
  </xsl:template>

  <!-- The following template formats an absolute datetime range. -->
  <xsl:template match="aoml:datetimerange">
    <xsl:apply-templates select="aoml:start"/>
    <b>
      <xsl:text> --TO-- </xsl:text>
    </b>
    <xsl:apply-templates select="aoml:end"/>
  </xsl:template>

</xsl:stylesheet>
<!--

After having a conversation with ChatGPT, it suggested the following approach. Here
an AOML element containing XHTML uses a template that regenerates XHTML elements (in
the right namespace) recursively.

Here is an example usage...

<xsl:if test="aoml:notes">
  <xsl:for-each select="aoml:notes/*">
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:if>

Here is a template that handles all elements in the XHTML namespace and reconstructs them.

<xsl:template match="xhtml:*">
  <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="@* | node()"/>
  </xsl:element>
  </xsl:template>

And here is a template that handles attributes in the XHMLT namespace and reconstructs them.

<xsl:template match="@*">
  <xsl:attribute name="{local-name()}">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>


ChatGPT showed the following example of how this is supposed to work:

Input from the AOML:

<notes>
  <xhtml:p>
    Just after setting up my telescope, 
    <xhtml:span style="color:red;">it started to rain</xhtml:span>.
  </xhtml:p>
</notes>

Generated (and reconstructed) ouput. Note the correct handling of the nexted <span> element.

<p xmlns="http://www.w3.org/1999/xhtml">
  Just after setting up my telescope, 
  <span style="color:red;">it started to rain</span>.
</p>


-->
