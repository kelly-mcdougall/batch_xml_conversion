<?xml version="1.0"?> 
<!-- proofnlm.xsl uses styles definde in proofnlm.css -->
<!-- Beta release: 7-15-2003 -->
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	extension-element-prefixes="xlink">

<xsl:output  
		method="html"
		omit-xml-declaration="yes"
		indent="no"
		encoding="UTF-8"/>

<xsl:strip-space elements="*"/>

<xsl:template match="article">
	<html>
		<head>
			<title>
				<xsl:value-of select="front/journal-meta/journal-id[@journal-id-type='pubmed']"/>
				<xsl:text>: Vol. </xsl:text>
				<xsl:value-of select="front/article-meta/volume"/>
				<xsl:text> Issue </xsl:text>
				<xsl:value-of select="front/article-meta/issue"/>
				<xsl:text>: pp. </xsl:text>
				<xsl:value-of select="front/article-meta/fpage"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="front/article-meta/lpage"/>
			</title>
			<link rel="stylesheet" type="text/css" href="ucpress.css"/>
		</head>

		<body bgcolor="#f8f8f8">
		
		<!-- this table contains all of the article except the tables and figs -->
		<table width="800"> 
			<tr>
				<td width="50">&#160;</td> <!-- left margin -->
				<td>
					<table>
						<tr>
							<!-- this cell includes journal information -->
							<td align="left" valign="top" width="40%">
								<xsl:for-each select="front/journal-meta/journal-id[@journal-id-type!='']">
									<span class="journal_info">
<xsl:text>Journal ID for </xsl:text><xsl:value-of select="@journal-id-type"/><xsl:text>: </xsl:text><xsl:value-of select="."/></span><br/>
									</xsl:for-each>
								<xsl:for-each select="front//abbrev-journal-title">
									<span class="journal_info"><xsl:text>Journal Abbreviation: </xsl:text><xsl:value-of select="node()"/></span><br/></xsl:for-each>
								<xsl:for-each select="front//issn">
									<span class="journal_info"><xsl:text>ISSN: </xsl:text><xsl:value-of select="node()"/></span><br/></xsl:for-each>
								<xsl:if test="front/journal-meta/publisher/publisher-name!=''">
									<span class="publisher"><xsl:text>Publisher: </xsl:text><xsl:apply-templates select="front/journal-meta/publisher/publisher-name"/>
										<xsl:if test="front/journal-meta/publisher/publisher-loc">
											<xsl:text>, </xsl:text>
											<xsl:apply-templates select="front/journal-meta/publisher/publisher-loc"/>
											</xsl:if></span>
									</xsl:if>
							</td>
							<td align="right" valign="top">
								<xsl:for-each select="front/journal-meta/notes//text()">
									<p><xsl:value-of select="."/></p>
								</xsl:for-each>
							</td>
						</tr>
						<tr>
							<!-- rule separates journal info from article info -->
							<td colspan="2">
								<center><hr width="400"/></center>
							</td>
						</tr>
						<tr>
							<!-- this cell display hierarchical subjects -->
							<td align="left" valign="top">
								<xsl:apply-templates select="front/article-meta/article-categories"/><br/>
							</td>
							<!-- this cell includes copyright info -->
							<td align="right" valign="top">
								<xsl:choose>
									<xsl:when test="front/article-meta/copyright-statement">
										<span class="cpyrt"><xsl:apply-templates select="front/article-meta/copyright-statement"/></span>
										</xsl:when>
									<xsl:otherwise>
										<xsl:if test="front/article-meta/copyright-year">
											<span class="cpyrt"><xsl:apply-templates select="front/article-meta/copyright-year"/></span>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
							</td>
						</tr>
				
						<tr>
							<td colspan="2">
								<!-- write article title -->
								<xsl:apply-templates select="front/article-meta/title-group"/>		
								
								<!-- process article authors and editors -->	
								<xsl:for-each select="front/article-meta/contrib-group">
									<xsl:choose>
										<xsl:when test="contrib[@contrib-type='editor']">
											<p>
												<table>
													<tr>
														<td valign="top"><b>Editor Group:</b></td>
														<td><xsl:apply-templates select="contrib"/></td>
													</tr>
												</table>
											</p>
											</xsl:when>
										<xsl:otherwise>
											<p>
												<table>
													<tr>
														<td valign="top"><b>Author Group:</b></td>
														<td><xsl:apply-templates select="contrib"/></td>
													</tr>
												</table>
											</p>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>	
								
								<!-- process affiliations -->
								<xsl:apply-templates select="front/article-meta/aff" mode="fm"/>

                 				<center><hr color="red" width="72%"/></center>
								
								<!-- article-level linking information -->
								<p>
									<xsl:for-each select="front/article-meta/ext-link">
										<b><xsl:text>Link: </xsl:text></b><xsl:value-of select="@xlink:href"/><br/>
										</xsl:for-each>
								</p>
								
								<!-- author footnotes -->
								<xsl:apply-templates select="front/article-meta/author-notes"/>
								
								<!-- all date information goes in this table -->
								<p>
									<table border="1">
										<tr>
											<th>Publication Dates</th>
											<th>History Dates</th>
										</tr>
										<tr>
											<td valign="top"><p><xsl:apply-templates select="front/article-meta/pub-date"/></p></td>
				    						<td valign="top"><p><xsl:apply-templates select="front/article-meta/history/date"/></p></td>
										</tr>
									</table>
								</p>
								
								<!-- more issue/article info -->
								<xsl:apply-templates select="front/article-meta/volume | front/article-meta/issue | front/article-meta/elocation-id | front/article-meta/fpage | front/article-meta/lpage"/>
								<xsl:apply-templates select="front/article-meta/article-id"/>
								<xsl:apply-templates select="front/article-meta/related-article | front/article-meta/abstract | front/article-meta/trans-abstract | front/article-meta/kwd-group "/>


