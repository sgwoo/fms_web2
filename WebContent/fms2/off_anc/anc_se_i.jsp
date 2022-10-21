<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.off_anc.*,acar.common.*"%>
<%@ page import="acar.user_mng.*, acar.car_office.*, acar.car_mst.*"%>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int bbs_id = 0;
	String user_id = "";
	String user_nm = "";
	String br_id = "";
	String br_nm = "";
	String dept_id = "";
	String dept_nm = "";
	String reg_dt = "";
	String exp_dt = "";
	String title = "";
	String content = "";
    String auth_rw = "";
    String cmd = "";
	String bbs_st = "";
	String comst = "";
	int 	vist_cnt = 0;
	String title_st = "";
	
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String end_st 		= request.getParameter("end_st")==null?"":request.getParameter("end_st");
	
	
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	reg_dt = Util.getDate();
	user_id = ck_acar_id;
	
	u_bean = umd.getUsersBean(user_id);
	
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();
	
	
	//�ش�μ� �������Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();

	users = c_db.getUserList("", "", "EMP");

	int user_size = users.size();
	
	
	String car_comp_id2	= "0001"; 
	
	if(!car_comp_id.equals("")){
		car_comp_id2	= car_comp_id;
	}
	//�ڵ���ȸ�� ����Ʈ
	CarOfficeDatabase cof = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = cof.getCarCompAll();
	
	//��������Ʈ
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id2);	
		
%>
<html>
<head>
<title>FMS</title>
<script type="text/javascript" src="../lib/smarteditor/js/service/HuskyEZCreator.js" charset="utf-8"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
	
	//����Ʈ
	function list(){
		var fm = document.AncRegForm;			
		fm.action = 'anc_s_grid_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
function AncReg()
{
	var theForm = document.AncRegForm;
	var bbs_st = "";
	
	// ī�װ�
	var radios = document.getElementsByName('bbs_st');
	for (var i = 0, length = radios.length; i < length; i++) {
		if (radios[i].checked) {
			bbs_st = radios[i].value;
		}
	}
	
	if(theForm.title.value == '' && theForm.title1.value == '') {	
		alert('������ �Է��Ͻʽÿ�');
		if (bbs_st == "5") {
			theForm.title1.focus();	
		} else {
			theForm.title.focus();
		}
		return;	
	} 
	
	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
	
	if(bbs_st=="5"){		
		
	}else{		 
		if (theForm.content.value == '' || theForm.content.value == '<p><br></p>') {
		   	alert('������ �Է��Ͻʽÿ�');		
			return;	
	   	}
	}
	
	theForm.content.value = theForm.content.value.replace(/<br>$/, "");
	
	theForm.cmd.value = "i";
	
	if(confirm('����Ͻðڽ��ϱ�?')){
		theForm.action='anc_null_ui.jsp';		
		theForm.target="i_no";
		theForm.submit();
	}

}
function AncClose()
{
	self.close();
	window.close();
}

function ChangeDT()
{
	var theForm = document.AncRegForm;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
}

//��������
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}
//����Ʈ ����	

function go_to_list()
{
	var fm = document.AncRegForm;
	fm.action = "./anc_s_grid_frame.jsp";
	fm.target = 'd_content';
	top.window.close();
	fm.submit();
}
//���÷��� Ÿ��
function cng_est_st(st) {
	var fm = document.AncRegForm;
	if(st == "5"){ 			//������
		est_st0_1.style.display	= 'none';
		est_st1_1.style.display	= 'none';
		est_st2_1.style.display	= '';						
		est_st3_1.style.display	= 'none';						
		est_st3_2.style.display	= 'none';
		cng_est_st2(fm.title_st.value);
	}else if(st == "3"){	//�Ǹ�����
		est_st0_1.style.display	= '';
		est_st1_1.style.display	= '';						
		est_st2_1.style.display	= 'none';		
		est_st3_1.style.display	= 'none';						
		est_st3_2.style.display	= 'none';
	}else{
		est_st0_1.style.display	= 'none';
		est_st1_1.style.display	= '';						
		est_st2_1.style.display	= 'none';		
		est_st3_1.style.display	= 'none';						
		est_st3_2.style.display	= 'none';
	}
}
function cng_est_st2(st) {
	var fm = document.AncRegForm;
	if(st == "1"){ 			//���
		est_st2_1.style.display	= '';
		est_st3_1.style.display	= '';						
		est_st3_2.style.display	= 'none';
		est_st3_3.style.display	= '';		
	}else if(st == "3"){ 			//���
		est_st2_1.style.display	= '';
		est_st3_1.style.display	= '';						
		est_st3_2.style.display	= 'none';		
		est_st3_3.style.display	= 'none';		
	}else if(st == "2"){	//����
		est_st2_1.style.display	= '';
		est_st3_1.style.display	= 'none';						
		est_st3_2.style.display	= '';		
	}
}

