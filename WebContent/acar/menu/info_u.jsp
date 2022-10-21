<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>
<jsp:useBean id="area_bean" class="acar.user_mng.AreaBean" scope="page"/>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//����ں� ���� ��ȸ �� ���� ������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String filename2 = "";
	String user_aut2 = "";
	String user_work = "";
	String in_tel = "";
	String hot_tel = "";
	String out_dt = "";
	String taste = "";
	String special ="";
	String gundea = "";
	String area_id = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 		= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_i_tel 	= user_bean.getUser_i_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	filename2 	= user_bean.getFilename2();
	user_work 	= user_bean.getUser_work();
	in_tel		= user_bean.getIn_tel();
	hot_tel		= user_bean.getHot_tel();
	out_dt		= user_bean.getOut_dt();
	taste		= user_bean.getTaste();
	special		= user_bean.getSpecial();
	gundea		= user_bean.getGundea();
	area_id		= user_bean.getArea_id();
	
	
	//�μ�����Ʈ ��ȸ
	DeptBean dept_r [] = umd.getDeptAll();
	//��������Ʈ ��ȸ
	BranchBean br_r [] = umd.getBranchAll();
	//�ٹ�������Ʈ ��ȸ
	AreaBean area_r [] = umd.getAreaAll("");
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();	
	
	// * Algorithm AES Encrypt
        //   String message = "1234";
       //    String encSsn = EncryptionUtils.encryptAES(message);
       //   * 
        //  * Algorithm AES Decrypt
        //  * String message = "";
        //  * String encSsn = EncryptionUtils.decryptAES(message); 

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "USERS";
	String content_seq  = user_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
	String file1_yn = "";
	String file2_yn = "";
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��й�ȣ ����
	function ChangePwd(){
		window.open("/fms2/menu/pass_u.jsp?user_id=<%=user_id%>&from_page=info_u.jsp", "PASS", "left=200, top=100, width=400, height=200, scrollbars=yes, status=yes, resizable=yes");
	}
	//���
	function UserAdd(){
		var theForm = document.form1;
		if(!CheckField()){ return; }
		theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;		
		theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
		if(!confirm('����Ͻðڽ��ϱ�?')){ return; }
		theForm.cmd.value= "i";
		theForm.target="i_no";
		theForm.submit();
	}
	//����
	function UserUp(){
		var theForm = document.form1;
		if(!CheckField()){ return; }
		theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;	
		theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
		
		if(theForm.t_zip.value=="")		{		alert("�ֹε���ּ� �����ȣ�� �Է����ϼ���!!.");		theForm.t_zip.focus();			return false;	}
		if(theForm.t_zip.value.length>5)	{	alert("�����ȣ�� 5�ڸ��� ���� �� �����ϴ�.\n\n 5�ڸ� �̻��ϰ�� �����ڿ��� �����ּ���.");			theForm.t_zip.focus();		return false;	}	
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){ return; }
		theForm.cmd.value= "u";
		theForm.target="i_no";
		theForm.submit();
	}
	
	//���
	function UserDel(){
		var theForm = document.form1;
		if(!confirm('���ó�� �Ͻðڽ��ϱ�?')){ return; }
		if(!confirm('���� ���ó�� �Ͻðڽ��ϱ�?')){ return; }		
		if(!confirm('��¥ ���� ���ó�� �Ͻðڽ��ϱ�?')){ return; }				
		theForm.cmd.value= "d";
		theForm.target="i_no";
		theForm.submit();
	}
	//�Է��׸� ����
	function CheckField(){
		var theForm = document.form1;	
		if(theForm.br_id.value=="")		{		alert("������ �����Ͻʽÿ�.");					theForm.br_id.focus();			return false;	}
		if(theForm.dept_id.value=="")		{		alert("�μ��� �����Ͻʽÿ�.");					theForm.dept_id.focus();		return false;	}
		if(theForm.user_nm.value=="")		{		alert("�̸��� �Է��Ͻʽÿ�.");					theFrom.user_nm.focus();		return false;	}
		if(theForm.user_ssn1.value=="")		{		alert("�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.");				theFrom.user_ssn1.focus();		return false;	}
		if(theForm.user_ssn2.value=="")		{		alert("�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�.");				theFrom.user_ssn2.focus();		return false;	}
		if(theForm.id.value=="")		{		alert("ID�� �Է��Ͻʽÿ�.");					theFrom.id.focus();			return false;	}
		if(theForm.user_psd.value=="")		{		alert("��й�ȣ�� �Է��Ͻʽÿ�.");				theFrom.user_psd.focus();		return false;	}
		if(theForm.user_psd.value.length<6)	{		alert("��й�ȣ�� 6�ڸ� �̻��̿��� �մϴ�.");			theForm.user_psd.focus();		return false;	}	
		if(theForm.in_tel.value.length>5)	{		alert("������ȣ�� 5�ڸ��� ���� �� �����ϴ�.\n\n 5�ڸ� �̻��ϰ�� �����ڿ��� �����ּ���.");			theForm.in_tel.focus();		return false;	}	
		<%//if(dept_id.equals("0002")){%>
	//	if(theForm.area_id.value ==""){	alert("�ٹ����� �Է��Ͻʽÿ�.");		theFrom.area_id.focus();		return false;	}
		<%//}%>
		return true;
	}
	
	function CheckPWDField()
{
	var theForm = document.UserForm;
	
	var paramObj = theForm.user_psd_a.value;
	
	var chk_eng = paramObj.search(/[a-zA-Z]/ig);
	var chk_num = paramObj.search(/[0-9]/g);
	var chk_spe = paramObj.search(/[~!@\#$%<>^&*\()\-=+_\']/ig);
	
	if(theForm.user_psd_b.value=="")
	{
		alert("������ ��й�ȣ�� �Է��Ͻʽÿ�.");
		theForm.user_psd_b.focus();
		return false;
	}
	if(theForm.user_psd_a.value=="")
	{
		alert("������ ��й�ȣ�� �Է��Ͻʽÿ�.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_b.value==theForm.user_psd_a.value)
	{
		alert("������,�� ��й�ȣ�� �����մϴ�.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_a.value.length<6)
	{
		alert("��й�ȣ�� 6�ڸ� �̻��̿��� �մϴ�.");	
		theForm.user_psd_a.focus();
		return false;
	}
	if((chk_eng < 0 && chk_num < 0) || (chk_eng < 0 && chk_spe < 0) || (chk_spe < 0 && chk_num < 0))
	{
		alert("��й�ȣ�� ����,����,Ư������ ��\n2���� �̻��� �����̾�� �մϴ�.");	
		theForm.user_psd_a.focus();
		return false;
	}
	
	return true;
}
	
	//���̵��ߺ�üũ
	function CheckUserID(){
		var theForm = document.form1;
		var theForm1 = document.UserIDCheckForm;
		theForm1.user_id.value=theForm.id.value;
		theForm1.cmd.value="ud";
		theForm1.target = "i_no";
		theForm1.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') CheckUserID();
	}	
	
	//�����ø��������� �˾�
	function photo(st){
		var SUBWIN="./info_photo.jsp?user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&file_st="+st;	
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}
	
	function set_o_addr() //�ּ� ��üũ
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.h_zip.value = fm.t_zip.value;
			fm.h_addr.value = fm.t_addr.value;
		}
		else
		{
			fm.h_zip.value = '';
			fm.h_addr.value = '';
		}
	}	
//-->
</script>
<script language="javascript">
		// �ּұ��� & �ִ���� ����
		var minimum = 6;
		var maximun = 12;

		function chkPw(obj, viewObj) {
			var paramVal = obj.value;	

			var msg = chkPwLength(obj);

			if(msg == "") msg = "������ ��й�ȣ �Դϴ�.";

			document.getElementById(viewObj).innerHTML=msg;
		}

		// ���� ���� ����
		function chkPwLength(paramObj) {
			var msg = "";
			var paramCnt = paramObj.value.length;

			if(paramCnt < minimum) {
				msg = "�ּ� ��ȣ ���ڼ��� <b>" + minimum + "</b> �Դϴ�.";
			} else if(paramCnt > maximun) {
				msg = "�ִ� ��ȣ ���ڼ��� <b>" + maximun + "</b> �Դϴ�.";
			} else {
				msg = chkPwNumber(paramObj);
			}

			return msg;
		}

		// ��ȣ ���뼺 �˻�
		function chkPwNumber(paramObj) {
			var  msg = "";

			// Ư�� ���� ���� �̶�� �ּ��� �ٲ� �ֽñ� �ٶ��ϴ�.
			// if(!paramObj.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/))
			if(!paramObj.value.match(/([a-zA-Z0-9])|([a-zA-Z0-9])/)) {
				// msg = "��й�ȣ�� ����, ����, Ư�������� �������� 6~16�ڸ��� �Է����ּ���.";
				msg = "��й�ȣ�� ����, ������ �������� 6~12�ڸ��� �Է����ּ���.";
			} else {
				msg = chkPwContinuity(paramObj);
			}

			return msg;
		}

		// ��ȣ ���Ӽ� �˻� �� ���� ����
		function chkPwContinuity(paramObj) {
			var msg = "";
			var SamePass_0 = 0; //���Ϲ��� ī��Ʈ
			var SamePass_1_str = 0; //���Ӽ�(+) ī���(����)
			var SamePass_2_str = 0; //���Ӽ�(-) ī���(����)
			var SamePass_1_num = 0; //���Ӽ�(+) ī���(����)
			var SamePass_2_num = 0; //���Ӽ�(-) ī���(����)

			var chr_pass_0;
			var chr_pass_1;
			var chr_pass_2;
			
			for(var i=0; i < paramObj.value.length; i++) {
				chr_pass_0 = paramObj.value.charAt(i);
				chr_pass_1 = paramObj.value.charAt(i+1);

				//���Ϲ��� ī��Ʈ
				if(chr_pass_0 == chr_pass_1)
				{
					SamePass_0 = SamePass_0 + 1
				}


				chr_pass_2 = paramObj.value.charAt(i+2);
				
				if(chr_pass_0.charCodeAt(0) >= 48 && chr_pass_0.charCodeAt(0) <= 57) {
					//����
					//���Ӽ�(+) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_num = SamePass_1_num + 1
					}
					
					//���Ӽ�(-) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_num = SamePass_2_num + 1
					}
				} else {
					//����
					//���Ӽ�(+) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_str = SamePass_1_str + 1
					}
					
					//���Ӽ�(-) ī���
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_str = SamePass_2_str + 1
					}
				}
			}
			
			if(SamePass_0 > 1) {
				msg = "���ϼ��� �� ���ڸ� 3�� �̻� ����ϸ� ��й�ȣ�� �������� ���մϴ�.(ex : aaa, bbb, 111)";
			}

			if(SamePass_1_str > 1 || SamePass_2_str > 1 || SamePass_1_num > 1 || SamePass_2_num > 1)
			{
				msg = "���ӵ� ���ڿ�(123 �Ǵ� 321, abc, cba ��)��\n 3�� �̻� ��� �� �� �����ϴ�.";
			}

			return msg;
		}	
		
		
		
		
		
		
		
		
		</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body  onLoad="self.focus()">
