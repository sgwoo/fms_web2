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
		<td style="text-align:center; width:100%;"> &lt;�縮�������������Ʈ&gt; </td>
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
</body>

<script type="text/javascript">
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//��0-32��(33��)
	myGrid.setHeader(",����, �����ȣ,"+  //1
			"����ȣ,�����,��ȣ,"+   //2
			"������ȣ,����,��,���ʵ����,����,��������Ÿ�,�����ڵ�,"+ //3
			"������ ���� 24���� �ܰ���,0 ���������ܰ�,0�����ܰ� ����<br>��� ����<br>0.������������<br>1.����������,"+ //4
			"0���� �����ܰ�<br>������,�����ܰ��� ����<br>�¼� (�ִ� 0.4),���� �߰���<br>�������,3�� ǥ������Ÿ�<br>(km),�ش� ����<br>ǥ������Ÿ�,�ش�����<br>ǥ������Ÿ�<br>�ݿ� �ܰ���,�ʰ� 10000km��<br>�߰�����<br>������,"+ //5
			"����/����Ÿ� �ݿ�<br>�����ڵ� �ܰ���,������ ����ȿ��,����Ұ� ���, "+ //6
			"�⺻��,�ɼ�,�ɼǰ���,����,�������,���󰡰�,�Һ��ڰ�,������<br>ȯ��Һ��ڰ�,"+ //7
			"����� �����հ�B<br>(���Խ�),������ȯ��<br>�����հ�B,���ӱ�<br>(�ɼ�����),�������,�����<br>���û��B,���Խ���<br>���Ҽ���,"+ //7-1
			"���Խ������Ҽ�<br>��������,���Խ���<br>���Ҽ� �ǰ����,������<br>���Ҽ���,���������Ҽ�<br>��������,������<br>���Ҽ� �ǰ����,"+ //7-2
			"�Ϲݽ¿�<br>LPG��<br>������<br>����,���԰�,�������� �ݿ���<br>��������,"+ //8
			"�����<br>��������,�Һ��ڰ� ���<br>����� ��������,�縮��������,�Һ��ڰ� ���<br>�縮��������,"+ //9
			"��������,#cspan,#cspan,#cspan,��ⷮ,"+ //10
			"����,�𵨿���,���ӱ�,ħ����<br>����,�����<br>��ü����,"+ //11
			"���Ⱓ,�뿩������,�뿩������,ǥ�ؾ�������Ÿ�,�縮�� �������<br>����ȿ��,"+ //12
			"ǥ���ִ��ܰ�,����������Ÿ�,�����ִ��ܰ�,���Կɼ�<br>�����ܰ�,���ԿɼǱݾ�,"+//13
			"�ܰ� �ݿ� ���� �� ��� 1,#cspan,�ܰ� �ݿ� ���� �� ��� 2,#cspan,�ܰ� �ݿ� ���� �� ��� 3,#cspan,�ܰ� �ݿ� ���� �� ��� 4,#cspan,"+ //14
			"�ܰ� �ݿ� ���� �� ��� 1,#cspan,�ܰ� �ݿ� ���� �� ��� 2,#cspan,�ܰ� �ݿ� ���� �� ��� 3,#cspan,�ܰ� �ݿ� ���� �� ��� 4,#cspan" //15
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
			"1��,2��,��ü,�Һ��ڰ����,#select_filter,"+//10
			"#select_filter,,,#select_filter,#select_filter,"+//11
			",,,,,"+//12
			",,,,,"+//13
			"�̸�,�������� �ݿ���,�̸�,�������� �ݿ���,�̸�,�������� �ݿ���,�̸�,�������� �ݿ���,"+//14
			"�̸�,�������� �ݿ���,�̸�,�������� �ݿ���,�̸�,�������� �ݿ���,�̸�,�������� �ݿ���,"//15
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