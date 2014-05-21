<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 
    <xsl:output method="xml" indent="yes"/>
 
    <xsl:template match="/">
      <all>
	<xsl:apply-templates select="rss/channel/item"/>
      </all>
    </xsl:template>
    
    <xsl:template match="item">
      <msg>
	<date><xsl:value-of select="pubDate"/></date>
	<title><xsl:value-of select="title"/></title>
	<body>
	  <xsl:value-of select="description" disable-output-escaping="yes"/>
	  <xsl:variable name="guid" select="guid"/>
	  <p><a href="{$guid}">Исходная новость</a></p>
	</body>
      </msg>
    </xsl:template>
    
</xsl:stylesheet>
