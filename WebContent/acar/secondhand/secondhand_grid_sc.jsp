<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_yb.*, acar.common.*, acar.estimate_mng.*"%>
<jsp:useBean id="olyBean" class="acar.offls_yb.Offls_ybBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="srBn" class="acar.secondhand.ShResBean" scope="page"/>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");		
	
	String gubun 		= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String brch_id 		= request.getParameter("brch_id")	==null?"":request.getParameter("brch_id");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String res_yn 		= request.getParameter("res_yn")	==null?"":request.getParameter("res_yn");
	String res_mon_yn	= request.getParameter("res_mon_yn")	==null?"":request.getParameter("res_mon_yn");
	String all_car_yn	= request.getParameter("all_car_yn")	==null?"":request.getParameter("all_car_yn");

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 2; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(!gubun_nm.equals("")) gubun_nm = AddUtil.replace(gubun_nm,"'","");
	
	Vector vts = shDb.getSecondhandList_20120821(gubun2, gubun, gubun_nm, brch_id, sort_gubun, res_yn, res_mon_yn, all_car_yn, "");
	int vt_size = vts.size();
	
	long total_c_amt = 0;
	long total_f_amt = 0;
	long total_rb_amt = 0;
	long total_lb_amt = 0;
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
/* var checkflag = "false";
function AllSelect(){
	var field = document.querySelectorAll("#gridbox [name='pr']");
	if(checkflag == "false"){
		for(i=0; i<field.length; i++){
			field[i].checked = true;
		}
		checkflag = "true";
		return;
	}else{
		for(i=0; i<field.length; i++){
			field[i].checked = false;
		}
		checkflag = "false";
		return;
	}
} */

//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//주차현황
function parking_car(car_mng_id, io_gubun, park_id)

{
	window.open("/fms2/park_home/parking_check_frame.jsp?car_mng_id="+car_mng_id+"&io_gubun=1&park_id="+park_id+"&st=1", "PARKING_CAR", "left=100, top=20, width=1000, height=900, scrollbars=auto");
}	

//사고사진
function accid_pic(car_mng_id, accid_id)

{
	window.open("/acar/accid_mng/accid_u_in10.jsp?car_mng_id="+car_mng_id+"&accid_id="+accid_id+"&mode=view", "ACCID_PIC", "left=100, top=20, width=1000, height=900, scrollbars=auto");
}	

function view_detail(auth_rw,car_mng_id,rent_mng_id,rent_l_cd,jg_code){

	var gubun 	= document.form1.gubun.value;
	var gubun2 	= document.form1.gubun2.value;
	var gubun_nm 	= document.form1.gubun_nm.value;	
	var sort_gubun 	= document.form1.sort_gubun.value;
	
	var url 	= "?auth_rw="+auth_rw+"&car_mng_id="+car_mng_id+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&jg_code="+jg_code;
	
	url = url + "&gubun="+gubun+"&gubun2="+gubun2+"&gubun_nm="+gubun_nm+"&sort_gubun="+sort_gubun;
	
	url = url + "&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&from_page=/acar/secondhand/secondhand_sc.jsp";
	
			
	parent.parent.d_content.location.href ="./secondhand_detail_frame.jsp"+url;
	
}
-->
</script>
</head>
<body leftmargin="15" height='<%=height%>'>
<form name='form1'  id="form1" action='' method='post' target='d_content'>
<input type='hidden' name='height' id="height" value='<%=height%>'>
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
<table border="0" cellspacing="0" cellpadding="0" width=100% height="20px">
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            ※ 재렌트/재리스요금 : 약정주행거리 10,000km/1년, 기본식 공급가 기준 
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td>
        </td>
    </tr>    
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;" colspan='3'>
            ※ 홈페이지 미반영 기준
            (1) 계약 구분이 지연대차이면서 반차 예정일이 현재 날짜를 기준으로 +3일보다 이후인 경우.
            (2) 예약이 3순위까지 진행된 경우.
        </td>
    </tr>    
</table>
</body>

<script>

var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//총0-32열(33개)
	myGrid.setHeader("연번,내용,예약,#cspan,#cspan,#cspan,상태,차량번호,차명,재리스<br>사진,연료,색상,최초<br>등록일,모델<br>연도,자산<br>양수,차령,주행<br>거리,최대계약<br>개월수,재렌트,#cspan,#cspan,재리스,주차장,사고<br>유무,사고수리비,#cspan,사고사진,선택사양,재리스사진<br>등록일자,재리스<br>등록일자,대여료<br>수정일,차종코드");
	myGrid.attachHeader("#rspan,#rspan,상태,1순위,2순위,3순위,#rspan,#text_filter,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,12개월,24개월,36개월,36개월,#rspan,#rspan,1위,2위,#rspan,#rspan,#rspan,#rspan,#select_filter,#rspan");
	myGrid.setInitWidths("40,125,60,90,45,45,50,100,170,50,60,80,85,45,40,30,60,70,60,60,60,60,70,30,80,75,60,150,85,85,85,80");
	//myGrid.setColSorting("int,str,int,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,str,str,int,int,int,int,int,int,int,int,int,str,str,int,int,str,str,str,str,str,str,str,str,int");
	myGrid.setColTypes("ro,ro,ro,ro,ro,ro,ro,link,ro,link,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,ro,link,ro,ro,ro,link,ro,ro,ro,ro,ro");
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center,center");
	
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
    // myGrid.enableBlockSelection();
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);

    var gridQString = "secondhand_grid_sc_xml.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch_id=<%=brch_id%>&gubun=<%=gubun%>&gubun2=<%=gubun2%>&gubun_nm=<%=gubun_nm%>&sort_gubun=<%=sort_gubun%>&res_yn=<%=res_yn%>&res_mon_yn=<%=res_mon_yn%>&all_car_yn=<%=all_car_yn%>&height=<%=height%>";
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