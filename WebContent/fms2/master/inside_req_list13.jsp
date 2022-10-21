<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* " %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	
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
   			<td style="text-align:center;"> <<%=car_nm%> 견적리스트> </td>
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
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-16열(11개)
	myGrid.setHeader("연번,구분,상호,등록자,등록일시,차명,차종,옵션,외부색상,내부색상,가니쉬색상");  
	myGrid.setInitWidths("50,100,200,80,120,200,300,500,200,200,200");
	myGrid.setColTypes("ron,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.attachHeader(",,,,,,,,,,,");
  	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false");
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
	myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str");
	gridQString = "inside_list13_xml.jsp?start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&car_nm=<%=car_nm%>";
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