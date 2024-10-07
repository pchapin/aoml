<?xml version="1.0"?>

<!--
     FILE        : events.xsl
     LAST REVISED: 2020-11-19
     AUTHOR      : Peter Chapin

This file contains a stylesheet suitable for converting aoml into HTML. 

TO DO:

+ (placeholder)

-->

<xsl:stylesheet version="1.0" xmlns:aoml="https://www.pchapin.org/XML/AOML"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">

  <!-- Serialize final results as HTML (not XML). -->
  <xsl:output method="html"/>

  <!-- This top level template defines the general layout of the document. -->
  <xsl:template match="aoml:eventlist">
    <html>
      <head>
        <title>
          <xsl:value-of select="aoml:title"/>
        </title>
        <link rel="stylesheet" href="default.css" type="text/css"/>
      </head>
      <body>
        <h1>
          <xsl:value-of select="aoml:title"/>
        </h1>

        <p>The markup used here distinguishes between events of particular interest to novices,
          intermediate observers, and advanced observers. In the context of an event individual
          notes are also associated, in some cases, with an experience level. For example, an
          event that might be of interest to all may have some notes that would only be relevant
          to an advanced observer. These classifications have been made informally by me. This
          feature is experimental and subject to change or removal based on my experience with
          it.</p>

        <p style="text-align: center">Key: <span class="novice"
            >Novice</span><xsl:text> </xsl:text><span class="intermediate"
            >Intermediate</span><xsl:text> </xsl:text><span class="advanced"
          >Advanced</span><xsl:text> </xsl:text>All/Default/Informational</p>

        <hr/>
        <xsl:if test="aoml:event[@type='moon']">
          <h2>Moon Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='moon']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='planet']">
          <h2>Planet Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='planet']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='sun']">
          <h2>Sun Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='sun']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='meteor']">
          <h2>Meteor Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='meteor']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='planet/minor']">
          <h2>Minor Planet Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='planet/minor']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='comet']">
          <h2>Comet Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='comet']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='star/variable']">
          <h2>Variable Star Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='star/variable']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='deepsky']">
          <h2>Deepsky Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='deepsky']"/>
          </table>
        </xsl:if>
        <xsl:if test="aoml:event[@type='misc']">
          <h2>Other Events</h2>
          <table border="1">
            <tr>
              <th>Summary</th>
              <th>Date</th>
              <th>Time</th>
              <th>Notes</th>
            </tr>
            <xsl:apply-templates select="aoml:event[@type='misc']"/>
          </table>
        </xsl:if>

        <h2>References</h2>
        <ol>
          <xsl:for-each select="aoml:reference">
            <li>
              <xsl:value-of select="."/>
            </li>
          </xsl:for-each>
        </ol>
      </body>
    </html>
  </xsl:template>

  <!-- Here I attempt to define a consistent style for all event types. -->
  <xsl:template match="aoml:event">
    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="@level"/>
      </xsl:attribute>
      <td>
        <xsl:value-of select="aoml:summary"/>
      </td>
      <td>
        <xsl:value-of select="aoml:datetime/aoml:date"/>
      </td>
      <xsl:choose>
        <xsl:when test="count(aoml:datetime/aoml:time) = 1">
          <td align="right">
            <xsl:value-of select="aoml:datetime/aoml:time"/> (<xsl:value-of
              select="aoml:datetime/@timezone"/>)</td>
        </xsl:when>
        <xsl:when test="count(aoml:datetime/aoml:time) = 0">
          <td>
            <xsl:text> </xsl:text>
          </td>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="count(aoml:notes) > 0">
        <td>
          <ol>
            <xsl:apply-templates select="aoml:notes"/>
          </ol>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>

  <!-- To keep the template above manageable, I break out the notes. -->
  <xsl:template match="aoml:notes">
    <xsl:for-each select=".">
      <li>
        <xsl:attribute name="class">
          <xsl:value-of select="@level"/>
        </xsl:attribute>
        <xsl:copy-of select="."/>
      </li>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
