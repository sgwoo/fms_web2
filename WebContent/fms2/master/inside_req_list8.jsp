<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* " %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
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
		<td style="text-align:center;"> &lt;신차계약차량리스트&gt; </td>
 	</tr>
 	<tr>
  		<td style="text-align:right;"> <a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;</td>
 	</tr>
</table>	
<table border=0 cellspacing=0 cellpadding=0 width=100% height=92% style="margin-top: -10px;">
	<tr>
		<td>
			<div id="gridbox" style="width:100%;height:95%; margin: 0 0 5px 0;"></div>
		</td>
	</tr>	
</table>
</body>

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-17열(18개)
	myGrid.setHeader("연번,차대번호,차종구분,차종코드,구차종코드,차명,연식,배기량,변속기,연료,모델,차량번호,최초차량번호,최초등록일, 출고일자,차량소비자가,차량옵션가,공급가,부가세,면세가,옵션,차량색상가,외장색상,내장색상,매출DC,과세구분");  
	myGrid.setInitWidths("50,140,80,120,100,90,90,90,80,80,120,100,105,100,80,110,90,80,90,90,90,90,90,90,140,140");
	myGrid.setColTypes("ron,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.attachHeader(",,#select_filter,,,#text_filter,#select_filter,,#select_filter,#select_filter,#text_filter,#text_filter,,,,,,,,,,,,,,");
	//myGrid.attachHeader(",,,,,,,,,,,,,,,,,,,,,,,,,",[,,,,,,,,,,,,,,,,,,,,,,,,,]);
    myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,right,right,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false");
	//myGrid.enableCSVAutoID(true);
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

		//myGrid.splitAt(4);
	myGrid.detachHeader(2);
	//myGrid.enableBlockSelection(true);
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    //myGrid.enableSmartRendering(true, 2000);
    myGrid.enableSmartRendering(false);
    //myGrid.parse(data,"json");
	myGrid.setColSorting("int,str,str,str,str,int,str,str,str,int,str,int,str,int,int,str,int,str,int,int,int,int,str,str");
    gridQString = "inside_list8_xml.jsp?start_dt=<%=start_dt%>&end_dt=<%=end_dt%>";
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