<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parking.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String park_id 	= request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String io_gubun	= request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt		= request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
%>
<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body 	{
		height: 97%;
	}
</style>
<!--Grid-->
<!-- <link rel=stylesheet type="text/css" href="/include/table_t.css"> -->
<script type="text/javascript">

	function set_handlers() {
	    alert("in inithandlers " + basicgridbox);
	    basicgridbox.attachEvent("onDistributedEnd",doDistEnd);
	}
	
	function doDistEnd() {
	alert("doDistEnd");
	}
	
	var gridQString = "";
	
	var myGrid;
	
	

</script>
</head>
<body leftmargin="15">
<div id="gridbox" style="width:100%; height:100%; margin: 5px 0 5px 0;"></div>

<form name='form1' method='post'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>' style="margin-left: 30px;">
	<input type='hidden' name='br_id' value='<%=br_id%>'>
</form>
</body>
<script type="text/javascript">
myGrid = new dhtmlXGridObject('gridbox');
myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-12열(13개)
myGrid.setHeader("연번,차량번호,차종,구분,주행거리<br>(km),담당자,차량운전자,주차장,입/출고,목적지,입/출고 일시,등록자,사유");
myGrid.setInitWidths("45,100,*,80,80,80,100,100,60,130,160,80,220");
myGrid.setColTypes("ron,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
myGrid.attachHeader("#rspan,#text_filter,#text_filter,#select_filter,#rspan,#select_filter,#select_filter,#select_filter,#select_filter,#select_filter,#text_filter,#select_filter,#rspan");
myGrid.setColAlign("center,center,left,center,right,center,center,center,center,center,center,center,center,center,center");
myGrid.enableTooltips("false,false,false,false,true,false,false,true,false,true,false,false,true,false,true");
myGrid.init();
myGrid.attachEvent("onKeyPress",onKeyPressed);
myGrid.attachFooter("<b style='font-size:16px;'>총 {#stat_count} 건</b>&nbsp;&nbsp;&nbsp;&nbsp;,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan");
myGrid.enableSmartRendering(true, 2000);


gridQString = "park_io_sc_in.jsp?park_id=<%=park_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&io_gubun=<%=io_gubun%>&t_wd=<%=t_wd%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>"; 
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