function Change (target,type) 
{  
       if ( target.value == target.defaultValue && type==0) target.value = ''; 
       if ( !target.value && type==1) target.value = target.defaultValue; 
} 

//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
function GetCarCode(){
	var fm = document.AncRegForm;
	var fm2 = document.form2;
	te = fm.code;
	te.options[0].value = '';
	te.options[0].text = '��ȸ��';
	fm2.sel.value = "AncRegForm.code";
	fm2.car_comp_id.value = fm.car_comp_id.value;
	fm2.mode.value = '8';
	fm2.target="i_no";
	fm2.submit();
}
function GetEndTitle(){
	var fm = document.AncRegForm;
	fm.title.value = '';
	if(fm.end_st.value == '1'){
		fm.title.value = '[�����ܻ�]';
	}
	if(fm.end_st.value == '2'){
		fm.title.value = '[����ܻ�]';
	}	
}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css"> 
	#title{
		-webkit-ime-mode:active;
		-moz-ime-mode:active;
		-ms-ime-mode:active;
		ime-mode:active;
	}
</style>
</head>
<body onLoad="javascript:self.focus()">
<form action="/acar/car_mst/car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="from_page" value="/acar/car_mst/car_mst_i.jsp">
</form>
<form name="AncRegForm" method="post" >
	<input type="hidden" name="from_page" value="<%=from_page%>">	
