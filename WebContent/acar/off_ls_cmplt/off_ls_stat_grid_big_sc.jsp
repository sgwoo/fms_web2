<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*, acar.util.*, acar.offls_cmplt.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");
		
	//평균재리스잔존가대비율 구하기
	float use_per1 = 0;
	float use_per2 = 0;
	float use_per3 = 0;
	float use_per4 = 0;
	
	float use_cnt1 = 0;
	float use_cnt2 = 0;
	float use_cnt3 = 0;
	float use_cnt4 = 0;
	
	float avg_per1 = 0;
	float avg_per2 = 0;
	float avg_per3 = 0;
	float avg_per4 = 0;
	

%>

<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body {height: 93%;	}
	input.whitenum {text-align: right;  border-width: 0;}
</style>
<!--Grid-->

<script>

function view_detail(car_mng_id, seq)
{
	var fm = document.form1;
	fm.car_mng_id.value = car_mng_id;
	fm.seq.value = seq;
	fm.target = "d_content";
	fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp";
	fm.submit();
}

var gridQString = "";

</script>

</head>
<body leftmargin="15">
<form name='form1' method='post' target='d_content' action='/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'> 
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='gubun' value='<%=gubun%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
	<input type='hidden' name='dt' value='<%=dt%>'>
	<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
	<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
	<input type='hidden' name='s_au' value='<%=s_au%>'>
	<input type='hidden' name='from_page' value='/acar/off_ls_cmplt/off_ls_stat_grid_big_sc.jsp'>  
	<input type='hidden' name='car_mng_id' value=''>
	<input type='hidden' name='seq' value=''> 
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="35px">
	<tr>
		<td align='left'>
			<a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</td> 
        <td align="right" style="margin-right:5px; font-size: 9pt;">
            * 평균 예상낙찰가대비율:
              [현대글로비스-시화]	<input type='text' name='avg_per1' size='4' class='whitenum'>%&nbsp;
              [현대글로비스-분당]	<input type='text' name='avg_per2' size='4' class='whitenum'>%&nbsp;
	      	  [에이제이셀카 주식회사]	<input type='text' name='avg_per4' size='4' class='whitenum'>%&nbsp;		
              [롯데렌탈]		<input type='text' name='avg_per3' size='4' class='whitenum'>%&nbsp;          
        </td>
    </tr> 
</table>
</form>
<div id="gridbox" style="width:100%; height:100%; margin: 5px 0 5px 0;"></div>
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="25px">    		
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            * 총 건수 : <span id="gridRowCount">0</span>건 
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="80%" align="right" style="font-size: 9pt;">
        	<span>* 예상낙찰가 : 20150512 이전에는 재리스잔존가, 20150512 부터는 예상낙찰가 계산값</span>
        </td>
    </tr>    
</table><!-- 
<div class='xGridContainer'>
  <div style="width:100%;height:200px" id="xId1"></div>
  <div style="position:absolute;left:1em;top:2.5em;display:none;" id="xId1_0">No records matched your search criteria...</div>
</div> -->

</body>

