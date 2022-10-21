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
<style>
br { mso-data-placement:same-cell; }
</style>

</head>
<body leftmargin="15">

<table style="width:100%;">
 	<tr>
		<td style="text-align:center; width:100%;"> &lt;재리스계약차량리스트&gt; </td>
 	</tr>
 	<tr>
 		<td><input type="button" class="button" name="auc_send" value="경매사이트에 등록" onclick="javascript:sendAuction();"/></td>
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
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-32열(33개)
	myGrid.setHeader(",연번, 차대번호,"+  //1
			"계약번호,계약일,상호,"+   //2
			"차량번호,차명,모델,최초등록일,차령,적용주행거리,차종코드,"+ //3
			"현시점 차령 24개월 잔가율,0 개월기준잔가,0개월잔가 적용<br>방식 구분<br>0.조정율미적용<br>1.조정율적용,"+ //4
			"0개월 기준잔가<br>조정율,최저잔가율 조정<br>승수 (최대 0.4),현재 중고차<br>경기지수,3년 표준주행거리<br>(km),해당 차령<br>표준주행거리,해당차령<br>표준주행거리<br>반영 잔가율,초과 10000km당<br>중고차가<br>조정율,"+ //5
			"차령/주행거리 반영<br>차종코드 잔가율,현시점 수출효과,수출불가 사양, "+ //6
			"기본가,옵션,옵션가격,색상,내장색상,색상가격,소비자가,계약시점<br>환산소비자가,"+ //7
			"경매장 차가합계B<br>(구입시),계약시점환산<br>차가합계B,변속기<br>(옵션포함),구동방식,경매장<br>선택사양B,구입시점<br>개소세율,"+ //7-1
			"구입시점개소세<br>과세여부,구입시점<br>개소세 실감면액,계약시점<br>개소세율,계약시점개소세<br>과세여부,계약시점<br>개소세 실감면액,"+ //7-2
			"일반승용<br>LPG차<br>과세가<br>여부,구입가,사고수리비 반영전<br>예상낙찰가,"+ //8
			"경매장<br>예상낙찰가,소비자가 대비<br>경매장 예상낙찰가,재리스잔존가,소비자가 대비<br>재리스잔존가,"+ //9
			"사고수리비,#cspan,#cspan,#cspan,배기량,"+ //10
			"연료,모델연도,변속기,침수차<br>여부,계기판<br>교체여부,"+ //11
			"계약기간,대여개시일,대여만료일,표준약정주행거리,재리스 종료시점<br>수출효과,"+ //12
			"표준최대잔가,계약약정주행거리,조정최대잔가,매입옵션<br>적용잔가,매입옵션금액,"+//13
			"잔가 반영 색상 및 사양 1,#cspan,잔가 반영 색상 및 사양 2,#cspan,잔가 반영 색상 및 사양 3,#cspan,잔가 반영 색상 및 사양 4,#cspan,"+ //14
			"잔가 반영 색상 및 사양 1,#cspan,잔가 반영 색상 및 사양 2,#cspan,잔가 반영 색상 및 사양 3,#cspan,잔가 반영 색상 및 사양 4,#cspan" //15
			);  
	myGrid.setInitWidths("40,50,140,"+  //1
			"160,80,160,"+//2
			"80,130,250,90,90,100,80,"+//3
			"80,80,80,"+//4
			"80,80,80,80,80,80,80,"+//5
			"160,160,160,"+//6
			"90,400,80,200,100,100,100,100,"+//7
			"120,100,100,100,100,100,"+//7-1
			"130,120,100,120,140,"+//7-2
			"80,90,100,"+//8
			"110,130,130,130,"+//9
			"80,80,80,100,80,"+//10
			"80,80,80,60,70,"+//11
			"80,80,80,160,160,"+ //12
			"80,160,80,80,80,"+ //13
			"160,120,160,120,160,120,160,120,"+ //14
			"160,120,160,120,160,120,160,120" //15
			);
	myGrid.setColTypes("ch,ron,ro,"+
 			"ro,ro,ro,"+
			"ro,ro,ro,ro,ro,ro,ro,"+
			"ro,ro,ro,"+
			"ro,ro,ro,ro,ro,ro,ro,"+ //5
			"ro,ro,ro,"+
			"ro,ro,ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,ro,ro,ro"
			); 
	 
	myGrid.enableTooltips("false,false,false,"+
					"false,false,false,"+
					"false,false,false,false,false,false,false,"+
					"false,false,false,"+
					"false,false,false,false,false,false,false,"+ //5
					"false,false,false,"+
					"false,false,false,false,false,false,false,"+ //7
					"false,false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,false,false,false,"+
					"false,false,false,false,false,false,false,false"
			);
	
	myGrid.setColSorting("na,int,str,"+
			"str,str,str,"+
			"str,str,str,str,str,str,str,"+
			"str,str,str,"+
			"str,str,str,str,str,str,str,"+ //5
			"str,str,str,"+
			"str,str,str,str,str,str,str,"+
			"str,str,str,str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,str,str,str,"+
			"str,str,str,str,str,str,str,str"
	);
	
	myGrid.attachHeader("#master_checkbox,, ,"+  //1
			",#select_filter, ,"+//2
			"#text_filter,#text_filter,#text_filter,#text_filter,,,#select_filter,"+ //3
			",,,"+ //4
			",,,,,,, "+//5
			",,,"+//6
			",#select_filter,,#select_filter,#select_filter,,,"+ //7
			",,,,,,"+ //7
			",,,,,"+ //7
			",,,"+ //8
			",,,,,"+//9
			"1위,2위,전체,소비자가대비,#select_filter,"+//10
			"#select_filter,,,#select_filter,#select_filter,"+//11
			",,,,,"+//12
			",,,,,"+//13
			"이름,현재차령 반영값,이름,현재차령 반영값,이름,현재차령 반영값,이름,현재차령 반영값,"+//14
			"이름,만료차령 반영값,이름,만료차령 반영값,이름,만료차령 반영값,이름,만료차령 반영값,"//15
			);
	
	//myGrid.attachHeader(",,,,,,,,,,,,,,,,,,,,,,,,,",[,,,,,,,,,,,,,,,,,,,,,,,,,]);
    myGrid.setColAlign("center,center,center,"+
    		"center,center,center,"+
    		"center,center,center,center,center,center,center,"+
    		"center,center,center,"+
    		"center,center,center,center,center,center,center,"+ //5
    		"center,center,center,"+
    		"center,center,center,center,center,center,center,"+
    		"center,center,center,center,center,center,"+
    		"center,center,center,center,center,"+
    		"center,center,center,"+
    		"center,center,center,center,center,"+
    		"center,center,center,center,center,"+
    		"center,center,center,center,center,"+
    		"center,center,center,center,center,"+
    		"center,center,center,center,center,"+
    		"center,center,center,center,center,center,center,center,"+
    		"center,center,center,center,center,center,center,center"
    		);
    
     
     
	
	
    //myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	//myGrid.attachEvent("onXLE",function(){ document.getElementById("a_1").style.display="none"; });	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

		//myGrid.splitAt(4);
	myGrid.detachHeader(2);
	myGrid.enableBlockSelection(true);
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
    myGrid.forceLabelSelection(true);
 //   mygrid.enableMultiline(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.enableSmartRendering(true, 2000);
    //myGrid.enableSmartRendering(false);
 //  myGrid.parse(data,"json");
	
    gridQString = "inside_list10_xml.jsp?start_dt=<%=start_dt%>&end_dt=<%=end_dt%>";
    myGrid.load(gridQString);	    

    var id = []; 

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
	
	function hasDuplicates(rId, array) { 
	    for (var i = 0; i < array.length; ++i) { 
		     if (array[i] ==rId) {         
		      return true; 
		     } 
	    } 
	    return false; 
	}
	
	myGrid.attachEvent("onCheckbox", function(rId,cInd,state){
		if(state){
			if(!hasDuplicates(rId,id)){
				id.push(rId);
			}
		}else{
			id.pop(rId);
		}
	});
	
	var start_dt = '<%=start_dt%>';
	var end_dt = '<%=end_dt%>';
	
	function sendAuction(){
		window.open("inside_list10_send.jsp?c_id="+id+"&start_dt="+start_dt+"&end_dt="+end_dt, "VIEW_CLIENT", "left=100, top=100, width=500, height=300, scrollbars=yes");
		//location.href = 'auction_send.jsp?c_id='+id;
	} 

</script>

</html>