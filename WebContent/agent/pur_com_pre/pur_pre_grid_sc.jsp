<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String opt1 		= request.getParameter("opt1")		==null?"":request.getParameter("opt1");
	String opt2 		= request.getParameter("opt2")		==null?"":request.getParameter("opt2");
	String opt3 		= request.getParameter("opt3")		==null?"":request.getParameter("opt3");
	String opt4 		= request.getParameter("opt4")		==null?"":request.getParameter("opt4");
	String opt5 		= request.getParameter("opt5")		==null?"":request.getParameter("opt5");
	String opt6 		= request.getParameter("opt6")		==null?"":request.getParameter("opt6");
	String opt7 		= request.getParameter("opt7")		==null?"":request.getParameter("opt7");
	String e_opt1 		= request.getParameter("e_opt1")	==null?"":request.getParameter("e_opt1");
	String e_opt2 		= request.getParameter("e_opt2")	==null?"":request.getParameter("e_opt2");
	String e_opt3 		= request.getParameter("e_opt3")	==null?"":request.getParameter("e_opt3");
	String e_opt4 		= request.getParameter("e_opt4")	==null?"":request.getParameter("e_opt4");
	String e_opt5 		= request.getParameter("e_opt5")	==null?"":request.getParameter("e_opt5");
	String e_opt6 		= request.getParameter("e_opt6")	==null?"":request.getParameter("e_opt6");
	String e_opt7 		= request.getParameter("e_opt7")	==null?"":request.getParameter("e_opt7");
	String ready_car	= request.getParameter("ready_car")	==null?"":request.getParameter("ready_car");
	String eco_yn 	= request.getParameter("eco_yn")	==null?"":request.getParameter("eco_yn");
	String car_nm2 		= request.getParameter("car_nm2")		==null?"":request.getParameter("car_nm2");
	String car_nm3 		= request.getParameter("car_nm3")		==null?"":request.getParameter("car_nm3");

	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
	String vlaus = 	"?first="+first+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&sort="+sort+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&from_page="+from_page+
				   	"&sh_height="+height+"&s_kd="+s_kd+"&t_wd="+t_wd+
				   	"&opt1="+opt1+"&opt2="+opt2+"&opt3="+opt3+"&opt4="+opt4+"&opt5="+opt5+"&opt6="+opt6+"&opt7="+opt7+
				   	"&e_opt1="+e_opt1+"&e_opt2="+e_opt2+"&e_opt3="+e_opt3+"&e_opt4="+e_opt4+"&e_opt5="+e_opt5+"&e_opt6="+e_opt6+"&e_opt7="+e_opt7+
				   	"&ready_car="+ready_car+"&eco_yn="+eco_yn+"&car_nm2="+car_nm2+"&car_nm3="+car_nm3+
				   	"";

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
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body 	{
		height: 97%;
	}
	#gridbox{
		height: 513px !important;
	}
	.objbox{
		height: 422px !important;
	}
</style>
<!--Grid-->

<script language='javascript'>
<!--

	function save(){
		window.open("/fms2/pur_com_pre/pur_pre_i.jsp<%=vlaus%>", "CHANGE_ITEM", "left=50, top=50, width=1050, height=500, scrollbars=yes, status=yes");
	}	

 	//계약서 내용 보기
	function view_cont(seq){
		var fm = document.form1;
		fm.seq.value 	= seq;
		fm.target ='d_content';
		fm.action = '/fms2/pur_com_pre/pur_pre_c.jsp';
		fm.submit();
	}
	
 	//엑셀
	function execl(){
		var fm = document.form1;
		fm.target ='_blank';
		fm.action = '/fms2/pur_com_pre/pur_pre_sc_in_excel.jsp';
		fm.submit();
	}
 	
 	//계약4단계등록시 메세지수신 차종설정 팝업
	function go_setJgCode_pop(){
		window.open("/fms2/pur_com_pre/pur_pre_pop.jsp?mode=jg_code", "PUR_PRE_POP", "left=100, top=20, width=600, height=500, scrollbars=auto");
 	}
 	
	function set_handlers() {
        alert("in inithandlers " + basicgridbox);
        basicgridbox.attachEvent("onDistributedEnd",doDistEnd);
	}
	
	function doDistEnd() {
	    alert("doDistEnd");
	}
	
	var gridQString = "";
	
//-->
</script>
</head>
<body leftmargin="15">

<table border=0 cellspacing=0 cellpadding=0 width=100% height=1%>	
    <tr> 
        <td align="left" style="font-size: 9pt;" width="10%">
            * 총 건수 : <span id="gridRowCount">0</span>건
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="30%">
    	</td>
    	<td align="center" style="background-color: #FFD4DF;">
    		<span style="font-weight: bold; font-size: 14px;">※ 아래 사전계약 리스트는 실시간 반영리스트가 아니므로 예약 진행시 해당 대리점(출고영업소)에 출고 여부 확인 필수!</span>
    	</td>
    </tr>