<%if(user_id.equals("000003") || user_id.equals("000004") || user_id.equals("000005")){%>	
<input	type="hidden" name="comst" value="Y"> 
<%}%>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
		    <table width=100% border=0 cellpadding=0 cellspacing=0>
    			<tr>
    				<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
    				<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > �������� > <span class=style5>�������� ���</span></span></td>
    				<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
    			</tr>
		    </table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
	    <td align=right>		      
     			<!--<a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>-->
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <%if(from_page.equals("/fms2/off_anc/upgrade_frame.jsp") || from_page.equals("/fms2/off_anc/agent_frame.jsp") || from_page.equals("/fms2/off_anc/off_frame.jsp")){%>
                <tr>
        	        <td class="title" width=15% >ī�װ�</td>
        		    <td align="" colspan="3">
							<%if(from_page.equals("/fms2/off_anc/upgrade_frame.jsp")){%>
							<input type="radio" name="bbs_st" value="7" checked>���׷��̵�&nbsp;&nbsp; 
							<%}else if(from_page.equals("/fms2/off_anc/agent_frame.jsp")){%>
							<input type="radio" name="bbs_st" value="8" checked>������Ʈ ����&nbsp;&nbsp;  
							<%}else if(from_page.equals("/fms2/off_anc/off_frame.jsp")){%>
							<input type="radio" name="bbs_st" value="9" checked>���¾�ü ����&nbsp;&nbsp; 
							<%}%>
        		    </td>
        	    </tr>                      
                <%}else{%>
                <tr>
        	        <td class="title" width=15% rowspan='3'>ī�װ�</td>
        		    <td align="" colspan="3">							
        					&nbsp;<input type="radio" name="bbs_st" value="1" onClick="Javascript:cng_est_st('1')" checked> �Ϲݰ��� &nbsp;&nbsp; 
        					<input type="radio" name="bbs_st" value="4" onClick="Javascript:cng_est_st('4')"> ��������&nbsp;&nbsp;
        					<input type="radio" name="bbs_st" value="5" onClick="Javascript:cng_est_st('5')"> ������&nbsp;&nbsp;
        					<input type="radio" name="bbs_st" value="6" onClick="Javascript:cng_est_st('6')"> �������λ�&nbsp;&nbsp;	
        					<input type="radio"	name="bbs_st" value="2" onClick="Javascript:cng_est_st('2')">�ֱٴ��� &nbsp;&nbsp; 
        					<input type="radio" name="bbs_st" value="3" onClick="Javascript:cng_est_st('3')">�Ǹ�����&nbsp;&nbsp; 
        		    </td>
        	    </tr>        	    
        	    <tr>
        		    <td colspan="3">&nbsp;&nbsp;<select name="p_view">
								<option value="">����</option>
								<option value="Y">���¾�ü</option>
								<option value="A">������Ʈ</option>
								<option value="J">���¾�ü/������Ʈ</option>
							</select>
							&nbsp;&nbsp;(�����¾�ü/������Ʈ�� ������ �� �� �ֵ��� ������ �� �ֽ��ϴ�.)
					</td>        
                </tr>
                <tr>
        		    <td colspan="3">&nbsp;&nbsp;<input type='checkbox' name='scm_yn' value='Y'>��� �͸����� ǥ��	</td>        
                </tr>
        	    <%}%>
        	    <tr>
        		    <td class="title" width=15%>�ۼ���</td>
        		    <td width=35%>&nbsp;&nbsp;<%=user_nm%></td>
        		    <td class="title" width=15%>�μ�</td>
        		    <td>&nbsp;&nbsp;<%=dept_nm%></td>
        
                </tr>
        	    <tr>
        		    <td class="title" width=15%>�ۼ���</td>
        		    <td>&nbsp;&nbsp;<%=reg_dt%></td>
        		    <td class="title" width=15%>������</td>
        		    <td ONLOAD="NowDateCall();">
        				&nbsp;&nbsp;<input type='text' name="exp_dt" size='20' class='text' onBlur="javascript:ChangeDT()">        				
        		    </td>
        	    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr id="est_st0_1" style="display:none">
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">				
        	    <tr>
					<td align="center" class="title" width=15%>��������</td>
        		    <td colspan="3">&nbsp;        		    
        		    	<select name="car_comp_id" onChange="javascript:GetCarCode()">
        		    	<option value="">������ ����</option>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select>
                      &nbsp;                      
                      <select name="code">
                        <option value="">���� ����</option>
                        <%if(!car_comp_id.equals("")){ %>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%=cm_bean.getCode()%>" <%if(code.equals(cm_bean.getCode()))%>selected<%%>><%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                        <%}%>
                      </select>
                      &nbsp;                      
                      <select name="end_st" onChange="javascript:GetEndTitle()">
                        <option value="">�ܻ걸�� ����</option>
                        <option value="1" <%if(end_st.equals("1"))%>selected<%%>>�����ܻ�</option>
                        <option value="2" <%if(end_st.equals("2"))%>selected<%%>>����ܻ�</option>
                      </select>
                      
        		    </td>
        	    </tr>
			</table>
		</td>
	</tr>
	<tr id="est_st1_1">
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">				
        	    <tr>
					<td align="center" class="title" width=15%>����</td>
        		    <td colspan="3">&nbsp;
        		    <%if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("�̻�",user_id)||nm_db.getWorkAuthUser("�����ѹ�����",user_id)
			 			||nm_db.getWorkAuthUser("���翵������",user_id)||nm_db.getWorkAuthUser("���翵����ȹ����",user_id)||nm_db.getWorkAuthUser("�����������",user_id)
			 			||nm_db.getWorkAuthUser("���翵��������",user_id)||nm_db.getWorkAuthUser("����",user_id)){ %>
			 			<input type='checkbox' name='impor_yn' value='Y'> �߿� &nbsp;
			 		<%} %>	
        		    	<input type='checkbox' name='read_yn' value='Y'> �ʵ� &nbsp;
        		    	<input type='text' name="title" id="title" size='75' class='text' style='IME-MODE: active' autofocus tabindex="-1">
        		    </td>
        	    </tr>
				<tr>
					<td class="title" width=15%>����</td>
					<td colspan="3">&nbsp;&nbsp;
					<textarea name="content" id="content" style="display:none;"> </textarea>
					<script>
					var oEditors = [];
					nhn.husky.EZCreator.createInIFrame({
					 oAppRef: oEditors,
					 elPlaceHolder: "content",
					 sSkinURI: "../lib/smarteditor/SmartEditor2Skin.html",
					 fCreator: "createSEditor2"
					});
					</script>					
					</td>					
				</tr>
				<%if(ck_acar_id.equals("000029")){ %>
				<tr>
					<td align="center" class="title" width=15%>Ű����</td>
        		    <td colspan="3">&nbsp;        		    
        		    	<input type='text' name="keywords" id="keywords" size='95' class='text' style='IME-MODE: active'>
        		    	�� �޸�(,)�� ����
        		    </td>
        	    </tr>
				<%} %>
			</table>
		</td>
	</tr>
	<tr id="est_st2_1" style="display:none">
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td align="center" class="title" width=30%>����</td>
        		    <td colspan="">
						<input TYPE="radio" name="title_st" value="1" onClick="Javascript:cng_est_st2('1')">��ȥ
						<input TYPE="radio" name="title_st" value="3" onClick="Javascript:cng_est_st2('3')">��
						<input TYPE="radio" name="title_st" value="2" onClick="Javascript:cng_est_st2('2')">�ΰ�&nbsp;
						<input type='text' name="title1" id="title1" size='40' class='text' style='IME-MODE: active'>
					</td>
        	    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr id="est_st3_1" style="display:none">
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">				
				<tbody>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>�����</td>
					  <td class="title" width=15%>����</td>
					  <td>&nbsp;&nbsp;<select name="d_user_id1">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' ><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
					</tr>
					
					<tr>
					  <td class="title" width=15%>�μ�</td>
					  <td>&nbsp;</td>
					</tr>
					<tr>
					  <td class="title" width=15%>��ȭ��ȣ</td>
					  <td></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="2" class="title" width=15%>����Ͻ�</td>
					  <td class="title" width=15%>����</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_st1" id="d_day_st1" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>����</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_ed" id="d_day_ed" size='11' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)' ><!--onFocus='Change(this,0)' onBlur='Change(this,1)'-->
					  	(��)2013-11-25 <font color=#CCCCCC>(���� �����ϰ� ����)</font>
					  </td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>���</td>
					  <td class="title" width=15%>�������ȣ</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_nm1" id="place_nm1" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>��ȭ��ȣ</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_tel1" id="place_tel1" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>�ּ�</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_addr1" id="place_addr1" size='60' class='text' value=''></td>
					</tr>
					<tr>
						<td class="title" colspan="2" width=30%>÷��</td>
						<td colspan="">&nbsp;&nbsp;<textarea name="content1" id="content1" cols='65' rows='7'> </textarea></td>
					</tr>
					<tr id="est_st3_3" style="display:none">
						<td colspan="3"><br>&nbsp;<b>�� �系 ����</b><br>
						&nbsp;&nbsp;&nbsp;1) ȭȯ : ȸ�簡 ��ǥ�� ����<br>
		                &nbsp;&nbsp;&nbsp;2) ������ : ȸ��� ��Կ� ���ϰ�, ������ ģ�� ���迡 ���� ������ �������� ����.<p>						
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr id="est_st3_2" style="display:none">
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">				
				<tbody>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>�����</td>
					  <td class="title" width=15%>����</td>
					  <td>&nbsp;&nbsp;<select name="d_user_id2">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' ><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select></td>
					</tr>
					<tr>
					  <td class="title" width=15%>�μ�</td>
					  <td></td>
					</tr>
					<tr>
					  <td class="title" width=15%>��ȭ��ȣ</td>
					  <td></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="3" class="title" width=15%>����</td>
					  <td class="title" width=15%>����</td>
					  <td>&nbsp;&nbsp;<input type='text' name="deceased_nm" id="deceased_nm" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>�����Ͻ�</td>
					  <td>&nbsp;&nbsp;<input type='text' name="deceased_day" id="deceased_day" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>���ΰ�����</td>
					  <td>&nbsp;&nbsp;<input type='text' name="family_relations" id="family_relations" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="2" class="title" width=15%>����</td>
					  <td class="title" width=15%>�Ͻ�</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_st2" size='11' class='text' value='' onBlur='javascript:this.value=ChangeDate(this.value)' ><!--onFocus='Change(this,0)' onBlur='Change(this,1)'-->
					  	(��)2013-11-25 <font color=#CCCCCC>(���� �����ϰ� ����)</font>
					  	</td>
					</tr>
					<tr>
					  <td class="title" width=15%>���</td>
					  <td>&nbsp;&nbsp;<input type='text' name="d_day_place" id="d_day_place" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td colspan="1" rowspan="4" class="title" width=15%>����</td>
					  <td class="title" width=15%>����</td>
					  <td>&nbsp;&nbsp;<input type='text' name="chief_nm" id="chief_nm" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>��������ȣ</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_nm2" id="place_nm2" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>��ȭ��ȣ</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_tel2" id="place_tel2" size='60' class='text' value=''></td>
					</tr>
					<tr>
					  <td class="title" width=15%>�ּ�</td>
					  <td>&nbsp;&nbsp;<input type='text' name="place_addr2" id="place_addr2" size='60' class='text' value=''></td>
					</tr>
					<tr>
						<td class="title" colspan="2" width=30%>÷��</td>
						<td colspan="">&nbsp;&nbsp;<textarea name="content2" id="content2" cols='65' rows='7'> </textarea></td>
					</tr>
					<tr>
						<td colspan="3"><br>&nbsp;1. �系 ����<br>
						&nbsp;&nbsp;&nbsp;1) ��ȭ : ȸ�簡 ��ġ<br>
						&nbsp;&nbsp;&nbsp;2) �����ݾ� : ȸ���� ���� �����ݸ� �����ϰ� ������ ������ ��ü ���� ����.<p>
						&nbsp;2. ���(ȸ��� �ŷ�����, ��û����) ���� ���� (2013-09-05)<br>
						&nbsp;&nbsp;1) �����翡 ���� ��������� ���¾�ü�������� ���� Ȯ���Ͽ� �˸��� ����.<br>
			      &nbsp;&nbsp;2) � �������� �˰� �Ǵ��� ������ ���� ��Ģ�Ͽ� ó����.<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;   �� ����� ��� �������ο� ���� ������ ��쿡�� �ּ����� ������ ��.<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       (���� �� �ٸ� ������ ���� �븮������ ���� �ʴ� ������ ��.)<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;   �� ������ ��� ���� �� ������ �θ�(����ںθ�����)�� ���� �����ϴ� ��쿡�� �ּ����� ������ ��.<br>
			       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;       (���� ���� �� �ٸ� ����� ���� �븮������ ���� ����.)<br>
						</td>
					</tr>
					<tr>
						<td colspan="3">
						</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
	    <td align=right>
		      <a href="javascript:AncReg()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align=absmiddle border=0></a>&nbsp;  
		      <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>   			
    </tr>	
	
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
        	<table width="100%">
            	<tr>
            		<td  align='center'>
            		</td>
            	</tr>
	        </table>
	    </td>
	</tr>
