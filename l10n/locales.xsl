<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="SongbirdInstallBundle">
    <xsl:for-each select="XPI">
      <xsl:text>mkdir </xsl:text>
      <xsl:value-of select="@languageTag"/>
      <xsl:text>&#xA;</xsl:text>
      <xsl:text>cd </xsl:text>
      <xsl:value-of select="@languageTag"/>
      <xsl:text>&#xA;</xsl:text>
      <xsl:text>wget </xsl:text>
      <xsl:value-of select="@url"/>
      <xsl:text>&#xA;</xsl:text>
      <xsl:text>cd .. </xsl:text>
      <xsl:if test="not(position() = last())">
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
