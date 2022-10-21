<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, java.net.*, acar.util.* " %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");	
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String jg_code 	= request.getParameter("jg_code")	==null?"":request.getParameter("jg_code");
	String car_nm 	= request.getParameter("car_nm")	==null?"":request.getParameter("car_nm");
	if(!car_nm.equals("")) car_nm = URLEncoder.encode(car_nm, "EUC-KR");
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

</head>
<body leftmargin="15">

<table style="width:100%;">
 	<tr>
		<td style="text-align:center;width:100%;"> &lt;���������������Ʈ&gt; (������� ����) </td>
 	</tr>
 	<tr>
 		<td><input type="button" class="button" name="auc_send" value="��Ż���Ʈ�� ���" onclick="javascript:sendAuction();"/></td>
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


<form name="popForm">
	<input type="hidden" name="start_dt" value='<%=start_dt%>'>
	<input type="hidden" name="end_dt" value='<%=end_dt%>'>
<!-- 	<input type="hidden" name="c_id[]" value="048177">
	<input type="hidden" name="c_id[]" value="048178">
	<input type="hidden" name="c_id[]" value="048179"> -->
</form>
</body>

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//��0-39��(40��)
	myGrid.setHeader(",����,�븮��,�����ȣ,��������,�����ڵ�,"+  //1
					"�������ڵ�,����,����,��ⷮ,���ӱ�,"+	//2
					"����,��,���ڵ�,�Ϸù�ȣ,������ȣ,����������ȣ,���ʵ����,"+	//3
					"�������,�Ϲݽ¿�<br>LPG��<br>������<br>����,�����Һ��ڰ�,�����ɼǰ�,��������,�����հ�ݾ�,"+		//4
					"���ް�,�ΰ���,�鼼��,����DC,������,"+ //5
					"�ɼ�,�������,�������,���Ͻ�����,��������,����ȣ,"+ //6
					"�����,��ȣ,���Ⱓ,�����ִ��ܰ�,���Կɼ�,"+ //7
					"������,��������,������,��������,���ô뿩��,"+ //8
					"���ô뿩�� ������,��������ݾ�,�������,���뿩��,"+ //9
					"���ʿ�����,�μ���,�������,�����ּ�,�����ȣ,"+ //10
					"�����̿���,�޴���,�̸����ּ�,��������Ÿ�,����������" //11
					);  
	
	myGrid.setInitWidths("40,50,90,150,70,90,"+ //1
					"100,140,90,90,80,"+ 		//2
					"80,220,90,90,100,105,100,"+		//3
					"80,80,110,90,80,100,"+		//4
					"90,90,90,90,90,"+			//5
					"320,140,160,160,100,120,"+		//6
					"100,140,70,90,70,"+		//7
					"100,80,100,70,100,"+		//8
					"90,100,90,100,"+			//9
					"90,80,80,350,140,"+		//10
					"90,110,200,100,80"			//11
					);
	
	myGrid.setColTypes("ch,ron,ro,ro,ro,ro,"+ //1
						"ro,ro,ro,ro,ro,"+
						"ro,ro,ro,ro,ro,ro,ro,"+	//3
						"ro,ro,ro,ro,ro,ro,"+
						"ro,ro,ro,ro,ro,"+	//5
						"ro,ro,ro,ro,ro,ro,"+
						"ro,ro,ro,ro,ro,"+	//7
						"ro,ro,ro,ro,ro,"+
						"ro,ro,ro,ro,"+	//9
						"ro,ro,ro,ro,ro,"+
						"ro,ro,ro,ro,ro" //11
			);
	myGrid.attachHeader(
						"#master_checkbox,,#select_filter,,#select_filter,,"+
						",#text_filter,#select_filter,,#select_filter,"+
						"#select_filter,#text_filter,,,#text_filter,,,"+
						",,,,,,"+
						",,,,,"+
						"#text_filter,,,,,,"+
						",,,,,"+
						",,,,,"+
						",,,,"+
						",,,,,"+
						",,,,,"
			);
	//myGrid.attachHeader(",,,,,,,,,,,,,,,,,,,,,,,,,",[,,,,,,,,,,,,,,,,,,,,,,,,,]);
    myGrid.setColAlign(	"center,center,center,center,center,center,"+
	   					"center,center,center,center,center,"+
	   					"center,center,center,center,center,center,center,"+
	   					"center,center,center,center,center,center,"+
	   					"center,center,center,center,center,"+
	   					"center,center,center,center,center,center,"+
	   					"center,center,center,center,center,"+
	   					"center,center,center,center,center,"+
	   					"center,center,center,center,"+
	   					"center,center,center,left,center,"+
	   					"center,center,left,center,center"
    					);
	
    myGrid.enableTooltips("false,false,false,false,false,false,"+ //1
    				"false,false,false,false,false,"+
    				"false,false,false,false,false,false,false,"+	//3
    				"false,false,false,false,false,false,"+
    				"false,false,false,false,false,"+	//5
    				"false,false,false,false,false,false,"+
    				"false,false,false,false,false,"+	//7
    				"false,false,false,false,false,"+
    				"false,false,false,false,"+	//9
    				"false,false,false,false,false,"+
    				"false,false,false,false,false"			//11
		);
	//myGrid.enableCSVAutoID(true);
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

	//myGrid.splitAt(4);
	myGrid.detachHeader(2);
	myGrid.enableBlockSelection(true);
    myGrid.enableMathEditing(true); 
	myGrid.enableColumnMove(true);   
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    //myGrid.enableSmartRendering(true, 2000);
    myGrid.enableSmartRendering(false);
    //myGrid.parse(data,"json");
	
    myGrid.setColSorting("int,str,str,str,str,"+ //1
	    		"str,int,int,str,str,"+
	    		"str,str,str,str,str,str,str,"+//3
	    		"int,str,int,str,str,int,"+
	    		"int,int,int,int,int,"+//5
	    		"str,str,str,str,str,str,"+
	    		"str,str,int,int,int,"+ //7
	    		"int,int,int,int,int,"+
	    		"int,int,int,int,"+ //9
	    		"str,str,str,str,str,"+ 
	    		"str,str,str,int,str"
    		);
    

	gridQString = "inside_list8_2_xml.jsp?start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&jg_code=<%=jg_code%>&car_nm=<%=car_nm%>";
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
				
				var popForm = document.popForm;
				$(popForm).append($('<input/>', {type: 'hidden', name: 'c_id[]', value:rId, id:rId }));
			}
		}else{
			id.pop(rId);
			$('#' + rId).remove();
		}
	});
	
	
	var start_dt = '<%=start_dt%>';
	var end_dt = '<%=end_dt%>';
	
	function sendAuction(){
		var popForm = document.popForm;

		var url = 'inside_list8_2_send.jsp';
		//window.open("", "popForm", "VIEW_CLIENT", "left=100, top=100, width=500, height=300, scrollbars=yes");
		popForm.action = url;
		popForm.method = 'post';
		popForm.target = 'popForm';
		popForm.testVal = 'test';
		popForm.submit();
		
		//window.open("inside_list8_2_send.jsp?c_id="+id+"&start_dt="+start_dt+"&end_dt="+end_dt, "VIEW_CLIENT", "left=100, top=100, width=500, height=300, scrollbars=yes");
		//window.open("inside_list8_send.jsp?c_id="+id+"&start_dt="+start_dt+"&end_dt="+end_dt, "VIEW_CLIENT", "left=100, top=100, width=500, height=300, scrollbars=yes");
		//location.href = 'auction_send.jsp?c_id='+id;
	} 

</script>
</html>