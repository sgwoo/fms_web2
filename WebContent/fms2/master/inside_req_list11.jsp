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

<script language='javascript'>


</script>
<style>
br { mso-data-placement:same-cell; }
.button {
    text-align: center;
    cursor: pointer;
}

</style>

</head>
<body leftmargin="15">

<table style="width:100%;">
 	<tr>
		<td style="text-align:center; width:100%;"> &lt;경매낙찰차량리스트&gt; </td>
 	</tr>
 	<tr>
  	   <!-- <td style="text-align:left;"> <a href="javascript:sendAuction();"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;</td>  -->
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
	myGrid.setHeader(",연번,경매일자,경매장,경매회차,출품번호,"+  //1 5
			"차량번호,차명,모델,최초등록일,차령,적용주행거리,차종코드,"+ //2 7
			"현시점 차령 24개월 잔가율,0 개월<br>기준잔가,0개월잔가 적용<br>방식 구분<br>0.조정율미적용<br>1.조정율적용,"+ //3 3
			"0개월 기준잔가<br>조정율,최저잔가율 조정<br>승수 (최대 0.4),현재 중고차<br>경기지수,3년 표준주행거리<br>(km),초과 10000km당<br>중고차가<br>조정율,"+ //4 5
			"해당 차령<br>표준주행거리,해당 차령<br>표준주행거리<br>반영 잔가율,차령/주행거리 반영<br>차종코드 잔가율,현시점 수출효과,수출불가 사양, "+ //5  3
			"기본가,옵션,옵션가격,색상,내장색상,색상가격,소비자가,"+ //6 7
			"계약시점환산<br>소비자가,경매장 차가합계B<br>(구입시),계약시점환산<br>차가합계B,변속기<br>(옵션포함),구동방식,경매장<br>선택사양B,"+ //6-1 6
			"구입시점<br>개소세율,구입시점개소세<br>과세여부,구입시점개소세<br>실감면액,낙찰시점<br>개소세율,낙찰시점개소세<br>과세여부,낙찰시점<br>개소세 실감면액,"+ //6-2 6
			"일반승용<br>LPG차<br>과세가<br>여부,구입가,희망가,사고수리비 반영전<br>예상낙찰가,"+ //7 4
			"예상낙찰가,소비자가 대비<br>예상낙찰가,"+ //8 4
			"매각,#cspan,#cspan,#cspan,#cspan,"+//9 5
			"#cspan,#cspan,명의이전구분, 경매장평점, 사고유무,"+//10 5
			"사고수리비,#cspan,#cspan,#cspan,낙찰자,"+ //11 5
			"배기량,연료,모델연도,변속기,평가요인,침수차<br>여부,"+ //12  5
			"계기판<br>교체여부,변경전<br>차량번호,유찰횟수,"+ //13 2
			"잔가 반영 색상 및 사양 1,#cspan,잔가 반영 색상 및 사양 2,#cspan,잔가 반영 색상 및 사양 3,#cspan,잔가 반영 색상 및 사양 4,#cspan,car_id,car_seq" //15 8
			);  
	myGrid.setInitWidths("40,50,90,150,90,90,"+  //1 
			"80,130,250,90,90,100,80,"+//2 7
			"100,100,110,"+//3 3
			"100,100,100,100,100,"+//4 5
			"100,100,160,160,160,"+//5 3
			"90,400,80,200,100,100,100,"+//6 7
			"100,140,100,90,90,400,"+//6-1
			"90,120,120,90,120,120,"+//6-2 6
			"80,90,90,140,"+//7  4
			"130,130,"+//8 2
			"80,80,80,100,90,"+//9
			"100,100,80,60,70,"+//10
			"80,80,80,80,150,"+ //11
			"90,90,80,80,500,80,"+ //12
			"80,80,80,"+ //13
			"160,120,160,120,160,120,160,120,60,60" //15
			);
 	myGrid.setColTypes("ch,ron,ro,ro,ro,ro,"+ //1
			"ro,ro,ro,ro,ro,ro,ro,"+
			"ro,ro,ro,"+ //3
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+ //5
			"ro,ro,ro,ro,ro,ro,ro,"+ //6
			"ro,ro,ro,ro,ro,ro,ro,"+ //6-1
			"ro,ro,ro,ro,ro,ro,ro,"+ //6-2
			"ro,ro,ro,ro,"+ //7
			"ro,ro,"+
			"ro,ro,ro,ro,ro,"+ //9
			"ro,ro,ro,ro,ro,"+
			"ro,ro,ro,ro,ro,"+ //11
			"ro,ro,ro,ro,ro,ro,"+
			"ro,ro,ro,"+ //13
			"ro,ro,ro,ro,ro,ro,ro,ro,ro,ro"
			); 
	  
 	myGrid.enableTooltips("false,false,false,false,false,false,"+ //1
					"false,false,false,false,false,false,false,"+ //2
					"false,false,false,"+ //3
					"false,false,false,false,false,"+
					"false,false,false,false,false,"+
					"false,false,false,false,false,false,false,"+ //6
					"false,false,false,false,false,false,"+ //6-1
					"false,false,false,false,false,false,"+ //6
					"false,false,false,false,"+ 
					"false,false,"+ //8 
					"false,false,false,false,false,"+ 
					"false,false,false,false,false,"+ //10
					"false,false,false,false,false,"+
					"false,false,false,false,false,false,"+ //12 
					"false,false,false,"+ 
					"false,false,false,false,false,false,false,false,false,false" //15
			);
	 
 	myGrid.setColSorting("na,int,str,str,int,int,"+  //1
			"str,str,str,str,str,str,str,"+ //2
			"str,str,str,"+ //3
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+//5
			"str,str,str,str,str,str,str,"+
			"str,str,str,str,str,str,"+ //6-1
			"str,str,str,str,str,str,"+
			"str,str,str,str,"+
			"str,str,"+
			"str,str,str,str,str,"+
			"str,str,str,str,str,"+ //10
			"str,str,str,str,str,"+
			"str,str,str,str,str,str,"+ //12
			"str,str,str,"+
			"str,str,str,str,str,str,str,str,str,str" //15
	); 
	
 	myGrid.attachHeader("#master_checkbox,,,,,,"+  //1
			"#text_filter,#text_filter,#text_filter,#text_filter,,,#select_filter,"+ //2
			",,,"+ //3
			",,,,, "+//4
			",,,,,"+//5
			",#select_filter,,#select_filter,#select_filter,,,"+ //6
			",,,,,#select_filter,"+ //6-1
			",,,,,,"+ //6-2
			",,,,"+ //7
			",,"+//8
			"낙찰가,소비자가<br>대비,구입가 대비,예상 낙찰가<br>대비,편차금액,"+//9
			"편차%(예<br>상낙찰가<br>기준),편차%(소<br>비자가<br>기준),,,,"+//10
			"1위,2위,전체,소비자가대비,#select_filter,"+//11
			"#select_filter,,,,#select_filter,#select_filter,"+//12
			",,,"+//13
			"이름,현재차령 반영값,이름,현재차령 반영값,이름,현재차령 반영값,이름,현재차령 반영값,,"//15
			); 
	
	//myGrid.attachHeader(",,,,,,,,,,,,,,,,,,,,,,,,,",[,,,,,,,,,,,,,,,,,,,,,,,,,]);
    myGrid.setColAlign("center,center,center,center,center,center,"+ //1
    		"center,center,center,center,center,center,center,"+//2
    		"center,center,center,"+ //3
    		"center,center,center,center,center,"+//4
    		"center,center,center,center,center,"+ //5
    		"center,center,center,center,center,center,center,"+ //6
    		"center,center,center,center,center,center,"+ //6
    		"center,center,center,center,center,center,"+ //6
    		"center,center,center,center,"+//7
    		"center,center,"+//8
    		"center,center,center,center,center,"+//9
    		"center,center,center,center,center,"+//10
    		"center,center,center,center,center,"+ //11
    		"center,center,center,center,center,center,"+ //12
    		"center,center,center,"+ //13
    		"center,center,center,center,center,center,center,center,center,center" //15
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
	
    gridQString = "inside_list11_xml.jsp?start_dt=<%=start_dt%>&end_dt=<%=end_dt%>";

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
		window.open("inside_list11_send.jsp?c_id="+id+"&start_dt="+start_dt+"&end_dt="+end_dt,  "VIEW_CLIENT", "left=100, top=100, width=500, height=300, scrollbars=yes");
		//location.href = 'auction_send.jsp?c_id='+id;
	} 
	

</script>

</html>