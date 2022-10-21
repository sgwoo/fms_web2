<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.off_anc.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun_1 = request.getParameter("gubun_1")==null?"":request.getParameter("gubun_1");
	String gubun_2 = request.getParameter("gubun_2")==null?"":request.getParameter("gubun_2");
	
	String vlaus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
									"&gubun1="+gubun1+"&gubun_1="+gubun_1+"&gubun2="+gubun2+"&gubun_2="+gubun_2+"";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//String jobjString =  oad.getAncAllJSON(gubun, gubun_nm, gubun1, ck_acar_id);
	String jobjString =  oad.getAncAllJSON2(gubun1, gubun_1, gubun2, gubun_2, gubun3, ck_acar_id);	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

<title>FMS</title>

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="../lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="../lib/dhtmlx/skins/web/dhtmlxgrid.css"/>
<script src="../lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="../lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<!--Grid-->
<style>
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothic.css);
@import url(//cdn.jsdelivr.net/font-nanum/1.0/nanumbarungothic/nanumbarungothiclight.css);
@font-face {
    font-family: 'icomoon';
    src:    url('../lib/fonts/icomoon.eot?rtmp4o');
    src:    url('../lib/fonts/icomoon.eot?rtmp4o#iefix') format('embedded-opentype'),
        url('../lib/fonts/icomoon.ttf?rtmp4o') format('truetype'),
        url('../lib/fonts/icomoon.woff?rtmp4o') format('woff'),
        url('../lib/fonts/icomoon.svg?rtmp4o#icomoon') format('svg');
    font-weight: normal;
    font-style: normal;
}
[class^="icon-"], [class*=" icon-"] {
    /* use !important to prevent issues with browser extensions that change fonts */
    font-family: 'icomoon' !important;
    speak: none;
    font-style: normal;
    font-weight: normal;
    font-variant: normal;
    text-transform: none;
    line-height: 1;
    /* Better Font Rendering =========== */
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}
.icon-star:before 	{	content: "\f005";	}
.icon-star-o:before {	content: "\f006";}
.icon-star			{	color: rgba(255, 136, 0, 1);}
.icon-star-o		{	color: #ddd;}
img[src=""] 		{	display: none;}
</style>
<script type="text/javascript">

function AncDisp(bbs_id, st){
	var fm = document.form1;
	fm.bbs_id.value = bbs_id;		
	fm.action = 'anc_se_c.jsp';
	if(st == '5')	fm.action = 'anc_c2.jsp';
	fm.target = "d_content";
	//fm.submit();
	
	if(st == '5'){
		var SUBWIN="./anc_c2.jsp<%=vlaus%>&bbs_id="+bbs_id+"&bbs_st="+st+"&ck_acar_id=<%=ck_acar_id%>";	
	}else{
		var SUBWIN="./anc_se_c.jsp<%=vlaus%>&bbs_id="+bbs_id+"&bbs_st="+st+"&ck_acar_id=<%=ck_acar_id%>";
		<%if(ck_acar_id.equals("000029")){%>
		SUBWIN="./anc_se_c.jsp<%=vlaus%>&bbs_id="+bbs_id+"&bbs_st="+st+"&ck_acar_id=<%=ck_acar_id%>";
		<%}%>			
	}
	window.open(SUBWIN, "AncDisp", "left=10, top=10, width=1024, height=800, scrollbars=yes");

}

function parsingGridData(){
	
	var data = jQuery.parseJSON('<%=jobjString%>');
    mygrid(data);
}

function mygrid(data){
      
      myGrid = new dhtmlXGridObject('gridbox');
      myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");            

      myGrid.setHeader("#master_checkbox,����,MY,�߿�,����,ī�װ�,����,Ű����,�����,�μ�,�����,������,���");
      myGrid.setInitWidthsP("3,4,3,3.5,3.5,8,*,8,8,9,8,8,5"); 	      
      myGrid.setColSorting("str,int,str,str,str,str,str,str,str,str,str,str,int");	      
      myGrid.setColTypes("ch,ro,img,ro,img,ro,link,ro,ro,ro,ro,ro,ro");
      myGrid.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#select_filter,#text_filter,#text_filter,#select_filter,#select_filter,#text_filter,#text_filter,#rspan", ["padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;","padding:5px;",, ] );
      myGrid.setColAlign("center,center,center,center,center,center,left,left,center,center,center,center,center"); 	
      myGrid.enableTooltips("false,false,false,false,false,false,false,false,false,false,false,false,false");
      //myGrid.setColumnHidden(12,true);
      myGrid.enableAutoWidth(true);
      myGrid.init();
      eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
      myGrid.setSizes();
      myGrid.enableBlockSelection();
      myGrid.attachEvent("onCheckbox",doOnCheck);
      myGrid.attachEvent("onKeyPress",onKeyPressed);
      myGrid.enableRowspan(false);
      myGrid.enableColumnMove(false);                  
      myGrid.enableSmartRendering(false);
      myGrid.forceLabelSelection(true);
      myGrid.parse(data,"json");					

}
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

function AncReg(){
	var SUBWIN="./anc_se_i.jsp?ck_acar_id=<%=ck_acar_id%>";
	<%if(ck_acar_id.equals("000029")){%>
	SUBWIN="./anc_se_i.jsp?ck_acar_id=<%=ck_acar_id%>";
	<%}%>
	window.open(SUBWIN, "AncReg", "left=10, top=10, width=1024, height=800, scrollbars=yes");
}

//üũ�ڽ� ����,������ �������� ����
function doOnCheck(rowId, celllnd, state){
    var selectedValue = myGrid.cells(rowId,12).getValue();
    var str = $('#selectValueList').val();
    if(state == true){ //üũ�ڽ� check �Ǿ�����
        $('#selectValueList').val(str+","+selectedValue);
    }else{ //üũ�ڽ� check �����Ǹ�
	    var value = "";
    	if(str!=""){
	        var str_arr = str.split(',');
	    	for(var i=0; i<str_arr.length;i++){
	    		if(str_arr[i]!="" && str_arr[i]!=selectedValue){
	    			value += ","+str_arr[i];
	    		}
	    	}
    	}
    	$('#selectValueList').val(value);
    	parent.form.params.value = $('#selectValueList').val(); 
    }
}

//���� �������� �ϰ� �߰�
function addMyBbsAll(){
	var params = $("#selectValueList").val();
	if(params!=''){
		var user_id = '<%=user_id%>';
		if(confirm("���ǰ������׿� �ϰ��߰� �Ͻðڽ��ϱ�?")==true){
			window.open("my_anc_a.jsp?user_id=<%=user_id%>&params="+params+"&mode=MIA", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
		}
	}else{	alert("�ϰ��߰� �� ���������� �����Ͻʽÿ�.");	}
}

//���� �������� �ϰ� ����
function dropMyBbsAll(){
	var params = $("#selectValueList").val();
	if(params!=''){
		if(confirm("���ǰ������׿��� �ϰ����� �Ͻðڽ��ϱ�?")==true){
			window.open("my_anc_a.jsp?user_id=<%=user_id%>&params="+params+"&mode=MDA", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
		}
	}else{	alert("�ϰ����� �� ���������� �����Ͻʽÿ�.");	}
}

//�߿� �������� �ϰ� �߰� (20181121)
function addImportBbsAll(){
	var params = $("#selectValueList").val();
	if(params!=''){
		var user_id = '<%=user_id%>';
		if(confirm("�߿������������ �ϰ����� �Ͻðڽ��ϱ�?")==true){
			window.open("my_anc_a.jsp?user_id=<%=user_id%>&params="+params+"&mode=IIA", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
		}
	}else{	alert("�ϰ��߰� �� ���������� �����Ͻʽÿ�.");	}
}

//�߿� �������� �ϰ� ���� (20181121)
function dropImportBbsAll(){
	var params = $("#selectValueList").val();
	if(params!=''){
		if(confirm("�߿�������׿��� �ϰ����� ���� �Ͻðڽ��ϱ�?")==true){
			window.open("my_anc_a.jsp?user_id=<%=user_id%>&params="+params+"&mode=IDA", "MY_ANC", "left=10, top=10, width=620, height=250, scrollbars=no, status=yes, resizable=no");
		}
	}else{	alert("�ϰ����� �� ���������� �����Ͻʽÿ�.");	}
}

function impor_yn_view(){
	$(".impor_Y").addClass('icon-star');
	//$(".impor_N").addClass('icon-star-o');
}

</script>
</head>
<body onload="javascript:parsingGridData(); impor_yn_view();"> 
<!-- <div id="gridbox" style="width:98%;min-height:95%; margin:0px; background-color:white;"></div>  -->
<table width="100%">
	<tr>
		<td width="70%">
		<%if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("�̻�",user_id)||nm_db.getWorkAuthUser("�����ѹ�����",user_id)
			 ||nm_db.getWorkAuthUser("���翵������",user_id)||nm_db.getWorkAuthUser("���翵����ȹ����",user_id)||nm_db.getWorkAuthUser("�����������",user_id)
			 ||nm_db.getWorkAuthUser("���翵��������",user_id)||nm_db.getWorkAuthUser("����",user_id)){ %>
			<b>�߿� ��������</b>&nbsp;
			<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:addImportBbsAll();">�ϰ�����</a>
			<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:dropImportBbsAll();">�ϰ�����</a>
			&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
		<%}%>
			<b>���� ��������</b>&nbsp;
			<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:addMyBbsAll();">�ϰ��߰�</a>
			<a class="button" style="font-size: 12px; padding:3.5px;" onclick="javascript:dropMyBbsAll();">�ϰ�����</a>
		</td>
		<td width="30%" align='right'>
			<a href='javascript:AncReg()' onMouseOver="window.status=''; return true" style="padding-right: 25px;"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
</table>		
<div id="gridbox" style="width:98%;height:650px;"></div>
<form action="" name="form1" method="post">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type='hidden' name='user_id' 	value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun_1" value="<%=gubun_1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun_2" value="<%=gubun_2%>">
	<input type="hidden" name="bbs_id" value="">
	<input type="hidden" name="selectValueList" id="selectValueList" value=""/>
</form>	
</body>
</html>