<!--stopped review -->
			<xsl:if test="front/article-meta/contract-num | front/article-meta/contract-sponsor">
				<p class="contract"><b><xsl:text>Contract Info:</xsl:text></b><br/>
					<xsl:apply-templates select="front/article-meta/contract-num"/><br/>
					<xsl:apply-templates select="front/article-meta/contract-sponsor "/></p>
				</xsl:if>


			<xsl:if test="front/article-meta/supplementary-material">
				<p><b><xsl:text>Supplementary Material:</xsl:text></b><br/>
					<xsl:apply-templates select="front/article-meta/supplementary-material"/></p>
				</xsl:if>

			<xsl:if test="front/article-meta/conference">
				<p><b><xsl:text>Conference:</xsl:text></b><br/>
					<xsl:apply-templates select="front/article-meta/conference"/></p>
				</xsl:if>



			<xsl:if test="front/article-meta/self-uri">
				<p><b><xsl:text>Self URI: </xsl:text></b><xsl:apply-templates select="front/article-meta/self-uri"/></p>
				</xsl:if>
			<p><xsl:apply-templates select="front/article-meta/product"/></p>
			<p><center><hr width="400"/></center></p>
			<xsl:apply-templates select="body"/>
			<center><hr width="400"/></center>
			<xsl:apply-templates select="back"/> 
			</td></tr></table></td></tr></table>
<!--			<table>
			<tr><td>
			<xsl:apply-templates select="//fig | //table-wrap"/>
			</td></tr></table>-->
			
			
		</body>
	</html>		
</xsl:template>	

<!-- Article Grouping -->
<xsl:template match="article-categories">
	<xsl:apply-templates select="subj-group" mode="l1"/><br/>
	<p><xsl:apply-templates select="series-title"/><br/>
	<xsl:apply-templates select="series-text"/></p>
	</xsl:template>
		 
<xsl:template match="subj-group" mode="l1">
	<xsl:apply-templates mode="l2"/>
	</xsl:template>
	
<xsl:template match="subj-group" mode="l2">
	<br/>&#160;&#160;<xsl:apply-templates mode="l3"/>
	</xsl:template>
		 
<xsl:template match="subj-group" mode="l3">
	<br/>&#160;&#160;&#160;&#160;<xsl:apply-templates mode="l3"/>
	</xsl:template>

<xsl:template match="subject" mode="l2">
	<span class="subject_l2"><xsl:apply-templates/></span>
	</xsl:template>

<xsl:template match="subject" mode="l3">
	<span class="subject_l3"><xsl:apply-templates/></span>
	</xsl:template>
		 
<xsl:template match="series-title">
	<b>Series Title: </b><xsl:value-of select="."/>
	</xsl:template>
<!-- END Article Grouping -->
		 
		 
<!-- Process Title Group -->		 
	<xsl:template match="title-group">
		<center>
			<h1>
				<xsl:apply-templates select="*[not(self::trans-title) and not(self::alt-title) and not(self::fn-group)]|text()"/>
			</h1>
		</center>
		<xsl:apply-templates select="trans-title | alt-title"/>
		</xsl:template>

       <xsl:template match="subtitle">
			<xsl:text>: </xsl:text><xsl:apply-templates/>
       </xsl:template>

       <xsl:template match="trans-title">
			<br/><b><xsl:text>[Translated title: </xsl:text></b><xsl:apply-templates/><b><xsl:text>]</xsl:text></b>
       </xsl:template>

       <xsl:template match="alt-title">
			<br/><b><xsl:text>[Alternate title: </xsl:text></b><xsl:apply-templates/><b><xsl:text>]</xsl:text></b>
       </xsl:template>



