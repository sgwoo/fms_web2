<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");
	
	String period_gubun = request.getParameter("period_gubun")==null?"":request.getParameter("period_gubun");
	String branch = request.getParameter("branch")==null?"":request.getParameter("branch");		//�������� �˻��߰�
	String bus_user_id = request.getParameter("bus_user_id")==null?"":request.getParameter("bus_user_id");		//��ȭ�ۼ��� �˻��߰�

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int height = AddUtil.parseInt(s_height) - emp_top_height - (3 * sc_line_height) - 180;//gridbox height ���
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String cmd = "";
	if (!gubun4.equals("3")) {
		s_dt = "";
		e_dt = "";
	}
	
	LoginBean login = LoginBean.getInstance();
	
	if (t_wd.equals("") && s_kd.equals("4")) {
		t_wd = login.getCookieValue(request, "acar_id");
	}
	
	//��������� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();	
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css">  -->
<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" />
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>

<script language='JavaScript' src='/include/common.js'></script>

<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
html, body 	{
	height: 95%;
}
.navigation {
    margin: 10px;
    font-size: 12px;
    padding: 8px;
    background-color: #f5f5f5;
    border: 1px solid #cecece;
    border-radius: 4px;
    margin-bottom: 10px;
    padding-top: 11px;
}
.style1 {
    color: #666666;
}
.style5 {
    color: #ef620c;
    font-weight: bold;
}
.search-area {
    margin: 10px;
    padding: 5px;
}
.button {
	background-color:#6d758c;
	font-size:12px;
	cursor:pointer;
	border-radius:2px;
	color:#fff;
	border:0;
	outline:0;
	padding:5px 8px;
	margin:3px;
}
.btn-submit {
	background-color:#308cbf;
}
.button:hover {
	background-color:#525D60;
}
.select {
    padding: 4px 4px;
    border: 1px solid #929292;
    border-radius: 2px;
    background-color: #ffff;
    font-size: 12px;
}
select {
    font-size: 9pt;
    color: #616161;
}
input[type="radio" i] {
    background-color: initial;
    cursor: default;
    -webkit-appearance: radio;
    box-sizing: border-box;
    margin: 3px 3px 0px 5px;
    padding: initial;
    border: initial;
}
.search-area > label, .inner-search-area > label {
    font-size: 12px;
    font-weight: bold;
    color: #5f5f5f;
}
input.text {
    font-size: 9pt;
    text-align: left;
    border: 1 solid #acacac;
    background-color: #ffffff;
    font-family: DOTUM;
    color: #303030;
}
.input {
    height: 24px;
    border-radius: 2px;
    border: 1px solid #929292;
    margin: 3px 0px;
}
</style>

<!--Grid-->
<script type="text/javascript">

function set_handlers() {
	alert("in inithandlers " + basicgridbox);
	basicgridbox.attachEvent("onDistributedEnd",doDistEnd);
}

function doDistEnd() {
    alert("doDistEnd");
}

var gridQString = "";

