<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%> 
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
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

	function insDisp(m_id, l_cd, c_id, ins_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.cmd.value = "u";		
		fm.target.value = "d_content";
		fm.action = "ins_u_frame.jsp";
		fm.submit();
	}

	
</script>
<script language='javascript'>

var gridQString = "";

</script>

</head>
<body leftmargin="15">
<form name='form1' action='ins_u_frame.jsp' method='post' target='d_content'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='m_id' value=''>
	<input type='hidden' name='l_cd' value=''>
	<input type='hidden' name='c_id' value=''>
	<input type='hidden' name='ins_st' value=''>
	<input type='hidden' name='cmd' value=''>
	<input type='hidden' name='go_url' value='/acar/ins_mng/ins_b_frame.jsp'>
<table style="width:100%;">
 <tr>
   			<td style="text-align:right;"> <a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;</td>
    </tr>
</table>
			
	<table border=0 cellspacing=0 cellpadding=0 width=100% height=92% >

	<tr>
		<td>
			<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
		</td>
	</tr>
 
	
</table>
</form>
</body>

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-15열(16개)
	myGrid.setHeader("연번,차량번호,증권번호,상호명,차명,사업자번호,보험시작일,보험만료일,배서항목명,변경전,변경후");  
	myGrid.setInitWidths("50,90,120,120,110,90,90,90,90,120,100");
	//myGrid.setColSorting("int,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str");
	myGrid.setColTypes("ron,link,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	//myGrid.attachHeader("#rspan,#rspan,#select_filter,#rspan,#rspan,#rspan,#rspan,#select_filter,#rspan,#select_filter,#select_filter,#rspan,#rspan");
  myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false");
	myGrid.enableCSVAutoID(true);
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

		myGrid.splitAt(4);
	  myGrid.enableBlockSelection(true);	
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.enableSmartRendering(true, 2000);

    gridQString = "ins_c_xml.jsp?dt=<%=dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>";
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