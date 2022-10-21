<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*, acar.user_mng.*"%> 
<%@ include file="/acar/cookies.jsp" %>  

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>FMS</title>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style>
button.img_button {
        background: url("/acar/images/center/button_save.gif") no-repeat;
        border: none;
        width: 40px;
        height: 19px;
        cursor: pointer;
}
</style>
<!--Grid-->
<script language="JavaScript">
	function insDisp(m_id, l_cd, c_id, ins_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.cmd.value = "u";		
		fm.target = "d_content";
		fm.action = "ins_u_frame.jsp";
		fm.submit();
	}
	function gridSubmit(){
		var fm = document.form1;
		fm.target.value = "d_content";
		fm.action = "ins_c2_sc_server.jsp";
		fm.submit();
	}
	
	function select_c2_ins_excel_com(){
		var con = confirm("보험 배서 요청등록을 하시겠습니까?");
		if ( con == true){  
			var fm = document.form1;
			fm.target = "_blank";
			fm.action = "ins_c2_sc_excel_ins_com.jsp";
			fm.submit();
		}
	}
	function select_research(){
		var con = confirm("보험 배서 리스트를 재검색 하시겠습니까?");
		if ( con == true){  
			var fm = document.form1;
			fm.target = "_blank";
			fm.action = "ins_c2_sc_excel_ins_research.jsp";
			fm.submit();
		}
	}
	
	function insDelete(reg_code, seq){
		var fm = document.form1;
		fm.reg_code.value = reg_code;
		fm.seq.value = seq;
		fm.cmd.value = "u";	
		fm.target.value = "c_foot";
		fm.action = "ins_c2_frame.jsp";
		fm.submit();
	}
	
	
</script>
<script language='javascript'>

var gridQString = "";
</script>

</head>
<body leftmargin="15">
<form name='form1' action='ins_c2_sc_server.jsp' method='post' target='d_content'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='m_id' value=''>
	<input type='hidden' name='l_cd' value=''>
	<input type='hidden' name='cmd' value=''>
	<input type='hidden' name='c_id' value=''>
	<input type='hidden' name='ins_st' value=''>
	<input type='hidden' name='dt' value='<%=dt%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='reg_code' value=''>
	<input type='hidden' name='seq' value=''>
	<input type='hidden' name='flag' value=''>
	<input type='hidden' name='go_url' value='/acar/ins_mng/ins_c2_frame.jsp'>
<table style="width:100%;">
 <tr>
   			
   			
   			<td style="text-align:left;">
	   			<%if(gubun1.equals("N")){%>
	   				<%	if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>		
				     	&nbsp;&nbsp;
				      <input type="button" class="button" value='보험 배서 목록 재검색' onclick='javascript:select_research();' style="">
				      <input type="button" class="button" value='선택 항목 삭제' onclick='javascript:deleteAll();' style="background-color: RGB(24,122,187);">
			      <%	}%>
			      <%}%>
   			</td>
   			<td style="text-align:right;">
   				
   			
   				<!--<a href="javascript:changeData()"><img src=/acar/images/center/button_igcr.gif align=top border=0></a>-->
   				<a href="javascript:changeDisplay();"><img src=/acar/images/center/button_ysbg.gif align=top border=0></a>
   				<button type="submit" value="Apply" class="img_button" style="height: 22px;"></button>
   				<a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=top border=0></a>&nbsp;&nbsp;
   				
   				<%if(gubun1.equals("N")){%>
   				<%	if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>		
   				&nbsp;&nbsp;
		      <input type="button" class="button" value='보험 배서 요청 등록' onclick='javascript:select_c2_ins_excel_com();'>
		      <%	}%>
		      <%}%>
		      
   			</td>
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
	var checkedArray = [];
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-15열(16개)
	myGrid.setHeader(",구분,등록일,연번,차량번호,증권번호,상호명,차명,사업자번호,보험시작일,보험만료일,배서항목명,변경전,변경후,삭제,변경일");  
	myGrid.setInitWidths("50,210,130,50,100,110,110,90,90,90,90,120,100,105,50,100");
	//myGrid.setColTypes("ron,ro,ro,ro,ro,link,ro,ro,ro,ro,ro,ro,ro,ro,coro");
	myGrid.setColTypes("ch,ron,ro,ro,link,ro,ro,ro,ro,ro,ro,ro,ro,ro,link,ro");
	//myGrid.attachHeader("#rspan,#rspan,#select_filter,#rspan,#rspan,#rspan,#rspan,#select_filter,#rspan,#select_filter,#select_filter,#rspan,#rspan");
  	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false");
	myGrid.enableCSVAutoID(true);
	//var combobox = myGrid.getCombo(14);
	//combobox.put("","");
	//combobox.put("Y","Y");
	//combobox.put("N","N");

			
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

	
	myGrid.splitAt(4);
	myGrid.enableBlockSelection(true);
	myGrid.enableMathEditing(true);
	myGrid.enableColumnMove(true);
	myGrid.forceLabelSelection(true);
	myGrid.attachEvent("onKeyPress", onKeyPressed);
	myGrid.attachEvent("onCheckbox", function(rid, cInd, state) {
		var checked = myGrid.getCheckedRows(0);
		checkedArray = checked.split(",");
	});
	myGrid.setColSorting("str,str,int,str,str,str,str,str,str,str,str,str,na,str");
	myGrid.enableSmartRendering(true, 2000);

	gridQString = "ins_c2_xml.jsp?dt=<%=dt%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&t_wd=<%=t_wd%>";
    myGrid.load(gridQString);	    

    myGrid.setColumnHidden('15',true);
    
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
	function changeData(){
		for(var i=0;i<=myGrid.getRowsNum();i++){
			myGrid.cells(myGrid.getRowId(i),13).setChecked(true); 
		}
	}
	
	var showGubun = false;
	
	function changeDisplay(){
		//alert( myGrid.isColumnHidden('0'.value));
		if( showGubun == false){
			myGrid.setColumnHidden('0',true);
			myGrid.setColumnHidden('1',true);
			myGrid.setColumnHidden('13',true);
			showGubun = true;
		}else if( showGubun == true){
			myGrid.setColumnHidden('0',false);
			myGrid.setColumnHidden('1',false);
			myGrid.setColumnHidden('13',false);
			showGubun = false;
		}
		
		
	}
	 
	 function deleteAll() {
		 if(confirm("선택한 항목을 삭제하시겠습니까?")) {
			 var regCodeArray = [];
			 var seqArray = [];
			 
			 if(checkedArray.length == 0) {
				 alert("삭제할 항목을 선택하세요.");
				 return;
			 }
			 
			 for(var i=0; i< checkedArray.length; i++) {
				 var dataArray = checkedArray[i].split("_");
				 regCodeArray.push(dataArray[0]);
				 seqArray.push(dataArray[1]);
			 }
			 
			 var fm = document.form1;
				fm.reg_code.value = regCodeArray;
				fm.seq.value = seqArray;
				fm.flag.value = "ALL";
				fm.cmd.value = "u";	
				fm.target.value = "c_foot";
				fm.action = "ins_c2_frame.jsp";
				fm.submit();
		 } else {
			 return;
		 }
	 }

</script>

</html>