$(document).ready(function() {
	var myGrid;
	
	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("/fms2/lib/dhtmlx/skins/web/imgs/");//��0-15��(16��)

	myGrid.setHeader("<input type='checkbox' class='header_check'>,����,����,��ȭ,�����,��û����,������,����/���θ�,����,��������,�����,��ȭ��ȣ,�������");
	myGrid.setInitWidths("45,45,45,190,110,140,130,150,80,80,75,130,300");
	myGrid.setColTypes("ron,ron,ro,link,ro,ro,ro,ro,ro,ro,ro,ron,ro");
	myGrid.attachHeader("#rspan,#rspan,#select_filter,#text_filter,#rspan,#rspan,#select_filter,#text_filter,#rspan,#rspan,#rspan,#text_filter,#text_filter");
	myGrid.attachHeader("#rspan,#rspan,�� �Ǽ�,#cspan,{#stat_count}��,,,,,,,,,,,,,",["text-align:center;",,"text-align:center;",,,,,,,,,]);
	myGrid.setColAlign("center,center,center,center,center,center,center,center,center,center,center,center,center");
	myGrid.enableTooltips("false,false,false,false,true,false,false,true,false,false,true,false,true");
	
	myGrid.attachEvent("onXLS", function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE", function(){ document.getElementById("a_1").style.display="none"; });
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;

	myGrid.detachHeader(2);
	//myGrid.splitAt(7);
	//myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);
	myGrid.enableColumnMove(true);
	//myGrid.enableDistributedParsing(true,100,400);
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress", onKeyPressed);
   	//myGrid.setAwaitedRowHeight(30);
    //myGrid.enableSmartRendering(true, 2000);
    //myGrid.enableAutoHeight(true, 1000);

    gridQString = "esti_spe_hp_grid_big_xml.jsp?gubun1=<%=gubun1%>&period_gubun=<%=period_gubun%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%=esti_m%>&esti_m_dt=<%=esti_m_dt%>&esti_m_s_dt=<%=esti_m_s_dt%>&esti_m_e_dt=<%=esti_m_e_dt%>&branch=<%=branch%>&bus_user_id=<%=bus_user_id%>";
    myGrid.load(gridQString);

	function onKeyPressed(code, ctrl, shift) {
		if (code == 67 && ctrl) {
			if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
			
			myGrid.setCSVDelimiter("\t");
			myGrid.copyBlockToClipboard();
		}
		if (code == 86 && ctrl) {
			myGrid.setCSVDelimiter("\t");
			myGrid.pasteBlockFromClipboard();
		}
		return true;
	}
})
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("input[name='period_gubun']").change(function(){
		search();
	})
	
	//�˻����� ����� �˻��ٿ� ����
	var pre_period_gubun = $("#pre_period_gubun").val();
	var pre_gubun4 = $("#pre_gubun4").val();
	var pre_s_dt = $("#pre_s_dt").val();
	var pre_e_dt = $("#pre_e_dt").val();
	var pre_period_gubun = $("#pre_e_dt").val();
	var pre_period_gubun = $("#pre_period_gubun").val();
	
	if(pre_gubun4!=null && pre_gubun4!=""){	//����ȸ ����
		if(pre_gubun4 == '3'){
			cng_dt();
		}
	}
	
	//�ֻ�� üũ�ڽ� Ŭ��
    $(".header_check").click(function() {
        //checked
        if ($(".header_check").prop("checked")) {
            $("input[name=content_check]").prop("checked", true);
        //unchecked
        } else {
            $("input[name=content_check]").prop("checked", false);
        }
    })
})

//��ȸ
function search() {
	var fm = document.form2;
	fm.action = "esti_spe_hp_grid_big_sc.jsp";
	fm.target = "c_foot";
	fm.submit();
}

//���÷��� Ÿ��
function cng_dt() {
	var fm = document.form2;
	if (fm.gubun4.options[fm.gubun4.selectedIndex].value == '3') { //�Ⱓ
		esti.style.display 	= 'inline';
	} else {
		esti.style.display 	= 'none';
	}
}

//��ȭ��
function EstiMemo(est_id, user_id, chk, bb_chk, t_chk) {
	var fm = document.form1;
	fm.t_chk.value = t_chk;
	fm.bb_chk.value = bb_chk;
	fm.chk.value = chk;
	fm.est_id.value = est_id;
	fm.user_id.value = user_id;
	fm.target = "d_content"
	fm.action = "esti_spe_hp_i.jsp";
	fm.submit();
}

//�˸���߼�ȭ��
function kakaoMsgSend() {
	
	var fm = document.content_form;
	
	var check_length = $('input:checkbox[name="content_check"]:checked').length;
	if (check_length == 0) {
	 	alert("�˸����� ���۹��� ���� �����ϼ���.");
		return;
	} else if (check_length > 30) {
		alert("�������� �ִ� 30�� �Դϴ�.");
		return;
	} else {
		window.open("", "popup_window", "width=1000, height=850, scrollbars=yes");
		fm.action = "/acar/estimate_mng/esti_spe_hp_grid_big_alim_talk.jsp";
		fm.target = "popup_window";
		fm.method = "post";
		fm.submit();
	}
}
</script>

