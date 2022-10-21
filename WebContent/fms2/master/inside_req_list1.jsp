<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
%>
<html>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<script language='javascript'>

var gridQString = "";

</script>
</head>
<body leftmargin="15">
	<table style="width:100%;">
	 	<tr>
   			<td style="text-align:center;"> <보유차 기본정보> </td>
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
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-30열(31개)
	myGrid.setHeader("연번,계약번호,차명,모델명,차량번호,상호,계약자,차량구분,용도구분,대여구분,대여방식,월대여료,대여개시일,대여만료일,차종,배기량,차량가격,선택사양금액,선택사양,외장색상금액,외장색상,내장색상,탁송료,소비자가합계,구입차가,매출DC,구입가합계,출고일,신차등록일,연료,예상주행거리");  
	myGrid.setInitWidths("50,110,80,120,100,120,90,90,80,120,100,105,80,100,80,90,90,80,90,90,90,90,140,100,100,90,90,140,100,100,100");
	myGrid.setColTypes("ron,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	//myGrid.attachHeader("#rspan,#rspan,#select_filter,#rspan,#rspan,#rspan,#rspan,#select_filter,#rspan,#select_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
  	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,right,center,right,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false");
	//myGrid.enableCSVAutoID(true);
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

		//myGrid.splitAt(4);
	  //myGrid.enableBlockSelection(true);	
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
   // myGrid.enableSmartRendering(true, 2000);
   myGrid.enableSmartRendering(false);
	myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,str,int,str,str,str,int,int,int,str,int,str,str,int,int,int,int,int,str,str,str,int");
    gridQString = "inside_list1_xml.jsp?end_dt=<%=end_dt%>";
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