<form action="./user_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="filename" value="<%=filename%>">
  <input type="hidden" name="user_ssn" value="">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=450>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > ����ڰ��� > <span class=style5>����ڵ��</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=450>
                <tr>			    	
                    <td class=title width=95>����</td>			    	
                    <td width=130>&nbsp;<select name="br_id">
            			  <option value="">����</option>
        <%    				for(int i=0; i<br_r.length; i++){
                				br_bean = br_r[i];%>
           				  <option value="<%= br_bean.getBr_id() %>"><%= br_bean.getBr_nm() %></option>
        <%					}%>
        				</select>
        				<script language="javascript">
        					document.form1.br_id.value = '<%=br_id%>';
        				</script>
                    </td>			    	
                    <td class=title width=95>�μ�</td>			        
                    <td width=130>&nbsp;<select name="dept_id">
        			      <option value="">����</option>
        <%    				for(int i=0; i<dept_r.length; i++){
                				dept_bean = dept_r[i];%>
           				  <option value="<%= dept_bean.getCode() %>"><%= dept_bean.getNm() %></option>
        <%					}%>								
        				</select>
        				<script language="javascript">
        					document.form1.dept_id.value = '<%=dept_id%>';
        				</script>
                    </td>
			    </tr>
                <tr>
        		    <td class=title>�̸�</td>
        	        <td>&nbsp;<input type="text" name="user_nm" value="<%=user_nm%>" size="15" class=text style='IME-MODE: active' <%if(dept_id.equals("1000")||dept_id.equals("8888")){%>readonly<%}%>></td>			    	
                    <td class=title>�ֹι�ȣ</td>
	    	        <td>&nbsp;<input type="text" name="user_ssn1" value="<%=user_ssn1%>" size="6" maxlength=6 class=text>-<input type="password" name="user_ssn2" value="<%=user_ssn2%>" size="7" maxlength=7 class=text></td>	    
           	    </tr>
           	    <tr>
		            <td class=title>ID</td>
		            <td colspan="3">&nbsp;<input type="text" name="id" value="<%=id%>" size="15" class=text onKeyDown='javascript:enter()' style='IME-MODE: inactive'></td>
				</tr>
				<tr>
		            <td class=title>��й�ȣ</td>
		            <td colspan="3">&nbsp;<input type="password" name="user_psd" value="<%=user_psd%>" size="16" class=whitetext onKeyUp="javascript:chkPw(this, 'chkPwView');" readonly>
					&nbsp;&nbsp;<span id="chkPwView"></span><!-- <br>&nbsp; �غ�й�ȣ�� ����, ������ �������� 6~12�ڸ��� �Է����ּ���.-->
					<input type="button" class="button" id="cng_pw" value='��й�ȣ����' onclick="javascript:ChangePwd();">
					</td>
           	    </tr>
				<!--
           	    <tr>
                    <td class=title>��������</td>
			        <td>&nbsp;<input type="text" name="lic_no" value="<%=lic_no%>" size="15" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'></td>			    	
                    <td class=title>���������</td>
			        <td>&nbsp;<input type="text" name="lic_dt" value="<%=lic_dt%>" size="16" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
           	    </tr>				
				-->
           	    <tr>
		            <td class=title>����ȭ</td>
		            <td>&nbsp;<input type="text" name="user_h_tel" value="<%=user_h_tel%>" size="15" class=text></td>
			        <td class=title>�޴���</td>
			        <td>&nbsp;<input type="text" name="user_m_tel" value="<%=user_m_tel%>" size="16" class=text></td>
           	    </tr>
				<tr>
		            <td class=title>������ȣ</td>
		            <td>&nbsp;<input type="text" name="in_tel" value="<%=in_tel%>" size="15" class=text></td>
			        <td class=title>�繫��(����)</td>
			        <td>&nbsp;<input type="text" name="hot_tel" value="<%=hot_tel%>" size="16" class=text></td>
           	    </tr>
				<!--
           	    <tr>
		            <td class=title>���</td>
		            <td>&nbsp;<input type="text" name="taste" value="<%=taste%>" size="15" class=text></td>
			        <td class=title>Ư��</td>
			        <td>&nbsp;<input type="text" name="special" value="<%=special%>" size="16" class=text></td>
           	    </tr>
           	    <tr>
		            <td class=title>�������ͳݻ���ڹ�ȣ</td>
		            <td>&nbsp;<input type="text" name="user_i_tel" value="<%=user_i_tel%>" size="15" class=text></td>
			        <td class=title>���ʿ���</td>
			        <td>&nbsp;<input type="text" name="gundea" value="<%=gundea%>" size="16" class=text></td>
           	    </tr>
				-->
           	    
				 <tr>
		            <td class=title>����</td>
		            <td>&nbsp;<input type="text" name="user_pos" value="<%=user_pos%>" size="15" class=text style='IME-MODE: active'></td>
			        <td class=title>��å</td>
			        <td>&nbsp;<input type="text" name="" value="<%if(user_id.equals("000004")){%>�ѹ�����<%}else if(user_id.equals("000003")){%>�ӿ�<%}else if(user_id.equals("000005")){%>��������<%}else if(user_id.equals("000026")){%>����������<%}else if(user_id.equals("000237")){%>IT����������<%}%><%//=user_pos%>" size="15" class=text style='IME-MODE: active'></td>
           	    </tr>
            	<tr>
			    	<td class=title>���ȸ���</td>
			    	<td>&nbsp;<input type="text" name="mail_id" value="<%=user_bean.getMail_id()%>" size="15" class=whitetext style="ime-mode:disabled">
                    </td>
			    	<td class=title>���Ϻ��</td>
			    	<td>&nbsp;<%if(nm_db.getWorkAuthUser("������",user_id) || user_id.equals(user_bean.getUser_id())){%><%=umd.getVoaMailPswd(user_bean.getMail_id())%><%}%></td>
            	</tr>
				<tr>
					<td class=title>�Ի�����</td>
			        <td>&nbsp;<input type="text" name="enter_dt" value="<%=enter_dt%>" size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);' readonly></td>
		            <td class=title>���ͳ��ѽ�<br>���Ź�ȣ</td>
		            <td>&nbsp;<input type="text" name="i_fax" value="<%=user_bean.getI_fax()%>" size="15" class=text style="ime-mode:disabled"></td>
           	    </tr>
				    <%if(nm_db.getWorkAuthUser("������",user_id) || user_id.equals(user_bean.getUser_id())){%>
            	<tr>
			    	<td class=title>���ͳ��ѽ�ID</td>
			    	<td>&nbsp;<input type="text" name="fax_id" value="<%=user_bean.getFax_id()%>" size="15" class=whitetext style="ime-mode:disabled">
                    </td>
			    	<td class=title>���ͳ��ѽ�PW</td>
			    	<td>&nbsp;<input type="text" name="fax_pw" value="<%=user_bean.getFax_pw()%>" size="15" ></td>
            	</tr>
				<%}%>
					<%	String email_1 = "";
						String email_2 = "";
						if(!user_email.equals("")){
							int mail_len = user_email.indexOf("@");
							if(mail_len > 0){
								email_1 = user_email.substring(0,mail_len);
								email_2 = user_email.substring(mail_len+1);
							}
						}
					%>													
           	    <tr>
			        <td class=title>�̸���</td>
			        <td colspan=3>&nbsp;
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='15' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  		    <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>�����ϼ���</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">���� �Է�</option>
							    </select>
						        <input type='hidden' name='user_email' value='<%=user_email%>'>
								<!--<input type="text" name="user_email" value="<%=user_email%>" size="53" class=text>-->
								</td>
           	    </tr>
           	    <%if(dept_id.equals("1000")||dept_id.equals("8888")){%>
           	    <input type='hidden' name='loan_st' value='<%=user_bean.getLoan_st()%>'>
           	    <input type='hidden' name='partner_id' value='<%=user_bean.getPartner_id()%>'>
           	    <input type='hidden' name='add_per' value='<%=user_bean.getAdd_per()%>'>
           	    <input type='hidden' name='area_id' value='<%=area_id%>'>
           	    <%}else{%>
           	    <tr>
			        <td class=title>ä������</td>
			        <td>&nbsp;
			            <select name="loan_st">
			        		<option value="">����</option>
			    			<option value="1" <%if(user_bean.getLoan_st().equals("1"))%>selected<%%>>1��</option>
			    			<option value="2" <%if(user_bean.getLoan_st().equals("2"))%>selected<%%>>2��</option>
						</select>
			        </td>
			        <td class=title>ä����Ʈ��</td>
			        <td>&nbsp;
        			    <select name="partner_id">
        			    <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_bean.getPartner_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>
			        </td>
           	    </tr>	
           	    <tr>
		            <td class=title colspan=3>ä����Ʈ�ʰ�����</td>
		            <td>&nbsp;<input type="text" name="add_per" class=text value="<%=user_bean.getAdd_per()%>" size="5" maxlength='5'>%
                    </td>
           	    </tr>
		
           	    <tr>
		            <td class=title>ä�Ǳ׷�</td>
		            <td colspan=3>&nbsp;<select name="area_id">
        			      <option value="">����</option>
        <%    				for(int i=0; i<area_r.length; i++){
                				area_bean = area_r[i];%>
           				  <option value="<%= area_bean.getCode() %>"><%= area_bean.getNm() %></option>
        <%					}%>								
        				</select>
        				<script language="javascript">
        					document.form1.area_id.value = '<%=area_id%>';
        				</script>
		    	            
                    </td>
				</tr>
				<%}%>
		
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.
								// �����ȣ�� �ּ� ������ �ش� �ʵ忡 �ְ�, Ŀ���� ���ּ� �ʵ�� �̵��Ѵ�.
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>�ֹε���ּ�</td>
				  <td colspan=3>
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' readonly  value="<%=user_bean.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					<input type="text" name="t_addr" id="t_addr" size="50" value="<%=user_bean.getAddr()%>" style='IME-MODE: active'>

				  </td>
				</tr>
           	    
				<%//if(user_id.equals("000096")){%>
				<tr>
				  <td class=title>�ǰ������ּ�</td>
				  <script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('h_zip').value = data.zonecode;
								document.getElementById('h_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>	
				  <td colspan=3><input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>��
					<input type="text" name="h_zip" id="h_zip" size="7" maxlength='7' readonly value="<%=user_bean.getHome_zip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
					<input type="text" name="h_addr" id="h_addr" size="50" value="<%=user_bean.getHome_addr()%>" style='IME-MODE: active'>

				  </td>
				</tr>
				
				<%//}%>
           	    <tr>
		            <td class=title>������</td>
		            <td colspan=3>&nbsp;<textarea name="user_work" cols="51" rows="3" class="text" style='IME-MODE: active'><%=user_work%></textarea></td>
           	    </tr>
           	    <tr>
		            <td class=title>FMS ��<br>�λ縻</td>
		            <td colspan=3>&nbsp;<textarea name="content" cols="51" rows="5" class="text"><%=content%></textarea></td>
           	    </tr>
           	    <tr>
		            <td class=title>����<br>(�ܺο�-FMS������&��FMS)</td>
                    <td colspan=3 align="center">
                    
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"1")){
    									file1_yn = "Y";
    									
    						%>
    							<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="85" height="105">    							
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}
    						  if(file1_yn.equals("")){%>
    						<a href="javascript:photo('1');"><img src=../images/pop/button_p_upload.gif border=0 align=absmiddle></a> 
    						<%}%>        			    
                    </td>
                </tr>
           	    <tr>
		            <td class=title>����<br>(���ο�-�����FMS)</td>
                    <td colspan=3 align="center">
                    
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"2")){
    									file2_yn = "Y";
    									
    						%>
    							<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="85" height="105">    														
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}
    						  if(file2_yn.equals("")){%>
    						<a href="javascript:photo('2');"><img src=../images/pop/button_p_upload.gif border=0 align=absmiddle></a> 
    						<%}%>        	
                    </td>
                </tr>				
				<%if(!out_dt.equals("") || nm_db.getWorkAuthUser("������",ck_acar_id)){%>	
           	    <tr>
			        <td class=title>�������</td>
			        <td colspan=3>&nbsp;<input type="text" name="out_dt" value="<%=out_dt%>" size="11" class=text>
			    <%				if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>			  	
				        <a href="javascript:UserDel()"><img src=../images/center/button_out.gif border=0 align=absmiddle></a>
				<%				}%>					
					</td>
           	    </tr>				
				<%}%>
            </table>
        </td>
    </tr>   
    <tr>
        <td>
            <table border="0" cellspacing="2" width=450>
                <tr>
    			    <td align="right">
    <%				if(ck_acar_id.equals(user_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id)){%>			  
    <%					if(user_id.equals("")){%>
    		        <a href="javascript:UserAdd()"><img src=../images/pop/button_reg.gif border=0></a>
    <%					}else{%>
    		        <a href="javascript:UserUp()"><img src=../images/pop/button_modify.gif border=0></a>
    <%					}%>
    <%				}%>    
     		        <a href="javascript:self.close();window.close();"><img src=../images/pop/button_close.gif border=0></a>
    			    </td>
			    </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<form action="/acar/user_mng/user_id_check_null.jsp" name="UserIDCheckForm" method="post">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="h_id" value="<%=id%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>