<!-- END Process Title Group -->		 



      <xsl:template match="//xref[@ref-type='fn']">
             <sup><xsl:value-of select="@rid"/></sup>
       </xsl:template>


	<xsl:template match="contrib">
		<xsl:apply-templates select="name | collab" mode="contrib"/>
		<xsl:apply-templates select="address | aff | author-comment | bio | email | ext-link | role" mode="article-meta"/>
		<hr/><p/>
		</xsl:template>


	<xsl:template match="name" mode="contrib">
		<xsl:apply-templates select="prefix" mode="contrib"/>
		<xsl:apply-templates select="given-names" mode="contrib"/>
		<xsl:apply-templates select="surname" mode="contrib"/>
		<xsl:apply-templates select="suffix" mode="contrib"/>
		<xsl:apply-templates select="../xref" mode="article-meta"/>
		<xsl:apply-templates select="../degrees"/>
		<!--<xsl:apply-templates select="insr"/><xsl:apply-templates select="anr"/>--> 
        </xsl:template>

	<xsl:template match="pref | given-names" mode="contrib">
		<xsl:apply-templates/><xsl:text> </xsl:text>
		</xsl:template>

	<xsl:template match="surname" mode="contrib">
		<xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="suffix" mode="contrib">
		<xsl:text>, </xsl:text><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="collab" mode="contrib">
		<xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="degrees">
		<br/>&#160;&#160;&#160;<b><xsl:text>Degrees: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="address" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Address: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="aff" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Affiliation: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="author-comment" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Au comment: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="bio" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Bio: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="email" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Email: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="ext-link" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Link: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="role" mode="article-meta">
		<br/>&#160;&#160;&#160;<b><xsl:text>Role: </xsl:text></b><xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="xref[@ref-type='author-notes']" mode="article-meta">
		<sup><span class="xaunotes"><xsl:apply-templates/></span></sup>
		</xsl:template>

	<xsl:template match="xref[@ref-type='aff']" mode="article-meta">
		<sup><span class="xaff"><a><xsl:attribute name="href">#<xsl:value-of select="@rid"/></xsl:attribute><xsl:apply-templates/></a></span></sup>
		</xsl:template>

	<xsl:template match="xref[@ref-type='fn']">
		<xsl:choose>
			<xsl:when test="@symbol">
				<sup><xsl:value-of select="@symbol"/></sup>
				</xsl:when>
			<xsl:otherwise>
				<sup><xsl:apply-templates/></sup>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

	<xsl:template match="xref[@ref-type='bibr']">

	<xsl:variable name="xrefid" select='substring(@rid,2)'/>
	<xsl:variable name="xrefvalue" select="."/>

<!--	<xsl:if test="$xrefid != $xrefvalue">	
	<span class="xbibr"><sup><a><xsl:attribute name="href">#<xsl:value-of select="@rid"/></xsl:attribute><xsl:apply-templates/></a></sup><font color="red"><sup>&#x0002A;&#x0002A;&#x0002A;&#x0002A;</sup></font></span>
	</xsl:if>-->
	<span class="xbibr"><sup><font color="red"><a><xsl:attribute name="href">#<xsl:value-of select="@rid"/></xsl:attribute><xsl:apply-templates/></a></font></sup></span>
	</xsl:template>



	<xsl:template match="xref[@ref-type='fig']">
		<span class="xfig"><a><xsl:attribute name="href">#<xsl:value-of select="@rid"/></xsl:attribute><xsl:apply-templates/></a></span>
		</xsl:template>

	<xsl:template match="xref[@ref-type='table']">
		<span class="xtable"><a><xsl:attribute name="href">#<xsl:value-of select="@rid"/></xsl:attribute><xsl:apply-templates/></a></span>
		</xsl:template>

	<xsl:template match="aff" mode="fm">
<a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>								<div class="fmaff"><xsl:apply-templates/></div>
		</xsl:template>

	<xsl:template match="author-notes">
		<span class="authnotes"><xsl:apply-templates select="fn" mode="author-notes"/></span>
