<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String search_start 	= request.getParameter("search_start")==null?"":request.getParameter("search_start");
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>ī����ǥ����</title>

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
</style>
<!--Grid-->

<script language='JavaScript' src='/include/common.js'></script>

<script language='javascript'>
	//��ȳѱ��
	function doc_card_change(){
		var fm = document.form1;	
		var len=fm.elements.length;
		//var cnt=0;
		var cnt=getElementById("selectValueList").value;
		if(cnt == 0){ alert("1���̻� �����ϼ���."); return; }
		
		fm.target = "_blank";
		fm.action = "card_change_many.jsp";
		fm.submit();	
	}	

//sc_in���� �Ѿ�� ��
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	

	
	//ī�峻�뺸��
	function CardDocUpd(cardno, buy_id, doc_mng_id, buy_user_id, card_user_id){
		var fm = document.form1;
		if(fm.auth_rw.value == '6' || fm.auth_rw.value == '4'){	
	//		if(fm.user_id.value == doc_mng_id || fm.user_id.value == buy_user_id || fm.user_id.value == '000029' || fm.user_id.value == '000003' || fm.user_id.value == '000004' || fm.user_id.value == '000006' || fm.user_id.value == '000005'){		
				fm.cardno.value = cardno;
				fm.buy_id.value = buy_id;	
				fm.card_user_id.value = card_user_id;		
				fm.action = "sc_doc_reg_u.jsp";
				window.open("about:blank", "CardDocView", "left=20, top=50, width=1200, height=800, scrollbars=yes, status=yes");
				fm.target = "CardDocView";
				fm.submit();
	//		}else{
	//			alert('�ش���ǥ�� ����� Ȥ�� �����ڰ� �ƴմϴ�.');
	//		}
		}else{
			fm.cardno.value = cardno;
			fm.buy_id.value = buy_id;
			fm.card_user_id.value = card_user_id;				
			fm.action = "doc_reg_s.jsp";
			window.open("about:blank", "CardDocView", "left=20, top=50, width=1200, height=800, scrollbars=yes, status=yes");
			fm.target = "CardDocView";
			fm.submit();
		//	alert('������ �����ϴ�.');
		}		
	}
	
	function cgs_reg(cardno, buy_id){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.buy_id.value = buy_id;		
		fm.action = "./cgs_ok.jsp";	
		window.open("", "cgs_Reg", "left=10, top=20, width=100, height=100, scrollbars=no");
		fm.target = "cgs_Reg";
		fm.submit();
	}
	
	function CardDocHistory(ven_code, cardno, buy_id){
		var fm = document.form1;
		window.open("../doc_reg/vendor_carddoc_nowyear_history.jsp?ven_code="+ven_code+"&cardno="+cardno+"&buy_id="+buy_id, "VENDOR_DOC_LIST", "left=10, top=10, width=950, height=600, scrollbars=yes");				
	}		
	
	
	

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
	<input type="hidden" name="search_start" id="search_start" value="<%=search_start%>">	
	<input type="hidden" name="selectValueList" id="selectValueList" value="0"/>

	<div id="gridbox" style="width:100%; height:100%; margin: 5px 0 5px 0;"></div>
	<table border=0 cellspacing=0 cellpadding=0 width=100% height=1%>	
	    <tr> 
	        <td align="left" style="font-size: 9pt;">
	            * �� �Ǽ� : <span id="gridRowCount">0</span>��
	        </td>
			<div id="a_1" style="color:red;">Loading</div>
	    </tr>
	</table>
	
	
	</form>
	
</body>	

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//��0-19��(20��)
	
	myGrid.setHeader("#master_checkbox,����,����,ī���ȣ,������,�����,�ŷ�����,�ŷ�ó,��������,���ް�,�ΰ���,�ݾ�,��������,����,����,�����,�������,������,��������,");
	myGrid.setInitWidths("35,35,50,150,65,65,85,180,80,110,110,110,105,105,105,65,85,65,85,0");
	myGrid.setColTypes("ch,ron,ro,ro,ro,ro,ro,link,link,ron,ron,ron,ro,ro,ro,ro,ro,ro,ro,ron");
	myGrid.attachHeader("#rspan,#rspan,#rspan,#text_filter,#rspan,#rspan,#rspan,#text_filter,#rspan,#rspan,#rspan,#rspan,#select_filter,#select_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,#rspan");
	myGrid.attachHeader("#rspan,#rspan,�� �Ǽ�,#cspan,{#stat_count}��,,,,,,,,,,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,,,,,,,,]);
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,right,right,right,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,false,false,false,true,false,false,false,false,true,true,true,false,false,false,false,false");
	myGrid.setColumnHidden(19,true);
	myGrid.setNumberFormat("0,000��",9);
	myGrid.setNumberFormat("0,000��",10);
	myGrid.setNumberFormat("0,000��",11);

	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){ 
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			//alert('�ش��ϴ� ��ǥ�� �����ϴ�');
			if (document.getElementById("search_start").value == "Y") {
				alert('�ش��ϴ� ��ǥ�� �����ϴ�');	
			}
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;//link Ÿ�Կ��� tooltip�� �۵���ų �� �ؽ�Ʈ�� �߰� �ϴ� �ڵ�

	myGrid.attachEvent("onCheckbox",doOnCheck);
	
	myGrid.attachFooter("�հ�,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,,#stat_total,#stat_total,#stat_total,,,,,,,,",["text-align:right;",,,,,,,,"text-align:right;","text-align:right;","text-align:right;",,,,,,,]);
	
	myGrid.detachHeader(2);
	myGrid.splitAt(8);
	myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);  
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.enableSmartRendering(true, 2000);
    

    gridQString = "sc_doc_mng_xml.jsp<%=hidden_value%>";
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
	
	function doOnCheck(rowId, celllnd, state){

	    var selectedValue = myGrid.cells(rowId,19).getValue();
	    var value = "";
	    var cnt = parseInt($('#selectValueList').val());
	    
	    if(state == true){ //üũ�ڽ� check �Ǿ�����
	        $('#selectValueList').val(cnt+1);
	        $('#gridForm').append("<input type='hidden' name='pr' value='"+selectedValue+"' id='"+selectedValue+"'/>");

	    }else{ //üũ�ڽ� check �����Ǹ�
	        $('#selectValueList').val(cnt-1);
	        $('#'+selectedValue).remove();
	    }
	}

	
</script>

</html>
