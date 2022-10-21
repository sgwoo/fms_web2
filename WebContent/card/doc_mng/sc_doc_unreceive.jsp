<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"> -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<title>카드전표관리</title>

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<!-- <script src="/fms2/lib/dhtmlx/dhtmlxgrid_export_link.js"></script> -->
<style type="text/css">
	html, body, form 	{
		height: 97%;
	}
	.navigation{
		margin:10px;
		font-size:12px;
		padding:8px;
		background-color:#f5f5f5;
		border:1px solid #cecece;
		border-radius:4px;
		margin-bottom:10px;
		padding-top:11px;
	}
	.style1 {
		color: #666666
	}
	.style5 {
		color: #ef620c; font-weight: bold;
	}
</style>
<!--Grid-->

<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript">
var gridQString = "";
</script>

</head>
<body leftmargin="15">
<form name='form1' action='client_mng_c.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='cardno' value=''>
	<input type='hidden' name='buy_id' value=''>
	<input type='hidden' name='idx' value='<%=idx%>'>
	<input type="hidden" name="cgs_ok" value="<%=cgs_ok%>">			
	<input type="hidden" name="card_user_id" value="">	
	<input type="hidden" name="selectValueList" id="selectValueList" value="0"/>
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
		<tr >
			<td colspan=6 style="height: 30px">
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td class="navigation">&nbsp;<span class=style1>재무회계 > 법인전표관리 > <span class=style5>미수신전표목록</span></span></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan=6  class=h></td>
		</tr>
	</table>

	<div id="gridbox" style="width:100%; height:98%; margin: 5px 0 5px 0;"></div>
	<table border=0 cellspacing=0 cellpadding=0 width=100% height=1%>	
	    <tr> 
	        <td align="left" style="font-size: 9pt;">
	            * 총 건수 : <span id="gridRowCount">0</span>건
	        </td>
			<div id="a_1" style="color:red;">Loading</div>
	    </tr>
	</table>
	
	
	</form>
	
</body>	

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//총0-19열(20개)
	
	myGrid.setHeader("연번,상태,카드번호,카드이름,거래일자,거래처,공급가,부가세,금액");
	myGrid.setInitWidthsP("4,5,15,15,8,*,8,8,8");
	myGrid.setColTypes("ron,ro,ro,ro,ro,ro,ron,ron,ron");
	myGrid.attachHeader("#rspan,총 건수,#cspan,{#stat_count}건,,,,,");
	myGrid.setColAlign("center,center,center,center,center,center,right,right,right");
	myGrid.enableTooltips("false,false,false,false,false,false,false,false,false");
	myGrid.setNumberFormat("0,000원",6);
	myGrid.setNumberFormat("0,000원",7);
	myGrid.setNumberFormat("0,000원",8);

	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){ 
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('해당하는 전표가 없습니다');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});
	
	myGrid.init();
	//eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;//link 타입에서 tooltip을 작동시킬 때 텍스트를 뜨게 하는 코드

	//myGrid.attachEvent("onCheckbox",doOnCheck);
	
	myGrid.attachFooter("합계,#cspan,#cspan,#cspan,#cspan,#cspan,#stat_total,#stat_total,#stat_total");
	
	myGrid.detachHeader(1);
	myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);  
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.enableSmartRendering(true, 2000);
    

    gridQString = "sc_doc_unreceive_xml.jsp";
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
