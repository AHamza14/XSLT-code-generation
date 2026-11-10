<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:uFN="uFN" version="2.0">
	
	<xsl:import href="utilFunctions.xsl"></xsl:import>
	<xsl:output method="text" encoding="UTF-8" indent="yes"/>

<xsl:template match="Project/Models/Package/ModelChildren/Class">
       <xsl:variable name="contextName" select="@Name"/>
	   <xsl:variable name="iDClass" select="@Id"/>
	   <xsl:result-document href="{$projectName}/Classes/{$contextName}.cs">
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using <xsl:value-of select="$projectName"/>.SharedKernel;

namespace <xsl:value-of select="$projectName"/>.Classes
{

public class <xsl:value-of select="$contextName"/>
	{
	<!-- Attribute -->
	<xsl:for-each select=".//Attribute">
	    <xsl:variable name="attributeType">
		        <xsl:value-of select="concat(concat(.//DataType/@Name, ./@Type), ./@TypeModifier)"/>
		</xsl:variable>
		<xsl:text>&#x9;</xsl:text>public <xsl:value-of select="$attributeType"/> <xsl:text>&#x20;</xsl:text> <xsl:value-of select="uFN:first-upper(./@Name)"/> { get; set;}
	</xsl:for-each>

	<!-- Association -->
	<xsl:for-each select="/.//Association[ToEnd/AssociationEnd/@EndModelElement=$iDClass and (FromEnd/AssociationEnd/@Multiplicity='1' or FromEnd/AssociationEnd/@Multiplicity='Unspecified' or FromEnd/AssociationEnd/@Multiplicity='0..1')]">
		<xsl:variable name="fromEndClass" select="uFN:typeUMLElement(FromEnd/AssociationEnd/@EndModelElement)"/>
		<xsl:if test= "ToEnd/AssociationEnd/Stereotypes/Stereotype[@Name ='FK']"><xsl:text>&#x9;</xsl:text>public int<xsl:if test= "FromEnd/AssociationEnd/@Multiplicity='0..1'">?</xsl:if><xsl:text>&#x20;</xsl:text><xsl:value-of select="$fromEndClass/@Name"/>Id { get; set;}</xsl:if>
		<xsl:if test= "$root/Project/Models/Package/ModelChildren/Class[@Name = $fromEndClass/@Name]/Stereotypes/Stereotype[@Name ='NotMapped']">[NotMappedAttribute]</xsl:if>
		public <xsl:value-of select="$fromEndClass/@Name"/><xsl:if test= "FromEnd/AssociationEnd/@Multiplicity='0..1'">?</xsl:if><xsl:text>&#x20;</xsl:text><xsl:value-of select="$fromEndClass/@Name"/> { get; set;}
	</xsl:for-each>

	<!-- Constructeurs -->
		public <xsl:value-of select="$contextName"/>()
		{
		}
		
	<!-- Operations -->
	<!-- <xsl:for-each select=".//Operation[@Name!='créer']">
	    <xsl:value-of select="uFN:operationDefinition(.)"/>
	</xsl:for-each>
  -->
	}
}	
       </xsl:result-document>
</xsl:template>
</xsl:stylesheet>