<script type="text/javascript">
var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//총0-36열(37개)
	myGrid.setHeader("연번,차량번호,차명,경매장,경매일자,최초등록일,소비자가격,구입가격,희망가,예상낙찰가,매각(낙찰),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,차령,주행<br>거리,경매장<br>평점,마지막위치,사고<br>유무,사고수리비,#cspan,매각수수료,#cspan,#cspan,#cspan,#cspan,낙찰자,선택사양,선택사양가,배기량,연료,색상,내장색상,차종코드");
	myGrid.setInitWidths("35,70,150,90,80,80,105,105,105,105,105,90,70,70,95,85,85,55,65,60,80,50,95,70,85,55,85,80,85,100,170,95,70,50,90,80,70");
	//myGrid.setColSorting("int,str,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,str,int,int,int,int,int,int,int,str,str,int,int,str,str,str,int");
	myGrid.setColTypes("ro,link,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ro,ro,ro,ron");
	myGrid.attachHeader("#rspan,#text_filter,#text_filter,#select_filter,#select_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,낙찰가,소비자가<br>대비,구입가<br>대비,예상<br>낙찰가<br>대비,편차금액,편차%<br>(예상낙찰가<br>기준),편차%<br>(소비자가<br>기준),#rspan,#rspan,#rspan,#select_filter,#select_filter,수리금액,소비자가<br>대비,낙찰<br>수수료,출품<br>수수료,재출품<br>수수료,반입<br>탁송대금,합계,#text_filter,#text_filter,#rspan,#rspan,#select_filter,#rspan,#rspan,#select_filter");
	myGrid.setColAlign("center,center,center,center,center,center,right,right,right,right,right,right,right,right,right,right,right,center,right,center,center,center,right,right,right,right,right,right,right,center,center,right,center,center,center,center,center");
	myGrid.enableTooltips("false,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,false,false,false,true,false,false");
	myGrid.setNumberFormat("0,000",6);
	myGrid.setNumberFormat("0,000",7);
	myGrid.setNumberFormat("0,000",8);
	myGrid.setNumberFormat("0,000",9);
	myGrid.setNumberFormat("0,000",10);
	myGrid.setNumberFormat("0,000.00%",11);
	myGrid.setNumberFormat("0,000.00%",12);
	myGrid.setNumberFormat("0,000.00%",13);
	myGrid.setNumberFormat("0,000",14);
	myGrid.setNumberFormat("0,000.00%",15);
	myGrid.setNumberFormat("0,000.00%",16);
	myGrid.setNumberFormat("0,000",18);
	myGrid.setNumberFormat("0,000",22);
	myGrid.setNumberFormat("0,000.00%",23);
	myGrid.setNumberFormat("0,000",24);
	myGrid.setNumberFormat("0,000",25);
	myGrid.setNumberFormat("0,000",26);
	myGrid.setNumberFormat("0,000",27);
	myGrid.setNumberFormat("0,000",28);
	myGrid.setNumberFormat("0,000",31);
	

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

	myGrid.attachFooter("편차 절대값 반영,#cspan,#cspan,합계,#cspan,#cspan,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,,#stat_cha_total,,,,,,,,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("편차 절대값 반영,#cspan,#cspan,평균(평균금액 대 평균금액으로 계산),#cspan,#cspan,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,{#stat_multi_total_avg}6:10,{#stat_multi_total_avg}7:10,{#stat_multi_total_avg}9:10,#stat_cha_average,{#stat_multi_total_avg_cha}9:14,{#stat_multi_total_avg_cha}6:14,,,,,,#stat_average,{#stat_multi_total_avg}6:22,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("편차 절대값 반영,#cspan,#cspan,평균(대비율의 평균),#cspan,#cspan,,,,,,#stat_average,#stat_average,#stat_average,,#stat_cha_average,#stat_cha_average,,,,,,,#stat_average,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("편차 부호 반영,#cspan,#cspan,합계,#cspan,#cspan,,,,,,,,,#stat_total,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("편차 부호 반영,#cspan,#cspan,평균(평균금액 대 평균금액으로 계산),#cspan,#cspan,,,,,,,,,#stat_average,{#stat_multi_total_avg}9:14,{#stat_multi_total_avg}6:14,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("편차 부호 반영,#cspan,#cspan,평균(대비율의 평균),#cspan,#cspan,,,,,,,,,,#stat_average,#stat_average,#stat_average,#stat_average,,,,,,,,,,,,,,,,,,",["text-align:center;",,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.splitAt(6);
	//myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(true, 2000);
	//myGrid.enableDistributedParsing(true,5,50);     
    //myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    
    gridQString ="off_ls_stat_grid_sc_xml.jsp?dt=<%=dt%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun_nm=<%=gubun_nm%>&br_id=<%=br_id%>&s_au=<%=s_au%>";
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

<script language='javascript'>
<!--
	document.form1.avg_per1.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per1/use_cnt1), 2)%>';
	document.form1.avg_per2.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per2/use_cnt2), 2)%>';
	document.form1.avg_per3.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per3/use_cnt3), 2)%>';
	document.form1.avg_per4.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per4/use_cnt4), 2)%>';
//-->
</script>

</html>