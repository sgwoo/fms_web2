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
<!--style type="text/css">
div.gridbox_dhx_web.gridbox table.obj.row20px tr td {font-size: 12px; height: 28px; line-height: 25px }
div.gridbox div.ftr td {font-size: 12px;}
input.whitenum {text-align: right;  border-width: 0; }
</style!-->
<!--Grid-->
<script language="JavaScript">

	
</script>
<script language='javascript'>

var gridQString = "";

</script>

</head>
<body leftmargin="15">

<table style="width:100%;">
 <tr>
   			<td style="text-align:center;"> <보유차 차량정보> </td>
 </tr>
 <tr>
   			<td style="margin-right:50px;"><div style="margin-right:50px"><a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=right border=0 width=""></a></div></td>
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
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-16열(17개)
	myGrid.setHeader("연번,계약번호,성명,상호,최초영업자,차종코드,차명,차종,기본차량가격,옵션,옵션가격,외장색상,외장색상가격,내장색상,차량가격합계,출고영업소,계약일자,자체출고여부,출고예정일,출고일,최초등록일,차량번호,차대번호");  
	myGrid.setInitWidths("50,110,80,120,100,90,90,90,80,120,100,105,80,100,80,90,90,80,90,90,90,90,140");
	myGrid.setColTypes("ron,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	//myGrid.attachHeader("#rspan,#rspan,#select_filter,#rspan,#rspan,#rspan,#rspan,#select_filter,#rspan,#select_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
  	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,right,center,right,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false");
	myGrid.enableCSVAutoID(true);
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

		//myGrid.splitAt(4);
	  myGrid.enableBlockSelection(true);	
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.enableSmartRendering(true, 2000);
		myGrid.setColSorting("int,str,str,str,str,int,str,str,int,str,int,str,int,str,int,str,int,str,int,int,int,str,str");
    gridQString = "inside_list2_xml.jsp";
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