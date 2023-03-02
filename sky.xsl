<?xml version="1.0" ?>

<!-- FILE        : sky.xsl
     LAST REVISED: 2020-11-19
     AUTHOR      : (C) Copyright 2020 by Peter Chapin
     SUBJECT     : Style sheet to convert sky.xsd into an HTML table.
     
TO DO:

+ The location element needs to be styled better. Provision should be made for longitude and
  latitude if they are present.
  
+ When styling the weather element provide for humidity, and wind speed in a manner similar
  to that for temperature.
  
+ Set up the sky-conditions style similar to the way the weather style is handled (with
  respect to limiting magnitude and seeing, etc).
-->

<xsl:stylesheet version="1.0" xmlns:aoml="http://www.pchapin.org/XML/AOML"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <xsl:output method="html"/>

  <xsl:template match="aoml:observation-set">
    <html lang="en-US">
      <head>
        <title>Sky Conditions</title>
        <link rel="stylesheet" href="default.css" type="text/css"/>
      </head>
      <body>
        <h1>Sky Conditions</h1>
        <hr/>
        <xsl:if test="aoml:localdatetime">
          <p>Default datetime: <u>
              <xsl:value-of select="aoml:localdatetime/aoml:ISO"/>
            </u></p>
        </xsl:if>
        <xsl:if test="aoml:location">
          <p>Default location: <u>
              <xsl:value-of select="aoml:location/aoml:notes/xhtml:p[1]"/>
            </u></p>
        </xsl:if>
        <xsl:if test="aoml:observer">
          <p>Default observer: <u>
              <xsl:value-of select="aoml:observer"/>
            </u></p>
        </xsl:if>
        <xsl:if test="aoml:notes">
          <xsl:value-of select="aoml:notes"/>
        </xsl:if>

        <p>
          <table border="1">
            <tr>
              <th width="80">Date</th>
              <th>Time</th>
              <th>Weather Summary</th>
              <th>Sky Conditions Summary</th>
            </tr>
            <xsl:apply-templates select="aoml:observation"/>
          </table>
        </p>

        <p>For more information on the rating system I use see <a href="sky-codes.xhtml">
            <i>sky-codes</i>
          </a>.</p>

      </body>
    </html>
  </xsl:template>

  <!-- The following template formats an observation as a table row. Note that this template
       assumes the datetime element contains an ISO element and that the local time type is
       either LST or LDT. A more comprehensive solution should deal with the other possibilities
       (although the use of other possibilities in this context wouldn't seem to make much
        sense. -->

  <xsl:template match="aoml:observation">
    <tr>
      <td>
        <b>
          <xsl:value-of select="substring(aoml:localdatetime/aoml:ISO, 1, 10)"/>
        </b>
      </td>
      <td>
        <b>
          <xsl:value-of select="substring(aoml:localdatetime/aoml:ISO, 12, 5)"/>
        </b>
      </td>
      <td>
        <xsl:apply-templates select="aoml:skyconditions/aoml:weather"/>
      </td>
      <td>
        <xsl:apply-templates select="aoml:skyconditions"/>
      </td>
    </tr>
  </xsl:template>

  <!-- The following template formats the weather summary information. -->
  <xsl:template match="aoml:weather">
    <xsl:if test="aoml:temperature">
      <b>temperature = <xsl:value-of select="aoml:temperature/aoml:value"
          /><xsl:text> </xsl:text><xsl:value-of select="aoml:temperature/aoml:value/@units"/></b>
      <xsl:if test="aoml:temperature/aoml:notes"
          ><xsl:text> (</xsl:text><i>NOTE:</i><xsl:text> </xsl:text><xsl:value-of
          select="aoml:temperature/aoml:notes/xhtml:p[1]"/>)</xsl:if>
      <br/>
    </xsl:if>

    <xsl:if test="aoml:pressure">
      <b>pressure = <xsl:value-of select="aoml:pressure/aoml:value"
          /><xsl:text> </xsl:text><xsl:value-of select="aoml:pressure/aoml:value/@units"/></b>
      <xsl:if test="aoml:pressure/aoml:notes"
          ><xsl:text> (</xsl:text><i>NOTE:</i><xsl:text> </xsl:text><xsl:value-of
          select="aoml:pressure/aoml:notes/xhtml:p[1]"/>)</xsl:if>
      <br/>
    </xsl:if>

    <xsl:value-of select="aoml:notes"/>
  </xsl:template>

  <!-- The following template formats the sky conditions summary. -->
  <xsl:template match="aoml:skyconditions">
    <xsl:if test="aoml:rating">
      <b>rating = <xsl:value-of select="aoml:rating"/></b>
      <br/>
    </xsl:if>
    <xsl:value-of select="aoml:notes"/>
  </xsl:template>

</xsl:stylesheet>
