<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- To generate multiple html pages using Saxon -->
	<!-- format OU XML to HTML for OCI Preview -->
	<xsl:output method="html" indent="yes" name="html" encoding="UTF-8"/>

    <xsl:include href="common.xsl"/>
    <xsl:include href="flash_common.xsl"/>

	<xsl:param name="samedir">no</xsl:param>
	<xsl:param name="csspath">yes</xsl:param> <!-- indicates path ../ required -->

    <!-- ************************************************************ -->
    <!-- main template matching xmlFileList.xml -->
	<xsl:template match="/">

        <!-- for each course(s) -->
		<xsl:for-each select="//ContentGroup/ContentFile">
            <!-- set up course variables -->
			<xsl:variable name="fileName" select="node()"/>
			<xsl:variable name="CourseId" select="substring-before($fileName, '.xml')"/>
			<xsl:variable name="items_path">
	                   <xsl:value-of select="concat($CourseId,'/')"/>
			</xsl:variable>

            <!-- set up where we find the content, because it depends on the param samedir
            this 'if' fails with message 'cast does not allow an empty sequence'
            <xsl:variable name="wherecontent">
                <xsl:if test="$samedir='no'">
                    <xsl:value-of select="concat($CourseId,'/')"/>
			</xsl:if>
            </xsl:variable> -->
	        <xsl:variable name="wherecontent">
	           <xsl:choose>
	               <xsl:when test="$samedir='no'">
	                   <xsl:value-of select="concat($CourseId,'/')"/>
	               </xsl:when>
	               <xsl:otherwise></xsl:otherwise>
	           </xsl:choose>
	        </xsl:variable>

	        <!-- find the input files -->
	        <xsl:variable name="currentFile" select="document(concat($wherecontent,$fileName))"/>
	        <xsl:variable name="metadataFile" select="document(concat($wherecontent,'metadata.xml'))"/>

			<xsl:variable name="TotalPages" select="count($currentFile//Item/FrontMatter/Introduction | $currentFile//Session/Section[not(SubSection)] | $currentFile//Session/Section/SubSection | $currentFile//References | $currentFile//Acknowledgements | $currentFile//Appendices)"/>
			<xsl:variable name="indexpage" select="concat($items_path,$CourseId,'_index.html')"/>

			<xsl:result-document href="{$indexpage}" format="html">
				<xsl:call-template name="Main">
					<xsl:with-param name="CourseId" select="$CourseId"/>
					<xsl:with-param name="currentFile" select="$currentFile"/>
					<xsl:with-param name="metadataFile" select="$metadataFile"/>
					<xsl:with-param name="pageType">index</xsl:with-param>
				</xsl:call-template>
			</xsl:result-document>

			<xsl:for-each select="$currentFile//Item/FrontMatter/Introduction | $currentFile//Session/Section[not(SubSection)] | $currentFile//Session/Section/SubSection | $currentFile//References | $currentFile//Acknowledgements | $currentFile//Appendices">
				<xsl:variable name="currentPage" select="position() - 1"/>

				<xsl:variable name="filename" select="concat($items_path,$CourseId,'_section',$currentPage,'.html')"/>

				<xsl:result-document href="{$filename}" format="html">
					<xsl:call-template name="Main">
						<xsl:with-param name="CourseId" select="$CourseId"/>
						<xsl:with-param name="currentFile" select="$currentFile"/>
						<xsl:with-param name="pageType">section<xsl:if test="not(name() = 'Section')">extras</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="TotalPages" select="$TotalPages"/>
						<xsl:with-param name="currentPage" select="$currentPage"/>
						<xsl:with-param name="currentPageType" select="name()"/>
					</xsl:call-template>
				</xsl:result-document>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
    <!-- *********************************************** -->

	<xsl:template name="Main">
		<xsl:param name="CourseId"/>
		<xsl:param name="currentFile"/>
		<xsl:param name="metadataFile"/>
		<xsl:param name="pageType"/>
		<xsl:param name="TotalPages"/>
		<xsl:param name="currentPage"/>
		<xsl:param name="currentPageType"/>
		<html>
			<head>
				<title><xsl:value-of select="$currentFile//Item/Unit/UnitTitle"/></title>
				<!-- set up the CSS path using the param passed <link rel="stylesheet" href="../styles.css"/> -->
			<xsl:element name="link">
				<xsl:attribute name="rel">stylesheet</xsl:attribute>
				<xsl:attribute name="href">
				<xsl:choose>
				<xsl:when test="$csspath = 'yes'">
				<xsl:value-of select="concat('../',$stylefile)"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$stylefile"/></xsl:otherwise>
				</xsl:choose>
				</xsl:attribute>
			</xsl:element>


			<script type="text/javascript"><![CDATA[
				function showcontent(content)
				{
				   document.getElementById(content).style.display="block";
				}

				var newwindow;
				function popupinfo(url, windowName, windowFeatures)
				{
					popupclose();
					newwindow= window.open (url, windowName, windowFeatures);
				}
				function popupclose() {
					if (newwindow != null) {
						if (!newwindow.closed) {
							newwindow.close();
						}
					}
				}
			]]></script>
			</head>
			<!-- change to accomadate microsoft reader -->
			<body>
			<xsl:attribute name="onUnload">popupclose()</xsl:attribute>

				<div id="content">
					<table id="layout-table">
						<tbody>
							<tr>
								<td id="left-column"/>
								<td id="middle-column">
									<table class="categoryboxcontent">
										<tbody>
											<tr>
												<td>
													<div class="pagenums">
														<xsl:call-template name="PagesNums">
															<xsl:with-param name="CourseId" select="$CourseId"/>
															<xsl:with-param name="pageType" select="$pageType"/>
															<xsl:with-param name="TotalPages" select="$TotalPages"/>
															<xsl:with-param name="currentPage" select="$currentPage"/>
															<xsl:with-param name="countPage">
																<xsl:choose>
																	<xsl:when test="number($currentPage) &lt;= 5 or number($TotalPages) &lt;= 10">1</xsl:when>
																	<xsl:when test="(number($TotalPages) - number($currentPage)) &lt; 6 and (number($TotalPages) > 10)">
																		<xsl:value-of select="number($TotalPages) - 10"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="number($currentPage) - 4"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:with-param>
														</xsl:call-template>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<h1>
														<xsl:value-of select="./../Title"/>
													</h1>
												</td>
											</tr>
											<tr>
												<td>
													<xsl:choose>
														<xsl:when test="$pageType = 'index'">
															<xsl:call-template name="indexPage">
																<xsl:with-param name="CourseId" select="$CourseId"/>
																<xsl:with-param name="currentFile" select="$currentFile"/>
																<xsl:with-param name="metadataFile" select="$metadataFile"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:when test="$pageType = 'section' or contains($currentPageType, 'Reference') or contains($currentPageType, 'Appendice')">
															<xsl:call-template name="MainBody">
																<xsl:with-param name="currentPageType" select="$currentPageType"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:otherwise>
															<xsl:apply-templates/>
															<xsl:if test="$currentPageType = 'Introduction'">
                                                                <xsl:call-template name="LearningOutcomes">
																    <xsl:with-param name="currentFile" select="$currentFile"/>
															</xsl:call-template>
                                                            </xsl:if>
														</xsl:otherwise>
													</xsl:choose>
												</td>
											</tr>
											<tr>
												<td>
													<div class="pagenums">
														<xsl:call-template name="PagesNums">
															<xsl:with-param name="CourseId" select="$CourseId"/>
															<xsl:with-param name="pageType" select="$pageType"/>
															<xsl:with-param name="TotalPages" select="$TotalPages"/>
															<xsl:with-param name="currentPage" select="$currentPage"/>
															<xsl:with-param name="countPage">
																<xsl:choose>
																	<xsl:when test="number($currentPage) &lt;= 5 or number($TotalPages) &lt;= 10">1</xsl:when>
																	<xsl:when test="(number($TotalPages) - number($currentPage)) &lt; 6 and (number($TotalPages) > 10)">
																		<xsl:value-of select="number($TotalPages) - 10"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="number($currentPage) - 4"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:with-param>
														</xsl:call-template>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
								<td id="right-column"/>
							</tr>
						</tbody>
					</table>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="PagesNums">
		<xsl:param name="CourseId"/>
		<xsl:param name="pageType"/>
		<xsl:param name="TotalPages"/>
		<xsl:param name="currentPage"/>
		<xsl:param name="countPage"/>
   		<xsl:variable name="startpagenumber">
   			<xsl:choose>
   				<xsl:when test="(number($TotalPages) - number($currentPage)) &lt; 6 and (number($TotalPages) > 10)">
   					<xsl:value-of select="number($TotalPages) - 10"/>
   				</xsl:when>
   				<xsl:when test="number($currentPage) - 4 > 0 and number($TotalPages) > 10">
   					<xsl:value-of select="number($currentPage) - 4"/>
   				</xsl:when>
   				<xsl:otherwise>1</xsl:otherwise>
   			</xsl:choose>
   		</xsl:variable>
   		<xsl:variable name="endpagenumber">
   			<xsl:choose>
   				<xsl:when test="(number($TotalPages) - number($currentPage)) > 5 and number($currentPage) > 5">
   					<xsl:value-of select="number($currentPage) + 6"/>
   				</xsl:when>
   				<xsl:when test="number($currentPage) &lt; 6 and (number($TotalPages) > 10)">11</xsl:when>
   				<xsl:otherwise>
   					<xsl:value-of select="$TotalPages"/>
   				</xsl:otherwise>
   			</xsl:choose>
   		</xsl:variable>
   			<xsl:choose>
   				<xsl:when test="number($countPage) = number($startpagenumber) and number($currentPage) = 0">Pages: &lt;Previous</xsl:when>
   				<xsl:when test="number($currentPage) > 0 and number($countPage) = number($startpagenumber)">
   					Pages: <a href="{concat($CourseId,'_section',number($currentPage)-1,'.html')}">&lt;Previous</a>
   				</xsl:when>
   			</xsl:choose>&#160;
   			<xsl:if test="number($startpagenumber) &lt;= number($endpagenumber)">
   				<xsl:choose>
   					<xsl:when test="$currentPage = ($countPage - 1)">
   						<b>
   							<xsl:value-of select="$countPage"/>
   						</b>
   					</xsl:when>
   					<xsl:otherwise>
   						<a href="{concat($CourseId,'_section',number($countPage)-1,'.html')}">
   							<xsl:value-of select="$countPage"/>
   						</a>
   					</xsl:otherwise>
   				</xsl:choose>&#160;
   				<xsl:choose>
   					<xsl:when test="number($countPage) = number($endpagenumber) and number($currentPage)+1 >= number($TotalPages)">Next ></xsl:when>
   					<xsl:when test="number($countPage) = number($endpagenumber)  and number($currentPage)+1 &lt; number($TotalPages)">
   						<a href="{concat($CourseId,'_section',number($currentPage)+1,'.html')}">Next ></a>
   					</xsl:when>
   				</xsl:choose>
   			</xsl:if>
   			<xsl:if test="number($countPage) &lt; number($endpagenumber)">
   				<xsl:call-template name="PagesNums">
   					<xsl:with-param name="CourseId" select="$CourseId"/>
   					<xsl:with-param name="pageType" select="$pageType"/>
   					<xsl:with-param name="TotalPages" select="$TotalPages"/>
   					<xsl:with-param name="currentPage" select="$currentPage"/>
   					<xsl:with-param name="countPage" select="number($countPage) + 1"/>
   				</xsl:call-template>
   			</xsl:if>
	</xsl:template>
	<xsl:template name="indexPage">
		<xsl:param name="currentFile"/>
		<xsl:param name="CourseId"/>
		<xsl:param name="metadataFile"/>
		<h1 class="indexpage">
  			   Preview of: <xsl:value-of select="$currentFile//Unit/UnitID"/><xsl:text> </xsl:text><xsl:value-of select="$currentFile//Item//Session/Title"/>
		</h1>
		<br/>
		<div align="center">
		<xsl:if test="$currentFile//Preface/Figure">
			<img src="{$currentFile//Preface/Figure/Image/@src}" alt="{$currentFile//Preface/Figure/Description}"/>
		</xsl:if>
		<xsl:if test="$currentFile//Preface/MediaContent">
			<xsl:apply-templates select="$currentFile//Preface/MediaContent"/>
		</xsl:if>
		</div>
		<xsl:call-template name="metaData">
			<xsl:with-param name="metadataFile" select="$metadataFile"/>
		</xsl:call-template>
		<xsl:for-each select="$currentFile//Item/FrontMatter/Introduction | $currentFile//Session/Section[not(SubSection)] | $currentFile//Session/Section/SubSection | $currentFile//References | $currentFile//Acknowledgements | $currentFile//Appendices">
			<xsl:variable name="titleContent">
				<xsl:choose>
					<xsl:when test="name() = 'Section'">
						<xsl:value-of select="Title"/>
					</xsl:when>
					<xsl:when test="name() = 'SubSection'">
						<xsl:value-of select="Title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="name()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="paraContent">
				<xsl:if test=".//Paragraph[1] and (name() = 'Section' or name() = 'SubSection' or name() = 'Introduction')">
					<xsl:apply-templates select=".//Paragraph[1]"/>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="name() = 'SubSection' and substring(@id, string-length(@id) - 2, string-length()) = '001'">
				<h1>
					<xsl:value-of select="../Title"/>
				</h1>
			</xsl:if>
			<a>
				<xsl:attribute name="href"><xsl:value-of select="$CourseId"/>_section<xsl:value-of select="position() - 1"/>.html</xsl:attribute>
				<h2>
					<xsl:value-of select="$titleContent"/>
				</h2>
			</a>
			<p class="paradefault indexpage">
				<xsl:call-template name="trimPara">
					<xsl:with-param name="stringLenRequired">200</xsl:with-param>
					<xsl:with-param name="stringInput" select="$paraContent"/>
				</xsl:call-template>
			</p>
			<br />
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="metaData">
		<xsl:param name="metadataFile"/>
		<xsl:if test="exists($metadataFile//time)">
			<div class="metadata">
				<p class="metadata"><b>Time</b>: <xsl:value-of select="$metadataFile//time"/></p>
				<p class="metadata"><b>Level</b>: <xsl:value-of select="$metadataFile//level"/></p>
			</div>
		</xsl:if>
		<xsl:if test="exists($metadataFile//relations)">
			<div class="ru_block">
				<h2 class="ru_head">Related educational resources</h2>
				<div class="ru_links">
					<p class="metadata">If you are interested in this unit you may also be interested in:</p><br/>
					<xsl:for-each select="$metadataFile//relations/relation[lower-case(urlgroup) = 'ol links']">
						<xsl:variable name="title" select="urltitle"/>
						<xsl:variable name="href" select="url"/>
						<xsl:if test="position() = 1">
							<h1>OpenLearn Links</h1>
						</xsl:if>
						<p class="metadata ru">
						<a title="{$title}" href="{$href}"><xsl:value-of select='urltitle'/></a>
						</p>
					</xsl:for-each>
					<xsl:for-each select="$metadataFile//relations/relation[lower-case(urlgroup) = 'ou links']">
						<xsl:variable name="title" select="urltitle"/>
						<xsl:variable name="href" select="url"/>
						<xsl:if test="position() = 1">
							<h1>Open University Links</h1>
						</xsl:if>
						<p class="metadata ru">
						<a title="{$title}" href="{$href}"><xsl:value-of select='urltitle'/></a>
						</p>
					</xsl:for-each>
					<xsl:for-each select="$metadataFile//relations/relation[lower-case(urlgroup) = 'others']">
						<xsl:variable name="title" select="urltitle"/>
						<xsl:variable name="href" select="url"/>
						<xsl:if test="position() = 1">
							<h1>Other Links</h1>
						</xsl:if>
						<p class="metadata ru">
						<a title="{$title}" href="{$href}"><xsl:value-of select='urltitle'/></a>
						</p>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Figure">
        <xsl:variable name="figurepage">
             <xsl:value-of select="concat(ancestor::Unit/UnitID,'/',@id,'.html')"/>
        </xsl:variable>

		<div align="center">
    		<xsl:variable name="id">
    			<xsl:value-of select="@id"/>
    		</xsl:variable>
    		<a name="{$id}"></a>
				<xsl:apply-templates select="Image"/>
			<xsl:apply-templates select="Caption"/>
			<xsl:if test="normalize-space(Description) != '' ">
			      <a href="javascript: popupinfo('{@id}.html', 'ImageDescription', 'location=0,status=0,scrollbars=1,width=300,height=200')" title="Resource">View description</a>
		   </xsl:if>
            <xsl:apply-templates select="SourceReference"/>
		</div>

        <xsl:if test="normalize-space(Description) != '' ">
			<xsl:result-document href="{$figurepage}" format="html">
				<html>
					<head>
						<title>Image Description</title>
					</head>
					<body>
						<p>
							<xsl:apply-templates select="Description"/>
						</p>
						<p>
							<input type="button" value="Close" onclick="window.close()"/>
						</p>
					</body>
				</html>
			</xsl:result-document>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>