<span class="authnotes"><i><xsl:apply-templates select="corresp"/></i></span>
		</xsl:template>

	<xsl:template match="fn" mode="author-notes">
		<xsl:choose>
			<xsl:when test="@fn-type='com'">
				<p><b><xsl:text>Communicated by footnote: </xsl:text></b><xsl:apply-templates/></p>
				</xsl:when>
			<xsl:when test="@fn-type='con'">
				<p><i><xsl:apply-templates/></i></p>
				</xsl:when>
			<xsl:when test="@fn-type='cor'">
				<p><b><xsl:text>Correspondence footnote: </xsl:text></b><xsl:apply-templates/></p>
				</xsl:when>
			<xsl:otherwise>
				<p><sup><font color="blue"><xsl:value-of select="@symbol"/></font></sup><xsl:apply-templates/></p>
				</xsl:otherwise>
			</xsl:choose>
       </xsl:template>

	<xsl:template match="pub-date">
		<table>
		<tr>
			<td valign="top"><b><xsl:value-of select="@pub-type"/><xsl:text> date: </xsl:text></b></td><td valign="top"><xsl:apply-templates/></td></tr></table>
		</xsl:template>

	<xsl:template match="day">
		<b><xsl:text> Day: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="month">
		<b><xsl:text> Month: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="year">
		<b><xsl:text> Year: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="season">
		<b><xsl:text> Season: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="stringdate">
		<b><xsl:text> Stringdate: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="history/date">
		<table><tr><td valign="top">
			<b><xsl:value-of select="@date-type"/><xsl:text> date: </xsl:text></b></td><td valign="top"><xsl:apply-templates/></td></tr></table>
		</xsl:template>

	<xsl:template match="volume">
		<b><xsl:text>Volume: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="issue">
		<b><xsl:text>Issue: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>
	
	<xsl:template match="article-id">
		<xsl:choose>
			<xsl:when test="@pub-id-type='coden'">
				<b><xsl:text>Coden: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='doi'">
				<b><xsl:text>DOI: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='medline'">
				<b><xsl:text>Medline Id: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='pii'">
				<b><xsl:text>PubIDItem: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='pmid'">
				<b><xsl:text>PubMed Id: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='publisher-id'">
				<b><xsl:text>Publisher Id: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='sici'">
				<b><xsl:text>SICI: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			<xsl:when test="@pub-id-type='other'">
				<b><xsl:text>Article Id: </xsl:text></b><xsl:apply-templates/><br/>
				</xsl:when>
			</xsl:choose>
		</xsl:template>
	
	<xsl:template match="issn">
		<b><xsl:text>ISSN: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="elocation-id">
		<b><xsl:text>E-location ID: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="fpage">
		<b><xsl:text>First Page: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="lpage">
		<b><xsl:text>Last Page: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>


	<xsl:template match="epage">
		<b><xsl:text>Electronic Page: </xsl:text></b><xsl:apply-templates/><br/>
		</xsl:template>
		
		
	<xsl:template match="/article/front/article-meta/product">
		<b><xsl:text>Product Info:</xsl:text></b><br/>
			<xsl:apply-templates/>
		</xsl:template>


	<xsl:template match="related-article">
		<br/><span class="related_article"><xsl:apply-templates/></span>
		</xsl:template>

	<xsl:template match="abstract">
		<p><table border="1"><tr><td>
		<xsl:choose>
			<xsl:when test="@abstract-type">
				<h3 class="abs_head"><xsl:value-of select="@abstract-type"/><xsl:text> Abstract</xsl:text></h3><p class="abs_text"><xsl:apply-templates/></p>
				</xsl:when>
			<xsl:otherwise>
				<h3 class="abs_head"><xsl:text>Abstract</xsl:text></h3><p class="abs_text"><xsl:apply-templates/></p>
				</xsl:otherwise>
			</xsl:choose>
			</td></tr></table></p>
		</xsl:template>

	<xsl:template match="trans-abstract">
		<p><table border="1"><tr><td>
		<xsl:choose>
			<xsl:when test="@abstract-type">
				<h3 class="abs_head"><xsl:value-of select="@abstract-type"/><xsl:text> translated abstract</xsl:text></h3><p class="abs_text"><xsl:apply-templates/></p>
				</xsl:when>
			<xsl:otherwise>
				<h3 class="abs_head"><xsl:text>Translated abstract</xsl:text></h3><p class="abs_text"><xsl:apply-templates/></p>
				</xsl:otherwise>
			</xsl:choose>
			</td></tr></table></p>
		</xsl:template>

	<xsl:template match="bold">
		<b><xsl:apply-templates/></b>
	</xsl:template>

	<xsl:template match="abstract/p">
		<p><xsl:apply-templates/></p>
		</xsl:template>


	<xsl:template match="kwd-group">
		<b><i><xsl:text>Key Words: </xsl:text></i></b><xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="kwd">
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:text></xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text>, </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
			
		
	</xsl:template>
	

	<xsl:template match="body">
		<xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="body/sec">
		<hr/>
		<xsl:apply-templates/>
	</xsl:template>


<!--		<xsl:apply-templates select="*[not(descendant-or-self::fig) and not(descendant-or-self::table-wrap)]"/>
		</xsl:template>-->


	<xsl:template match="body/sec/title">
	<h2><xsl:apply-templates/></h2>
	</xsl:template>

	<xsl:template match="body/sec/sec">
	<b><xsl:value-of select="body/sec/sec/title"/></b>
		<font color="red"><xsl:value-of select="@sec-type"/></font>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="body/sec/sec/title">
		<h3><xsl:apply-templates/></h3>
		</xsl:template>

	<xsl:template match="body/sec/sec/sec">
		<font color="red"><xsl:value-of select="@sec-type"/></font>
		<xsl:apply-templates/>
	</xsl:template>	

	<xsl:template match="body/sec/sec/sec/title">
		<h4><xsl:apply-templates/></h4>
		</xsl:template>

	<xsl:template match="fig">
		<table border="0">
			<tr>
				<th align="left" colspan="2">
<a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
					<xsl:apply-templates select="label"/>
				</th>
			</tr>
			<tr>
				<td valign="top">
					<xsl:apply-templates select="graphic"/>
				</td>
				<td valign="top">
					<xsl:apply-templates select="caption"/>
				</td>
			</tr>
			<xsl:if test="alt-text">
				<tr>
					<td colspan="2">
						<xsl:text>Alternate Title Text: </xsl:text><xsl:apply-templates select="alt-text"/>
					</td>
				</tr>
				</xsl:if>
		</table>
		</xsl:template>

	<xsl:template match="graphic">
		<p><center>
<!--			<img>
				<xsl:attribute name="src">
					<xsl:text>../figure/</xsl:text><xsl:value-of select="@xlink:href"/><xsl:text>.tif</xsl:text>
					</xsl:attribute>
			</img>-->
			<img>
