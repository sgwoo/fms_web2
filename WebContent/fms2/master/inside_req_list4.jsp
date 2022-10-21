<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* " %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<!--Grid-->
<script language="JavaScript">

	
</script>
<script language='javascript'>

var gridQString = "";

</script>

</head>
<body leftmargin="15">

<table style="width:650;">
 <tr>
   			<td style="text-align:center;"> <보유차리스트> </td>
 </tr>
 <tr>
   			<td style="text-align:right;"> <!--<a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;--></td>
 </tr>
</table>
			
	<table border=0 cellspacing=0 cellpadding=0 width=100% height=92% >

	<tr>
		<td>
			<div id="gridbox" style="width:100%;height:95%; margin: 5px 0 5px 0;"></div>
		</td>
	</tr>
 
	
</table>
</body>

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-15열(16개)
	myGrid.setHeader("연번,자동차회사,차대번호,차명");
	myGrid.setInitWidths("50,200,200,200");
	myGrid.setColTypes("ron,ro,ro,ro");
  myGrid.setColAlign("center,center,center,center");
	myGrid.enableTooltips("false,false,false,false");
	myGrid.attachHeader("#rspan,#select_filter,#text_filter,#text_filter");	
	myGrid.enableCSVAutoID(true);
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

		
	myGrid.enableBlockSelection(true);	
  myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
  myGrid.forceLabelSelection(true);
  myGrid.attachEvent("onKeyPress",onKeyPressed);
  myGrid.enableSmartRendering(true, 650);
	myGrid.setColSorting("int,str,str,str");
  gridQString = "inside_list4_xml.jsp";
  myGrid.load(gridQString);	    


	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
				myGrid.setCSVDelimiter("\t");
				
				myGrid.copyBlockToClipboard()
			}
			if(code==86&&ctrl){
				myGrid.setCSVDelimiter("\t");
				myGrid.pasteBlockFromClipboard()
			}
		return true;
	}

</script>

</html>