</head>
<body leftmargin="15">
	
	<div class="navigation" style="margin-bottom:0px !important">
		<span class="style1">�������� > �������� > </span><span class="style5">����Ʈ ��������</span>
	</div>

	<form action="./esti_spe_hp_grid_big_sc.jsp" name="form2" method="POST" >
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="br_id" value="<%=br_id%>">
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
		<!-- ��Ϻ��� Ŭ���� ���ܰ� �˻����� ������ ���� �߰� -->
		<input type='hidden' name='pre_period_gubun' id="pre_period_gubun" value='<%=period_gubun%>'>
		<input type='hidden' name='pre_gubun4'  id="pre_gubun4" value='<%=gubun4%>'>
		<input type='hidden' name='pre_s_dt'  id="pre_s_dt" value='<%=s_dt%>'>
		<input type='hidden' name='pre_e_dt' id="pre_e_dt" value='<%=e_dt%>'>
		<input type='hidden' name='pre_esti_m' id="pre_esti_m" value='<%=esti_m%>'>
		<input type='hidden' name='pre_branch' id="pre_branch" value='<%=branch%>'>
		<input type='hidden' name='pre_branch' id="pre_bus_user_id" value='<%=bus_user_id%>'>
	
		<div class="search-area" style="margin:5px 0px 0px 5px; float: left;">
			<div style="float: left; width: 610px; height: 60px; font-size: 12px; font-weight: bold; color: #5f5f5f;">
				<input type="radio" name="period_gubun" id="gubun_total" value="" <%if (period_gubun.equals("")) {%>checked<%}%>><label for="gubun_total" >��ü</label>
				<input type="radio" name="period_gubun" id="gubun_long" value="1" <%if (period_gubun.equals("1")) {%>checked<%}%>><label for="gubun_long">����/�縮��(PC/�����)</label>
				<input type="radio" name="period_gubun" id="gubun_month" value="10" <%if (period_gubun.equals("10")) {%>checked<%}%>><label for="gubun_month">����Ʈ(�����)</label>
				<input type="radio" name="period_gubun" id="gubun_reserve" value="15" <%if (period_gubun.equals("15")) {%>checked<%}%>><label for="gubun_reserve">ģȯ������������</label>
				<input type="radio" name="period_gubun" id="gubun_consult" value="20" <%if (period_gubun.equals("20")) {%>checked<%}%>><label for="gubun_consult">������</label>
				<input type="radio" name="period_gubun" id="gubun_consult_ars" value="99" <%if (period_gubun.equals("99")) {%>checked<%}%>><label for="gubun_consult_ars">ARS����û</label>	
				<br>	
				<input type="button" class="button" value="���� �˸��� �߼��ϱ�" onclick="kakaoMsgSend();" style="margin-top: 12px;">
			</div>
			
			<div style="float: left; width: 310px; height: 60px; font-size: 12px; font-weight: bold; color: #5f5f5f;">
				<label><i class="fa fa-check-circle"></i> ����ȸ </label>
				<select class="select" name="gubun4" onChange="cng_dt();">
					<option value="">��ü</option>
					<option value="4" <%if (gubun4.equals("4")) {%>selected<%}%>>����</option>
					<option value="5" <%if (gubun4.equals("5")) {%>selected<%}%>>����</option>
					<option value="1" <%if (gubun4.equals("1")) {%>selected<%}%>>���</option>
					<option value="2" <%if (gubun4.equals("2")) {%>selected<%}%>>����</option>
					<option value="3" <%if (gubun4.equals("3")) {%>selected<%}%>>�Ⱓ</option>
				</select>
				
				<div id="esti" style="display:<%if (!gubun4.equals("3")) {%>none<%} else {%>''<%}%>">
					<input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class="text input" onBlur='javscript:this.value = ChangeDate(this.value);'>
				    ~
				    <input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class="text input" onBlur='javscript:this.value = ChangeDate(this.value);'>
			    </div>
			    
			    <br>
			    
			    <!-- �������� -->
			    <label><i class="fa fa-check-circle"></i> �������� </label>
			    <select name="branch" class="select">
			    	<option value="" <%if (branch.equals("")) {%>selected<%}%>>��ü</option>		
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>����</option>
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>��ȭ��</option>
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>����</option>
					<option value="�뱸" <%if (branch.equals("�뱸")) {%>selected<%}%>>�뱸</option>
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>����</option>
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>����</option>
					<option value="�λ�" <%if (branch.equals("�λ�")) {%>selected<%}%>>�λ�</option>
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>����</option>
					<option value="����" <%if (branch.equals("����")) {%>selected<%}%>>����</option>
					<option value="��õ" <%if (branch.equals("��õ")) {%>selected<%}%>>��õ</option>
				</select>	    
		    </div>
		    
		    <div style="float: left; width: 280px; height: 60px; font-size: 12px; font-weight: bold; color: #5f5f5f;">
			    <label><i class="fa fa-check-circle"></i> ��㿩�� </label>
			    <select name="esti_m" class="select" style="margin-left: 12px;">
					<option value="" <%if (esti_m.equals("")) {%>selected<%}%>>��ü</option>
					<option value="1" <%if (esti_m.equals("1")) {%>selected<%}%>>�Ϸ�</option>
					<option value="2" <%if (esti_m.equals("2")) {%>selected<%}%>>�̻��</option>
				</select>
				
				<br>
				
				<!-- ��ȭ�ۼ��� -->
				<label><i class="fa fa-check-circle"></i> ��ȭ�ۼ��� </label>
				<select name='bus_user_id' class="select">
					<option value="">��ü</option>
			<%if (user_size > 0) {%>
				<%for (int i = 0; i < user_size; i++) {
					Hashtable user = (Hashtable)users.elementAt(i);	%>
					<option value='<%=user.get("USER_ID")%>' <%if (bus_user_id.equals(user.get("USER_ID"))) {%>selected<%}%>><%=user.get("USER_NM")%></option>
				<%}%>
			<%}%>
				</select>
				&nbsp;&nbsp;<input type="button" class="button" value="�˻�" onclick="search();">
			</div>
			
		</div>
	</form>

	<form name="content_form" id="content_form">
		<table width="100%">
			<tr>
				<td>
					<div id="gridbox" style="width:100%; height:<%=height%>px; margin: 5px 0px 5px 0px;"></div>
	        	</td>
	    	</tr>
		</table>
	</form>
	
	<table border=0 cellspacing=0 cellpadding=0 width=100% height=1%>
	    <tr> 
	        <td align="left" style="font-size: 9pt;">
	            * �� �Ǽ� : <span id="gridRowCount">0</span>��
				<div id="a_1" style="color:red;">Loading</div>
	        </td>
	    </tr>
	</table>
	
	<form action="esti_mng_u.jsp" name="form1" method="POST">
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="br_id" value="<%=br_id%>">
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type="hidden" name="gubun1" value="<%=gubun1%>">
		<input type="hidden" name="gubun2" value="<%=gubun2%>">
		<input type="hidden" name="period_gubun" value="<%=period_gubun%>">
		<input type="hidden" name="gubun3" value="<%=gubun3%>">
		<input type="hidden" name="gubun4" value="<%=gubun4%>">  
		<input type="hidden" name="s_dt" value="<%=s_dt%>">
		<input type="hidden" name="e_dt" value="<%=e_dt%>">
		<input type="hidden" name="s_kd" value="<%=s_kd%>">          
		<input type="hidden" name="t_wd" value="<%=t_wd%>"> 
		<input type="hidden" name="esti_m" value="<%=esti_m%>"> 
		<input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>"> 
		<input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>"> 
		<input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">         
		<input type="hidden" name="est_id" value="">       
		<input type="hidden" name="cmd" value="">  
		<input type="hidden" name="t_chk" value="">  
		<input type="hidden" name="bb_chk" value="">  
		<input type="hidden" name="chk" value="">
		<input type="hidden" name="branch" value="<%=branch%>"> <!-- �������� �˻� �߰� -->
		<input type="hidden" name="bus_user_id" value="<%=bus_user_id%>"> <!-- ��ȭ�ۼ��� �˻� �߰� -->	 
		<input type="hidden" name="m_st" value="01">  
		<input type="hidden" name="m_st2" value="01">  
		<input type="hidden" name="m_cd" value="01">  
		<input type="hidden" name="url" value="/acar/estimate_mng/esti_spe_hp_i.jsp">	
	</form>
	
</body>
</html>