</table>
<div id="gridbox" style="width:100%; height:98%; margin: 5px 0 5px 0;"></div>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='sort'		value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/pur_com_pre/pur_pre_frame.jsp'>
  <input type='hidden' name='seq' 		value=''>
  <input type='hidden' name='opt1' 		value='<%=opt1%>'>
  <input type='hidden' name='opt2' 		value='<%=opt2%>'>
  <input type='hidden' name='opt3' 		value='<%=opt3%>'>
  <input type='hidden' name='opt4' 		value='<%=opt4%>'>
  <input type='hidden' name='opt5' 		value='<%=opt5%>'>
  <input type='hidden' name='opt6' 		value='<%=opt6%>'>
  <input type='hidden' name='opt7' 		value='<%=opt7%>'>
  <input type='hidden' name='e_opt1' 	value='<%=e_opt1%>'>
  <input type='hidden' name='e_opt2' 	value='<%=e_opt2%>'>
  <input type='hidden' name='e_opt3' 	value='<%=e_opt3%>'>
  <input type='hidden' name='e_opt4' 	value='<%=e_opt4%>'>
  <input type='hidden' name='e_opt5' 	value='<%=e_opt5%>'>
  <input type='hidden' name='e_opt6' 	value='<%=e_opt6%>'>
  <input type='hidden' name='e_opt7' 	value='<%=e_opt7%>'>
  <input type='hidden' name='ready_car' value='<%=ready_car%>'>
  <input type='hidden' name='eco_yn' value='<%=eco_yn%>'>
  <input type='hidden' name='car_nm2' 		value='<%=car_nm2%>'>
	<input type='hidden' name='car_nm3' 		value='<%=car_nm3%>'>
	 <input type='hidden' name='first' 		value='<%=first%>'>
</form>
</body>

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-21열(22개)
		
	myGrid.setHeader("연번,출고영업소,계출번호,요청일시,엔진종류,차명,선택품목,외장색상,내장색상,가니쉬색상,소비자가,출고<br>예정일,1순위<br>예약자,진행구분,예약일,예약만료일,고객상호,고객<br>주소,연락처,메모,계약번호,2순위<br>예약자,출고일,사전계약<br>해지일,계약금,계약금<br>지급일");
	myGrid.setInitWidths("40,90,105,130,160,245,340,160,120,120,100,100,60,80,80,100,100,60,100,200,110,60,80,80,100,80");
	myGrid.setColTypes("ron,ro,link,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.attachHeader("#rspan,#select_filter,#text_filter,#rspan,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#text_filter,#rspan,#rspan,#text_filter,#select_filter,#rspan,#rspan,#text_filter,#rspan,#rspan,#rspan,#text_filter,#text_filter,#rspan,#rspan,#rspan,#rspan");
	myGrid.attachHeader("#rspan,총 건수,#cspan,{#stat_count}건,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,,,,,,]);
	myGrid.setColAlign("center,center,center,center,center,left,left,center,center,center,center,center,center,center,center,center,center,center,center,left,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,true,true,true,true,true,true,false,false,false,false,false,true,false,false,true,false,false,false,false,false,false,false");
	myGrid.enableAutoHeight(false, 450);
	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){ document.getElementById("a_1").style.display="none"; });
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

	myGrid.detachHeader(2);
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);

    gridQString = "pur_pre_grid_xml.jsp?first=<%=first%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>"+
    			  "&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>"+
    			  "&t_wd=<%=t_wd%>&sort=<%=sort%>&from_page=<%=from_page%>&sh_height=<%=sh_height%>"+
    			  "&opt1=<%=opt1%>&opt2=<%=opt2%>&opt3=<%=opt3%>&opt4=<%=opt4%>&opt5=<%=opt5%>&opt6=<%=opt6%>&opt7=<%=opt7%>"+
    			  "&e_opt1=<%=e_opt1%>&e_opt2=<%=e_opt2%>&e_opt3=<%=e_opt3%>&e_opt4=<%=e_opt4%>&e_opt5=<%=e_opt5%>&e_opt6=<%=e_opt6%>&e_opt7=<%=e_opt7%>"+
    			  "&ready_car=<%=ready_car%>&eco_yn=<%=eco_yn%>&car_nm2=<%=car_nm2%>&car_nm3=<%=car_nm3%>";
    myGrid.load(gridQString);


	function onKeyPressed(code,ctrl,shift){
		if(code==67&&ctrl){
			if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
				myGrid.setCSVDelimiter("\t");
				
				myGrid.copyBlockToClipboard();
			}
			if(code==86&&ctrl){
				myGrid.setCSVDelimiter("\t");
				myGrid.pasteBlockFromClipboard();
			}
		return true;
	}

</script>

</html>