<xsl:attribute name="src">c:\Jobs\lhi\ucpress\final\ezep112f\output\ezep113c\ajvr\ajvrxml\</xsl:attribute>
			</img>


		</center></p>
		</xsl:template>

	<xsl:template match="body//p">
		<p><xsl:apply-templates/></p>
		</xsl:template>

	<xsl:template match="back">
		<h3><xsl:apply-templates select="//back/title"/></h3>
		<xsl:apply-templates select="//fn-group"/>
		<xsl:apply-templates select="*[not(descendant-or-self::fn-group) and not(self::title) and not(descendant-or-self::fig) and not(descendant-or-self::table-wrap)]|text()"/>
		</xsl:template>

	<xsl:template match="fn-group">
		<h3>Footnotes</h3>
		<xsl:apply-templates/>
		</xsl:template>
	
	<xsl:template match="long-desc">
		<p class="longdesc"><xsl:apply-templates/></p>
		</xsl:template>


	<xsl:template match="ack">
		<xsl:choose>
			<xsl:when test="title">
				<!-- <xsl:apply-templates select="title"/> -->
				<xsl:apply-templates/>
				</xsl:when>
			<xsl:otherwise>
				<h3>Acknowledgments</h3>
				<p><xsl:apply-templates/></p>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

	<xsl:template match="ack/title">
   	<h3><xsl:apply-templates/></h3>
      </xsl:template>

	<xsl:template match="ack/sec">
		<xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="ack/sec/title">
		<h4><xsl:apply-templates/></h4>
		</xsl:template>

	<xsl:template match="ack//p">
		<p><xsl:apply-templates/></p>
		</xsl:template>

	<xsl:template match="glossary">
		<xsl:apply-templates/>
		</xsl:template>

	<xsl:template match="def-list">
		<xsl:apply-templates select="title"/>
		<table cellpadding="2">
			<xsl:if test="term-head|def-head">
				<tr><th><i><xsl:apply-templates select="term-head"/></i>&#160;&#160;&#160;&#160;&#160;</th>
				<th align="left"><i><xsl:apply-templates select="def-head"/></i></th></tr>
				</xsl:if>
		<xsl:apply-templates select="def-item"/>
		</table>
		</xsl:template>

	<xsl:template match="def-list/title">
		<h3><xsl:apply-templates/></h3>
		</xsl:template>

	<xsl:template match="def-item">
		<tr><xsl:apply-templates/></tr>
		</xsl:template>

	<xsl:template match="term">
		<td><b><xsl:apply-templates/></b></td>
		</xsl:template>

	<xsl:template match="def">
		<td><xsl:apply-templates select="p"/></td>
		</xsl:template>

	 
	<xsl:template match="table">
		<table>
			<xsl:if test="@frame">
				<xsl:attribute name="frame">
					<xsl:value-of select="@frame"/>
					</xsl:attribute>
				</xsl:if>
			<xsl:if test="@rules">
				<xsl:attribute name="rules">
					<xsl:value-of select="@rules"/>
					</xsl:attribute>
				</xsl:if>
			<xsl:apply-templates/>
		</table>
		</xsl:template>

	<xsl:template match="thead">
		<thead>
			<xsl:apply-templates/>
		</thead>
	</xsl:template>

	<xsl:template match="row">
		<tr>
			<td><xsl:apply-templates select="entry"/></td>
		</tr>
	</xsl:template>


<!--   Adding Part  -->

<xsl:template match="table">
<a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
<hr/>
<p><b><xsl:apply-templates select="title"/></b></p>
<xsl:if test="@frame='topbot'">
<hr/>
</xsl:if>
<xsl:apply-templates select="tgroup"/>
<hr/>
</xsl:template>


<!-- <xsl:template match="tabular/table">
<b><xsl:value-of select="title"/></b><br/>
<xsl:apply-templates select="tgroup"/>
</xsl:template> -->


<xsl:template match="tgroup">
<font style="font-size:0pt">
<table width="100%" style="font-size:12pt" cellpadding="2" cellspacing="0">
<xsl:if test="../@pgwide=1">
<xsl:attribute name="width">100%
</xsl:attribute>
</xsl:if>
<xsl:choose>
<xsl:when test="../@frame='none'">
<xsl:attribute name="border">0
</xsl:attribute>
</xsl:when>
<xsl:otherwise>
<xsl:if test="../@frame='all'">
<xsl:attribute name="border">1
</xsl:attribute>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<colgroup>
<xsl:call-template name="generate.colgroup">
<xsl:with-param name="cols" select="@cols"/>
</xsl:call-template>
</colgroup>
<xsl:apply-templates/>
<xsl:if test=".//footnote">
<TR><TD colspan="{@cols}">
<xsl:apply-templates select=".//footnote" mode="table.footnote.mode"/></TD></TR>
</xsl:if>
<tr><td><xsl:attribute name="colspan"><xsl:value-of select="@cols"/></xsl:attribute></td></tr>
</table></font>
</xsl:template>

<xsl:template match="colspec">
</xsl:template>

<xsl:template match="spanspec">
</xsl:template>

<xsl:template match="thead|tfoot">
<tr><td><xsl:attribute name="colspan"><xsl:value-of select="../@cols"/></xsl:attribute></td></tr>
<xsl:element name="{name(.)}">
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@char">
<xsl:attribute name="char">
<xsl:value-of select="@char"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@charoff">
<xsl:attribute name="charoff">
<xsl:value-of select="@charoff"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@valign">
<xsl:attribute name="valign">
<xsl:value-of select="@valign"/>
</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="tbody">
<tbody>
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@char">
<xsl:attribute name="char">
<xsl:value-of select="@char"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@charoff">
<xsl:attribute name="charoff">
<xsl:value-of select="@charoff"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@valign">
<xsl:attribute name="valign">
<xsl:value-of select="@valign"/>
</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
</tbody>
</xsl:template>