</table>
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input	type="hidden" name="bbs_id" value="<%=bbs_id%>"> 
<input	type="hidden" name="bbs_st" value="<%=bbs_st%>"> 
<input	type="hidden" name="title_st" value="<%=title_st%>"> 
<input type="hidden" name="comst" value="<%=comst%>">
<input	type="hidden" name="cmd" value="">
<!-- </center> -->
</form>
<script>
	// Ư������ ' " \ ���� 2018.02.06
	var regex = /['"\\]/gi;
	var title;					// ����
	var title1;					// ����
	var content1;			// ÷��
	var content2;			// ÷��
	var d_day_st1;			// ����Ͻ� ����
	var d_day_ed;			// ����Ͻ� ����
	var place_nm1;		// �������ȣ
	var place_tel1;			// ��ȭ��ȣ
	var place_addr1;		// �ּ�
	var deceased_nm;	// �ΰ� ���� ����
	var deceased_day;	// �ΰ� ���� �����Ͻ�
	var family_relations;	// �ΰ� ���ΰ� ����
	var d_day_place;		// ��ʽ��� ���
	var chief_nm;			// ����
	var place_nm2;		// ����Ļ�ȣ
	var place_tel2;			// ��ʽ��� ��ȭ��ȣ
	var place_addr2;		// ��ʽ��� �ּ�
	$("#title").bind("keyup",function(){title = $("#title").val();if(regex.test(title)){$("#title").val(title.replace(regex,""));}});
	$("#title1").bind("keyup",function(){title1 = $("#title1").val();if(regex.test(title1)){$("#title1").val(title1.replace(regex,""));}});
	$("#content1").bind("keyup",function(){content1 = $("#content1").val();if(regex.test(content1)){$("#content1").val(content1.replace(regex,""));}});
	$("#content2").bind("keyup",function(){content2 = $("#content2").val();if(regex.test(content2)){$("#content2").val(content2.replace(regex,""));}});
	$("#d_day_st1").bind("keyup",function(){d_day_st1 = $("#d_day_st1").val();if(regex.test(d_day_st1)){$("#d_day_st1").val(d_day_st1.replace(regex,""));}});
	$("#d_day_ed").bind("keyup",function(){d_day_ed = $("#d_day_ed").val();if(regex.test(d_day_ed)){$("#d_day_ed").val(d_day_ed.replace(regex,""));}});
	$("#place_nm1").bind("keyup",function(){place_nm1 = $("#place_nm1").val();if(regex.test(place_nm1)){$("#place_nm1").val(place_nm1.replace(regex,""));}});
	$("#place_tel1").bind("keyup",function(){place_tel1 = $("#place_tel1").val();if(regex.test(place_tel1)){$("#place_tel1").val(place_tel1.replace(regex,""));}});
	$("#place_addr1").bind("keyup",function(){place_addr1 = $("#place_addr1").val();if(regex.test(place_addr1)){$("#place_addr1").val(place_addr1.replace(regex,""));}});
	$("#deceased_nm").bind("keyup",function(){deceased_nm = $("#deceased_nm").val();if(regex.test(deceased_nm)){$("#deceased_nm").val(deceased_nm.replace(regex,""));}});
	$("#deceased_day").bind("keyup",function(){deceased_day = $("#deceased_day").val();if(regex.test(deceased_day)){$("#deceased_day").val(deceased_day.replace(regex,""));}});
	$("#family_relations").bind("keyup",function(){family_relations = $("#family_relations").val();if(regex.test(family_relations)){$("#family_relations").val(family_relations.replace(regex,""));}});
	$("#d_day_place").bind("keyup",function(){d_day_place = $("#d_day_place").val();if(regex.test(d_day_place)){$("#d_day_place").val(d_day_place.replace(regex,""));}});
	$("#chief_nm").bind("keyup",function(){chief_nm = $("#chief_nm").val();if(regex.test(chief_nm)){$("#chief_nm").val(chief_nm.replace(regex,""));}});
	$("#place_nm2").bind("keyup",function(){place_nm2 = $("#place_nm2").val();if(regex.test(place_nm2)){$("#place_nm2").val(place_nm2.replace(regex,""));}});
	$("#place_tel2").bind("keyup",function(){place_tel2 = $("#place_tel2").val();if(regex.test(place_tel2)){$("#place_tel2").val(place_tel2.replace(regex,""));}});
	$("#place_addr2").bind("keyup",function(){place_addr2 = $("#place_addr2").val();if(regex.test(place_addr2)){$("#place_addr2").val(place_addr2.replace(regex,""));}});
</script>
<script language="JavaScript" type="text/JavaScript">	
	$(document).ready(function(){
		$("#title").focus();
		
		$("input[name='bbs_st']").on("click", function(){
			var cate_radio = $("input[name='bbs_st']:checked").val();
			if (cate_radio == "5") {
				$("#title1").focus();
				$("#title1").css("IME-MODE", "active");
			} else {				
				$("#title").focus();
				$("#title").css("IME-MODE", "active");
			}
		})
	});
</script>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>