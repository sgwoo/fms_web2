<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*"%>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 			= request.getParameter("auth_rw")			==null?"":request.getParameter("auth_rw");
	String user_id 			= request.getParameter("user_id")			==null?"":request.getParameter("user_id");
	String br_id 				= request.getParameter("br_id")				==null?"":request.getParameter("br_id");		
	
	String gubun 			= request.getParameter("gubun")				==null?"":request.getParameter("gubun");
	String gubun_nm 		= request.getParameter("gubun_nm")		==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")		==null?"":request.getParameter("sort_gubun");
	String brch_id 			= request.getParameter("brch_id")			==null?"":request.getParameter("brch_id");
	String gubun2 			= request.getParameter("gubun2")			==null?"":request.getParameter("gubun2");
	String res_yn 			= request.getParameter("res_yn")			==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn		= request.getParameter("all_car_yn")		==null?"":request.getParameter("all_car_yn");
	String agent_yn		= request.getParameter("agent_yn")		==null?"Y":request.getParameter("agent_yn");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(!gubun_nm.equals("")) gubun_nm = AddUtil.replace(gubun_nm,"'","");
	
%>

<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" /> 
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body {height: 97%;	}
	input.whitenum {text-align: right;  border-width: 0; }
	table.hdr td {	height: 30px !important;	}
</style>
<!--Grid-->

<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();			
	}
	
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}

	function view_detail(auth_rw,car_mng_id,rent_mng_id,rent_l_cd,jg_code){
	
		var gubun 	= document.form1.gubun.value;
		var gubun2 	= document.form1.gubun2.value;
		var gubun_nm 	= document.form1.gubun_nm.value;	
		var sort_gubun 	= document.form1.sort_gubun.value;
		
		var url 	= "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&jg_code="+jg_code;
		
		url = url + "&gubun="+gubun+"&gubun2="+gubun2+"&gubun_nm="+gubun_nm+"&sort_gubun="+sort_gubun;
		
		url = url + "&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&agent_yn=<%=agent_yn%>&from_page=/acar/secondhand/secondhand_sc.jsp";
		
				
		parent.parent.d_content.location.href ="./secondhand_detail_frame.jsp"+url;
		
	}
-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:init()">
<form name='form1'  id="form1">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="sort_gubun" value="<%=sort_gubun%>">
<input type="hidden" name="brch_id" value="<%=brch_id%>">
<input type="hidden" name="res_yn" value="<%=res_yn%>">
<input type="hidden" name="res_mon_yn" value="<%=res_mon_yn%>">
<input type="hidden" name="all_car_yn" value="<%=all_car_yn%>">

</form>
<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
<table border="0" cellspacing="0" cellpadding="0" width=100% height="25px">
    <tr> 
        <td>
			<div id="a_1" style="color:red;">Loading</div>
        </td>
    </tr>    
</table>
</body>

<script>

	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//총0-32열(19개)
	myGrid.setHeader("연번,내용,예약,#cspan,#cspan,#cspan,상태,차량번호,차명,사진,#cspan,연료,색상,최초<br>등록일,차령,주행<br>거리,주차장,사고<br>유무,선택사양");
	myGrid.attachHeader("#rspan,#rspan,상태,1순위,2순위,3순위,#rspan,#text_filter,#rspan,보기,등록일자,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
	myGrid.setInitWidths("40,120,60,80,40,40,50,100,200,50,70,70,100,80,40,50,100,40,180");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,link,ro,link,ro,ro,ro,ro,ro,ro,ro,ro,ro");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	
	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){  
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('해당 차량이 없습니다');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
	
	myGrid.splitAt(8);
	
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(true);
    //myGrid.enableBlockSelection();
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);

    var gridQString = "secondhand_grid_sc_xml.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&agent_yn=<%=agent_yn%>";
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