<xsl:template match="row">
<TR valign="top">
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@char">
<xsl:attribute name="char">
<xsl:value-of select="@char"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@charoff">
<xsl:attribute name="charoff">
<xsl:value-of select="@charoff"/>
</xsl:attribute>
</xsl:if>
<xsl:apply-templates/>
<xsl:if test="@rowsep='1'">
<hr/>
</xsl:if>
</TR>
</xsl:template>

<xsl:template match="thead/row/entry">
<TD><xsl:call-template name="process.cell">
</xsl:call-template></TD>
</xsl:template>

<xsl:template match="tbody/row/entry">
<TD><xsl:call-template name="process.cell">
<xsl:with-param name="cellgi">
</xsl:with-param>
</xsl:call-template></TD>
</xsl:template>

<xsl:template match="tfoot/row/entry">
<xsl:call-template name="process.cell">
<xsl:with-param name="cellgi">
</xsl:with-param>
</xsl:call-template>
</xsl:template>

<xsl:template name="process.cell">
<xsl:variable name="empty.cell" select="count(node()) = 0"/>
<!-- <xsl:variable name="start" select="substring-after(@namest, 'col')"/>
<xsl:variable name="end" select="substring-after(@nameend, 'col')"/> -->
<xsl:attribute name="colspan"><xsl:value-of select="string(@nameend - @namest+1)"/></xsl:attribute>
<xsl:if test="@morerows">
<xsl:attribute name="rowspan">
<xsl:value-of select="@morerows+1"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@char">
<xsl:attribute name="char">
<xsl:value-of select="@char"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@charoff">
<xsl:attribute name="charoff">
<xsl:value-of select="@charoff"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@valign">
<xsl:attribute name="valign">
<xsl:value-of select="@valign"/>
</xsl:attribute>
</xsl:if>
<xsl:choose>
<xsl:when test="$empty.cell">
<xsl:text>&#160;
</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates/>
<xsl:if test="@rowsep">
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="generate.colgroup">
<xsl:param name="cols" select="1"/>
<xsl:param name="count" select="1"/>
<xsl:choose>
<xsl:when test="$count>$cols">
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="generate.col">
<xsl:with-param name="countcol" select="$count"/>
</xsl:call-template>
<xsl:call-template name="generate.colgroup">
<xsl:with-param name="cols" select="$cols"/>
<xsl:with-param name="count" select="$count+1"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="generate.col">
<xsl:param name="countcol">1
</xsl:param>
<xsl:param name="colspecs" select="./colspec"/>
<xsl:param name="count">1
</xsl:param>
<xsl:param name="colnum">1
</xsl:param>
<xsl:choose>
<xsl:when test="$count>count($colspecs)">
<col/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
<xsl:variable name="colspec.colnum">
<xsl:choose>
<xsl:when test="$colspec/@colnum">
<xsl:value-of select="$colspec/@colnum"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$colnum"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$colspec.colnum=$countcol">
<col>
<xsl:if test="$colspec/@align">
<xsl:attribute name="align">
<xsl:value-of select="$colspec/@align"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="$colspec/@char">
<xsl:attribute name="char">
<xsl:value-of select="$colspec/@char"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="$colspec/@charoff">
<xsl:attribute name="charoff">
<xsl:value-of select="$colspec/@charoff"/>
</xsl:attribute>
</xsl:if>
</col>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="generate.col">
<xsl:with-param name="countcol" select="$countcol"/>
<xsl:with-param name="colspecs" select="$colspecs"/>
<xsl:with-param name="count" select="$count+1"/>
<xsl:with-param name="colnum">
<xsl:choose>
<xsl:when test="$colspec/@colnum">
<xsl:value-of select="$colspec/@colnum + 1"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$colnum + 1"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="colspec.colnum">
<xsl:param name="colname">
</xsl:param>
<xsl:param name="colspecs" select="../../../../tgroup/colspec"/>
<xsl:param name="count">1
</xsl:param>
<xsl:param name="colnum">1
</xsl:param>
<xsl:choose>
<xsl:when test="$count>count($colspecs)">
</xsl:when>
<xsl:otherwise>
<xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
<xsl:value-of select="$count"/>:
<xsl:value-of select="$colspec/@colname"/>=
<xsl:value-of select="$colnum"/>
<xsl:choose>
<xsl:when test="$colspec/@colname=$colname">
<xsl:choose>
<xsl:when test="$colspec/@colnum">
<xsl:value-of select="$colspec/@colnum"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$colnum"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="colspec.colnum">
<xsl:with-param name="colname" select="$colname"/>
<xsl:with-param name="colspecs" select="$colspecs"/>
<xsl:with-param name="count" select="$count+1"/>
<xsl:with-param name="colnum">
<xsl:choose>
<xsl:when test="$colspec/@colnum">
<xsl:value-of select="$colspec/@colnum + 1"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$colnum + 1"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="colspec.colwidth">
<xsl:param name="colname">
</xsl:param>
<xsl:param name="colspecs" select="../../../../tgroup/colspec"/>
<xsl:param name="count">1
</xsl:param>
<xsl:choose>
<xsl:when test="$count>count($colspecs)">
</xsl:when>
<xsl:otherwise>
<xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
<xsl:choose>
<xsl:when test="$colspec/@colname=$colname">
<xsl:value-of select="$colspec/@colwidth"/>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="colspec.colwidth">
<xsl:with-param name="colname" select="$colname"/>
<xsl:with-param name="colspecs" select="$colspecs"/>
<xsl:with-param name="count" select="$count+1"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- <xsl:template match="tgroup">
<xsl:apply-templates select="tbody|thead"/>
<tr><td><xsl:attribute name="colspan"><xsl:value-of select="@cols"/></xsl:attribute><hr/></td></tr>
</xsl:template>

