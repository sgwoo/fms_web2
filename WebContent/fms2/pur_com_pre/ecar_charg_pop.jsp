<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.car_register.*, acar.client.*, acar.car_office.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ec_bean" class="acar.car_office.EcarChargerBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String s_kd 				= request.getParameter("s_kd")				==null?"":request.getParameter("s_kd");
	String t_wd 				= request.getParameter("t_wd")				==null?"":request.getParameter("t_wd");
	String andor 				= request.getParameter("andor")				==null?"":request.getParameter("andor");
	String gubun1 			= request.getParameter("gubun1")			==null?"":request.getParameter("gubun1");
	String gubun2 			= request.getParameter("gubun2")			==null?"":request.getParameter("gubun2");
	String gubun3 			= request.getParameter("gubun3")			==null?"":request.getParameter("gubun3");
	String gubun4 			= request.getParameter("gubun4")			==null?"":request.getParameter("gubun4");
	String gubun5 			= request.getParameter("gubun5")			==null?"":request.getParameter("gubun5");
	String st_dt 				= request.getParameter("st_dt")				==null?"":request.getParameter("st_dt");
	String end_dt 			= request.getParameter("end_dt")			==null?"":request.getParameter("end_dt");
	
	String rent_l_cd 		= request.getParameter("rent_l_cd")		==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id 	= request.getParameter("rent_mng_id")	==null?"":request.getParameter("rent_mng_id");
	String mode 				= request.getParameter("mode")				==null?"":request.getParameter("mode");
	
	CarRegDatabase 			crd  = CarRegDatabase.getInstance();
	AddCarMstDatabase 	a_cmb = AddCarMstDatabase.getInstance();
	CarOffPreDatabase 		cop  = CarOffPreDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	ContBaseBean base  	= new ContBaseBean();
	ClientBean client 			= new ClientBean();
	CarMstBean mst			= new CarMstBean();
	CarRegBean cr_bean 	= new CarRegBean();
	boolean addr_chk = false;
	
	if(!rent_l_cd.equals("") && !rent_mng_id.equals("")){
		//���⺻����
		base = a_db.getCont(rent_mng_id, rent_l_cd);
		//������
		client = al_db.getNewClient(base.getClient_id());
		//��������
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		//�ڵ���ȸ��&����&�ڵ�����
		mst = a_cmb.getCarEtcNmCase(rent_mng_id, rent_l_cd);
		if(mode.equals("U")){
			ec_bean = cop.getEcarChargerOne(rent_l_cd, rent_mng_id);
		}
	}
	
	
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.checked{		color:red;		}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
$(document).on(function(){

});
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		window.open("about:blank", "search_cont", "left=10, top=10, width=700, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "search_cont";
		fm.action = "ecar_charg_search_cont.jsp"
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//������ Ÿ�Կ� ���� �Է�������
	function change_type_form(val){
		if(val=='1'){
			$("#chg_type_1").css('display','table-row');
			$("#chg_type_2").css('display','none');
		}else if(val=='2'){
			$("#chg_type_1").css('display','none');
			$("#chg_type_2").css('display','table-row');
		}
	}
	
	//���
	function save(mode){
		var fm = document.form1;
		//�ּ��� ����
		var inst_loc_text = $("input[name='inst_loc_radio']:checked").val();
		if(inst_loc_text=="etc_addr"){
			fm.inst_zip.value = "";	
			fm.inst_loc.value = $("#etc_addr").val();
		}else{
			fm.inst_zip.value = inst_loc_text.split("//")[0];
			fm.inst_loc.value = inst_loc_text.split("//")[1];
		}
		if(fm.inst_loc.value==""){
			alert("�����⼳ġ��Ҹ� �����ϰų� �Է����ּ���.");	return;
		}
		//������ ��ġ ��ü ����
		if(fm.chg_type.value=="1"){
			fm.inst_off_r.value = $("#inst_off1").val();
			if($("#inst_off1").val()=="91"){		fm.etc_inst_off.value = $("#etc_off_nm1").val();		}
		}else if(fm.chg_type.value=="2"){
			fm.inst_off_r.value = $("#inst_off2").val();
			if($("#inst_off2").val()=="92"){		fm.etc_inst_off.value = $("#etc_off_nm2").val();		}
		}else{													fm.etc_inst_off.value = "";
		}
		
		if((fm.chg_type.value=="1" && $("#inst_off1").val()=="")||(fm.chg_type.value=="2" && $("#inst_off2").val()=="")){
			alert("��ġ��ü�� �������ּ���.");						return;
		}else if((fm.chg_type.value=="1" && $("#inst_off1").val()=="91") && fm.etc_inst_off.value==""){
			alert("��ġ��ü-��Ÿ �� ��ġ��ü�� �Է����ּ���.");	return;
		}else if((fm.chg_type.value=="2" && $("#inst_off2").val()=="92") && fm.etc_inst_off.value==""){
			alert("��ġ��ü-��Ÿ �� ��ġ��ü�� �Է����ּ���.");	return;
		}
		
		if(fm.chg_type.value=="1"){
			if(fm.pay_way.value==""){		alert("���ںδ� ���θ� �������ּ���.");	return;	}
		}else if(fm.chg_type.value=="2"){
			if(fm.chg_prop.value==""){		alert("������ �����ڸ� �������ּ���.");		return;	}
		}
		
		if(mode=='I'){
			if(!confirm("����Ͻðڽ��ϱ�?")){	return;	}
			else{		fm.mode.value = "I";		}
		}else if(mode=='U'){
			if(!confirm("�����Ͻðڽ��ϱ�?")){	return;	}
			else{		fm.mode.value = "U";		}
		}
		fm.action = "ecar_charg_a.jsp";
		fm.submit();
	}
	
	//��ġ��ü ����
	function chg_inst_off(chg_type, val){
			if(val=="91"||val=="92"){		$("#hidden_span"+chg_type).css("display","block");		}
			else{										$("#hidden_span"+chg_type).css("display","none");		}
	}
	
	//������ �ε� �� ��ũ��Ʈ ó��
	function onload_fn(){
	<%if(!rent_l_cd.equals("") && !rent_mng_id.equals("")&&mode.equals("U")){%>
			change_type_form('<%=ec_bean.getChg_type()%>');
			chg_inst_off('<%=ec_bean.getChg_type()%>', '<%=ec_bean.getInst_off()%>');
	<%}%>
	}
	
	function del(){	
		var fm = document.form1;
		if(!confirm("�����Ͻðڽ��ϱ�?")){	return;	}
		fm.mode.value = "D";
		fm.action = "ecar_charg_a.jsp";
		fm.submit();
	}
	
</script>
</head>

<body onload="javascript:onload_fn();">
<form name='form1' method='post'>
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" name="inst_zip" value="<%=ec_bean.getInst_zip()%>">
<input type="hidden" name="inst_loc" value="<%=ec_bean.getInst_loc()%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="client_id" value="<%=base.getClient_id()%>">
<input type="hidden" name="car_mng_id" value="<%=base.getCar_mng_id()%>">
<input type="hidden" name="etc_inst_off" value="<%=ec_bean.getEtc_inst_off()%>">
<input type="hidden" name="inst_off_r" value="">

<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">�������� > ������� > ������ ������ ��û ></span><span class="style5"> ��� â </span>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 20px;">
<%if(!mode.equals("U")){ %>
	<tr> 
  		<td><label><i class="fa fa-check-circle"></i> ��� �˻� </label>&nbsp;		
    		<select name='s_kd' class='select'>
      			<option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
				<option value='3' <%if(s_kd.equals("3"))%>selected<%%>>������ȣ</option>
			</select>
			<input type="text" name="t_wd" value="<%=t_wd%>" size="25" class='text input' onKeyDown="javasript:enter()" style='IME-MODE: active'>
			<button class='button' onclick='javascript:search();'>�˻�</button>		
      	</td>
    </tr>
    <tr> 
      	<td>&nbsp;</td>
	</tr>
<%} %>
    <%if(!rent_l_cd.equals("") && !rent_mng_id.equals("")){ %>
    <tr><td class=line2></td></tr>
    <tr> 
      	<td class=line> 
        	<table border="0" cellspacing="1" width=100%>
        		<colgroup>
	        		<col width='10%'>
	        		<col width='15%'>
	        		<col width='10%'>
	        		<col width='*'>
	        		<col width='10%'>
	        		<col width='15%'>
        		</colgroup>
          		<tr>
		            <td class=title>����ȣ</td>
		            <td align="center"><%=base.getRent_l_cd()%></td>
		            <td class=title>��ȣ</td>
		            <td align="center"><%=client.getFirm_nm()%></td>
		            <td class=title>����� ����</td>
		            <td align="center">
		            	<%if(client.getClient_st().equals("1")){ 			out.println("����");
		                      }else if(client.getClient_st().equals("2")){ out.println("����");
		                      }else if(client.getClient_st().equals("3")){ out.println("���λ����(�Ϲݰ���)");
		                      }else if(client.getClient_st().equals("4")){	out.println("���λ����(���̰���)");
		                      }else if(client.getClient_st().equals("5")){ out.println("���λ����(�鼼�����)"); }%>
		            </td>
          		</tr>
          		<tr>
		            <td class=title>������ȣ</td>
		            <td align="center"><%=cr_bean.getCar_no()%></td>
		          	<td class=title>����</td>
		            <td align="center"><%=mst.getCar_nm()%>&nbsp;<%=mst.getCar_name()%></td>
		            <td class=title></td>
		            <td align="center"></td>
          		</tr>
          		<tr>
          			<td class=title></td>
          			<td colspan="5"></td>
          		</tr>
        	</table>
      	</td>
	</tr>
   	<tr> 
      	<td>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>	
    <tr> 
    	<td class=line>
    		<table  border="0" cellspacing="1" width=100%>
				<colgroup>
					<col width="12%">
					<col width="45%">
					<col width="12%">
					<col width="*">
				</colgroup>
				<tr>
					<td class='title'>������<br>��ġ���</td>
					<td colspan="3">
					<%if(client.getClient_st().equals("2")){//����%>
						<%if(!client.getHo_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getHo_zip()%>//<%=client.getHo_addr()%>'
							 <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getHo_zip()+"//"+client.getHo_addr())){		addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getHo_zip()+"//"+client.getHo_addr())){%>class="checked"<%}%>>
							���ְ��� : (<%=client.getHo_zip()%>)<%=client.getHo_addr()%></span><br>
						<%}%>						
						<%if(!client.getComm_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getComm_zip()%>//<%=client.getComm_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){	addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){%>class="checked"<%} %>>
							���� : (<%=client.getComm_zip()%>)<%=client.getComm_addr()%></span><br>
						<%}%>						 
					<%}else{//�����%>
						<%if(!client.getO_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getO_zip()%>//<%=client.getO_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getO_zip()+"//"+client.getO_addr())){	addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){%>class="checked"<%} %>>
							������ּ� : (<%=client.getO_zip()%>)<%=client.getO_addr()%><br>
						<%}%>
						<%if(!client.getHo_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getHo_zip()%>//<%=client.getHo_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getHo_zip()+"//"+client.getHo_addr())){	addr_chk = true;	%>checked<%}%>>
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getComm_zip()+"//"+client.getComm_addr())){%>class="checked"<%} %>>
							<%if(client.getClient_st().equals("1")){%> ���������� : <%}else{%> ������ּ� : <%}%> 
							(<%=client.getHo_zip()%>)<%=client.getHo_addr()%></span><br>
						<%}%>
						<%if(!client.getRepre_addr().equals("")){%>
							<input type='radio' name='inst_loc_radio' value='<%=client.getRepre_zip()%>//<%=client.getRepre_addr()%>'
							<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getRepre_zip()+"//"+client.getRepre_addr())){	addr_chk = true;	%>checked<%}%>> 
							<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(client.getRepre_zip()+"//"+client.getRepre_addr())){%>class="checked"<%} %>>
							��ǥ���ּ� : (<%=client.getRepre_zip()%>)<%=client.getRepre_addr()%></span><br>
						<%} %>	
					<%} %>
					<%if(!base.getP_addr().equals("")){%>
						<input type='radio' name='inst_loc_radio' value='<%=base.getP_zip()%>//<%=base.getP_addr()%>'
						<%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(base.getP_zip()+"//"+base.getP_addr())){	addr_chk = true;	%>checked<%}%>> 
						<span <%if((ec_bean.getInst_zip()+"//"+ec_bean.getInst_loc()).equals(base.getP_zip()+"//"+base.getP_addr())){%>class="checked"<%} %>>
						�����ּ� : (<%=base.getP_zip()%>)<%=base.getP_addr()%></span><br>
					<%}%>
						<input type='radio' name='inst_loc_radio' value='etc_addr' <%if(addr_chk==false){ %>checked="checked"<%} %>> 
						��Ÿ : <input type="text" class="text input" size="80" id="etc_addr" value="<%if(addr_chk==false){%><%=ec_bean.getInst_loc() %><%}%>" <%if(addr_chk==false){%>style='color:red;'<%}%>>
					</td>
				</tr>
				<tr>
					<td class='title'>������ Ÿ��</td>
					<td colspan="3">&nbsp;
						<select id='chg_type' name='chg_type' onchange="javascript:change_type_form(this.value);">
							<option value='1' <%if(ec_bean.getChg_type().equals("1")){%>selected<%} %>>�̵���</option>
							<option value='2' <%if(ec_bean.getChg_type().equals("2")){%>selected<%} %>>������</option>
						</select>
					</td>
				</tr>
				<tr id='chg_type_1'>
					<td class='title' >��ġ��ü</td>
					<td>&nbsp;
						<div style="float: left;">
							<select id='inst_off1' name='inst_off' onchange="javascript:chg_inst_off('1', this.value);">
								<option value=''>����</option>
								<option value='1' <%if(ec_bean.getInst_off().equals("1")){%>selected<%} %>>�Ŀ�ť��</option>
								<option value='2' <%if(ec_bean.getInst_off().equals("2")){%>selected<%} %>>�Ŵ�����(�̺�Ʈ)</option>
								<option value='91' <%if(ec_bean.getInst_off().equals("91")){%>selected<%} %>>��Ÿ</option>
							</select>
						</div>
						<div id="hidden_span1" style="display:none; position: relative;">
							&nbsp;&nbsp;&nbsp;<input type="text" id="etc_off_nm1" value="<%if(ec_bean.getInst_off().equals("91")){%><%=ec_bean.getEtc_inst_off()%><%}%>">
						</div>
					</td>
					<td class='chg_type_1 title'>���ںδ�</td>
					<td class='chg_type_1'>&nbsp;
						<select id='pay_way' name='pay_way'>
							<option value=''>����</option>
							<option value='1' <%if(ec_bean.getPay_way().equals("1")){%>selected<%} %>>������</option>
							<option value='2' <%if(ec_bean.getPay_way().equals("2")){%>selected<%} %>>�����ݿ�</option>
						</select>
					</td>
				</tr>	
				<tr id='chg_type_2' style="display:none;">
					<td class='title'>��ġ��ü</td>
					<td>&nbsp;
						<div style="float: left;">
							<select id='inst_off2' name='inst_off' onchange="javascript:chg_inst_off('2', this.value);">
								<option value=''>����</option>
								<option value='11' <%if(ec_bean.getInst_off().equals("11")){%>selected<%} %>>�뿵ä��</option>
								<option value='92' <%if(ec_bean.getInst_off().equals("92")){%>selected<%} %>>��Ÿ</option>
							</select>
						</div>
						<div id="hidden_span2" style="display:none; position: relative;">
							&nbsp;&nbsp;&nbsp;<input type="text" id="etc_off_nm2" value="<%if(ec_bean.getInst_off().equals("92")){%><%=ec_bean.getEtc_inst_off()%><%}%>">
						</div>
					</td>
					<td class='title'>����, �ǹ� ������</td>
					<td>&nbsp;
						<select id='chg_prop' name='chg_prop'>
							<option value=''>����</option>
							<option value='1' <%if(ec_bean.getChg_prop().equals("1")){%>selected<%} %>>���μ���</option>
							<option value='2' <%if(ec_bean.getChg_prop().equals("2")){%>selected<%} %>>Ÿ�μ���</option>
						</select>
					</td>
				</tr>
			</table>
    	</td>  	
    </tr>
    <%} %>
</table>
<div align="center">
<%if(!rent_l_cd.equals("") && !rent_mng_id.equals("")){ %>
	<%if(mode.equals("U")){ %>
		<%if(ck_acar_id.equals("000144") || nm_db.getWorkAuthUser("������",ck_acar_id)){ %>
			<input type='button' value='����'  class='button' onclick="javascript:save('U');">
		<%} %>
		<%if(ck_acar_id.equals("000144") || ck_acar_id.equals(ec_bean.getReg_id()) ||nm_db.getWorkAuthUser("������",ck_acar_id)){ %>
			<input type='button' value='����'  class='button' onclick="javascript:del();">
		<%} %>
	<%}else{ %>
		<input type='button' value='���'  class='button' onclick="javascript:save('I');">
	<%} %>
<%} %>
    <input type='button' value='�ݱ�'  class='button' onclick='javascript:window.close();'>
</div>
</form>
</body>
</html>