<xsl:template match="thead|tbody">
<tr><td><xsl:attribute name="colspan"><xsl:value-of select="../@cols"/></xsl:attribute><hr/></td></tr>
<xsl:apply-templates select="row"/>
</xsl:template>

<xsl:template match="row">
<tr valign="top">
<xsl:apply-templates select="entry"/></tr>
</xsl:template>

<xsl:template match="entry">
<td>
<xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
<xsl:attribute name="colname"><xsl:value-of select="@colname"/></xsl:attribute>
<xsl:apply-templates/></td>
</xsl:template> -->

<!--   End Adding Part  -->


	
	<xsl:template match="array">
		<hr width="40%" align="left" noshade="1"/>
		<table>
			<xsl:apply-templates/>
		</table>
		<hr width="40%" align="left" noshade="1"/>
	</xsl:template>

	<xsl:template match="tr">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="th">
		<th>
			<xsl:if test="@colspan">
				<xsl:attribute name="colspan">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			 </xsl:if>
			<xsl:apply-templates/>
		</th>
	</xsl:template>

	<xsl:template match="td">
		<td>
			<xsl:if test="@colspan">
				<xsl:attribute name="colspan">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>
		
	<xsl:template match="tfoot">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="ext-link">
		<span class="extlink"><font color="#000099">
		<xsl:apply-templates/>
		<xsl:text> [Link type: </xsl:text>
		<xsl:value-of select="@ext-link-type"/>
		<xsl:text>, href: </xsl:text>
		<xsl:value-of select="@xlink:href"/>
		<xsl:text>]</xsl:text>
		</font></span>
	</xsl:template>


	<xsl:template match="speech">
		<p><table><tr>
			<td align="left" valign="top"><span class="speaker"><xsl:apply-templates select="speaker"/></span></td>
			<td align="left" valign="top"><xsl:apply-templates select="p"/></td>
		</tr></table></p>
		</xsl:template>

	<xsl:template match="statement">
		<div  class="statement"><p><b><xsl:apply-templates select="label"/></b></p>
		<xsl:apply-templates select="p"/></div>
		</xsl:template>

	<xsl:template match="verse-group">
		<p><blockquote>
		<xsl:apply-templates/>
		</blockquote></p>
		</xsl:template>

	<xsl:template match="verse-line">
		<xsl:apply-templates/><br/>
		</xsl:template>

	<xsl:template match="verse-group/attrib">
		&#160;&#160;&#160;&#160;&#160;<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template match="app-group/title">
		<h3><xsl:apply-templates/></h3>
	</xsl:template>
		

	<xsl:template match="bio">
		<p class="bio">
		<xsl:apply-templates/>
		</p>
	</xsl:template>
	
	
	<xsl:template match="app|glossary">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="app/title|glossary/title">
		<h3><xsl:apply-templates/></h3>
	</xsl:template>
				
	<xsl:template match="app/sec">
		<xsl:apply-templates/>
	</xsl:template>
		
	<xsl:template match="app/sec/title|gloss-group/title">
		<h4><xsl:apply-templates/></h4>
	</xsl:template>
		
	<xsl:template match="gloss-group">
		<blockquote><xsl:apply-templates/></blockquote>
	</xsl:template>
	
	<xsl:template match="notes">
		<div class="notes"><br/><br/>
		<xsl:apply-templates/>
		</div>
	</xsl:template>
		
	<xsl:template match="notes//p">
		<p><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="notes//sec//title">
		<b><xsl:apply-templates/></b>
	</xsl:template>

<!-- COPY TEMPLATE  for elements that are just copied -->

	<xsl:template match="hr">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="*|text()|processing-instruction()"/>
			</xsl:copy>
		</xsl:template>	

<!--	<xsl:template match="fn">
		<p>
		<xsl:if test="@label">
			<sup><xsl:value-of select="@label"/></sup>
		</xsl:if>
		<xsl:if test="@id">
			<xsl:value-of select="@id"/>
		</xsl:if>
		<xsl:apply-templates/>
		</p>
     </xsl:template>  -->

	 <xsl:template match="fn">
	<p><xsl:apply-templates/></p>
    </xsl:template>


	<xsl:template match="label">
	<sup><xsl:apply-templates/></sup>
    </xsl:template>


	<xsl:template match="//boxed-text">
		<table border="4" width="600">
		<tr><td><xsl:apply-templates/></td></tr>
		</table>
	</xsl:template>


	<xsl:template match="boxed-text//title">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>


	<xsl:template match="list">
		<xsl:choose>
			<xsl:when test="@list-type='bullet'">
				<ul>
					<xsl:apply-templates/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<ol>
					<xsl:apply-templates/>
				</ol>
			</xsl:otherwise>
		</xsl:choose> 
	</xsl:template>

	<xsl:template match="list-item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="//math">
		<table border="1">
			<tr><td><xsl:value-of select="."/></td></tr>
		</table>
	</xsl:template>

	<xsl:template match="//tex-math">
		<table border="1">
			<tr><td><xsl:value-of select="."/></td></tr>
		</table>
	</xsl:template>

	<xsl:template match="disp-quote">
		<ol><xsl:apply-templates/></ol>
	</xsl:template>

	<xsl:template match="sup">
		<sup><xsl:apply-templates/></sup>
	</xsl:template>

	<xsl:template match="sub">
		<sub><xsl:apply-templates/></sub>
	</xsl:template>

	<xsl:template match="italic">
		<i><xsl:apply-templates/></i>
	</xsl:template>

	<xsl:template match="sc">
		<span class="sc"><xsl:apply-templates/></span>
<!-- 		<font size="-1">
			<xsl:call-template name="capitalize">
				<xsl:with-param name="str" select="."/>
				</xsl:call-template>        
		</font> -->
	</xsl:template>

	<xsl:template match="preformat">
		<pre>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>


<!--
        Capitalize a string
-->

  <xsl:template name="capitalize">
     <xsl:param name="str"/>
     <xsl:value-of select="translate($str, 
             'abcdefghjiklmnopqrstuvwxyz',
        'ABCDEFGHJIKLMNOPQRSTUVWXYZ')"/>
  </xsl:template>        
  
 
<!-- ============ NLM CITATION MODEL =============== -->
	<xsl:template match="ref-list">
		<xsl:choose>
			<xsl:when test="title">
				<h3><xsl:apply-templates select="title"/></h3>
			</xsl:when>
			<xsl:otherwise>	  	
            <h3>References</h3>
			</xsl:otherwise>
		</xsl:choose>

		<table>
			<xsl:for-each select="ref">
				<tr>
					<td valign="top">
					<a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
					<xsl:variable name="refid" select='substring(@id,4)'/> 
					<xsl:variable name="labelid" select="label"/> 

					<xsl:if test="substring(@id,4) != position()">
						<font color="green"><xsl:value-of select="position()"/></font>
						<font color="red"><xsl:value-of select="substring(@id,4)"/></font>
					</xsl:if>

					<xsl:if test="$labelid != position()">
						<font color="red"><xsl:value-of select="position()"/></font>
						<xsl:value-of select="$labelid"/>
						</xsl:if>
	
					</td>
						<td valign="top">
							<table width="700" border="1">
								<tr>	
					<xsl:apply-templates select="*[not(self::title)]|text()" mode="nscitation"/>
								</tr>
							</table>
						</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="label" mode="nscitation">
		<b><xsl:apply-templates/></b><xsl:text> </xsl:text>
	</xsl:template>


	<xsl:template match="article-title" mode="nscitation">
		<xsl:text> </xsl:text><xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="name" mode="nscitation">
		<xsl:value-of select="surname"/><xsl:text>, </xsl:text>
		<xsl:value-of select="given-names"/>
	</xsl:template>
	  
	<xsl:template match="source" mode="nscitation">
		<i><xsl:text> </xsl:text><xsl:apply-templates/></i>
	</xsl:template>
	  
	<xsl:template match="year" mode="nscitation">
		<xsl:text> </xsl:text><xsl:apply-templates/>
	</xsl:template>
	  
	<xsl:template match="volume" mode="nscitation">
		<xsl:text> </xsl:text><xsl:apply-templates/>
	</xsl:template>
	
   <!-- Language template -->
   <xsl:template name="language">
      <xsl:param name="lang"/>
      <xsl:choose>
         <xsl:when test="$lang='fr' or $lang='FR'"> (Fre).</xsl:when>
         <xsl:when test="$lang='jp' or $lang='JP'"> (Jpn).</xsl:when>
         <xsl:when test="$lang='ru' or $lang='RU'"> (Rus).</xsl:when>
         <xsl:when test="$lang='de' or $lang='DE'"> (Ger).</xsl:when>
         <xsl:when test="$lang='se' or $lang='SE'"> (Swe).</xsl:when>
         <xsl:when test="$lang='it' or $lang='IT'"> (Ita).</xsl:when>
         <xsl:when test="$lang='he' or $lang='HE'"> (Heb).</xsl:when>
         <xsl:when test="$lang='sp' or $lang='SP'"> (Spa).</xsl:when>
      </xsl:choose>
   </xsl:template>
	 <xsl:template match="lpage">
	<xsl:apply-templates/>
    </xsl:template>

<xsl:template name="cleantitle">
      <xsl:param name="str"/>
        <xsl:value-of select="translate($str,'. ,-_','')"/>
 </xsl:template>

</xsl:stylesheet>   
