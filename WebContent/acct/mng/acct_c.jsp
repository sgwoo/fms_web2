<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acct.* "%>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  	==null?"":request.getParameter("br_id");
	
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	String acct_st 	= request.getParameter("acct_st")	==null?"":request.getParameter("acct_st");	
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");	
	String seq 	= request.getParameter("seq")		==null?"":request.getParameter("seq");	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Hashtable ht = at_db.getStatAcctCase(save_dt, acct_st, s_dt, e_dt, seq);
	
	int value_size = AddUtil.parseInt(String.valueOf(ht.get("VALUE_SIZE")));

	String acc_st_nm = (String)ht.get("ACCT_ST");
	acc_st_nm = acc_st_nm.substring(0,2);
	
	int size = 0;
	
	String content_code = "STAT_ACCT";
	String content_seq  = save_dt+s_dt+e_dt+acct_st+seq;

	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	

%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//��ĵ���
	function reg_file(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&save_dt=<%=save_dt%>&acct_st=<%=acct_st%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&seq=<%=seq%>", "SCAN", "left=300, top=300, width=620, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//�ɻ��û�ϱ�
	function app_save()
	{
		var fm = document.form1;
		
		if(fm.result.value == ''){ alert('Ȯ�ΰ���� �����Ͻʽÿ�.'); return; }
		
		if(confirm('�ɻ��û �Ͻðڽ��ϱ�?')){	
			fm.target = "i_no";	
			fm.action = "/acct/mng/acct_app_a.jsp";	
			fm.submit();
		}
	}		
	
	//�ɻ�Ϸ��ϱ�
	function res_save()
	{
		var fm = document.form1;
		
		if(confirm('�ɻ�Ϸ� �Ͻðڽ��ϱ�?')){			
			fm.target = "i_no";	
			fm.action = "/acct/mng/acct_res_a.jsp";	
			fm.submit();
		}
	}			
	
	//����Ʈ�ϱ�
	function Print()
	{
		var fm = document.form1;
	//	if(<%//=vt_size%> == 0)		{ alert('�˻�����Ÿ�� �����ϴ�. ���� �˻��Ͽ� �ֽʽÿ�.'); 	fm.st_dt.focus(); 	return; }	
		//fm.cmd.value="p";
		fm.target = "_blank";
		fm.action = "/acct/<%=acc_st_nm%>/<%=ht.get("ACCT_ST")%>_print.jsp";	
		fm.submit();
	}
	
		//��ĵ����
	function scan_del(){

			var fm = document.form1;
			
			if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
			fm.action = "del_scan_a.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&save_dt=<%=save_dt%>&acct_st=<%=acct_st%>";
			fm.target = "i_no";
			fm.submit();		

	}
	//-->
</script>
</head>
<script language="JavaScript" src="/include/common.js"></script>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='save_dt' 		value='<%=save_dt%>'>
  <input type='hidden' name='acct_st' 		value='<%=acct_st%>'>
  <input type='hidden' name='s_dt' 		value='<%=s_dt%>'>
  <input type='hidden' name='e_dt' 		value='<%=e_dt%>'>
  <input type='hidden' name='seq' 		value='<%=seq%>'>
  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����������� > <span class=style5>���������������</span></span></td>
            <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=20% class=title>��������</td>
                    <td width=80%>&nbsp;<%=ht.get("SAVE_DT")%></td>
                </tr>
                <tr> 
                    <td class=title>�򰡱Ⱓ</td>
                    <td>&nbsp;<%=ht.get("S_DT")%>~<%=ht.get("E_DT")%></td>
                </tr>
                <tr> 
                    <td class=title>���μ�������</td>
                    <td>&nbsp;<%=ht.get("ACCT_ST")%></td>
                </tr>
                <tr> 
                    <td class=title>�Ϸù�ȣ</td>
                    <td>&nbsp;<%=ht.get("SEQ")%></td>
                </tr>
                <%//for(int i =0; i<value_size; i++){
				
				if(ht.get("ACCT_ST").equals("rc1_c1")){
				%>
                <tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>�ܺνſ�������ȸ���</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>��ȸ����</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
					
                </tr>
                <%}else if(ht.get("ACCT_ST").equals("rc1_c2")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>����ɻ���</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rc2_c1")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
                </tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc1_c4")){%>
				<tr> 
                    <td class=title>��꼭�ۼ�����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>���޹޴���</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("pc2_c1")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>��</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("pc2_c2")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>��</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE8")%></td>
				</tr>
				<tr> 
					<td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc3_c1")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>��</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc3_c2")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>��</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc4_c1")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc4_c2")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>������ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc5_c1")){%>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm1_c1")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm1_c2")){%>
				<tr> 
                    <td class=title>����ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm2_c1")){%>
				<tr> 
                    <td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm3_c1")){%>
				<tr> 
                    <td class=title>��¥</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>Ȯ������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm4_c1")){%>
				<tr> 
                    <td class=title>��¥</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>Ȯ������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm5_c1")){%>
				<tr> 
                    <td class=title>�����ǰ����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>Ź�۽�û�����μ�����ġ����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>��������� �������翩��</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm5_c3")){%>
				<tr> 
                    <td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>ó������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��������� �������翩��</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm6_c1")){%>
				<tr> 
                    <td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>����ó</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("fc1_c2")){%>
				<tr> 
                    <td class=title>�ѹ������� �񱳴������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc1_c3")){%>
				<tr> 
                    <td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>������ڽ��ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc2_c2")){%>
				<tr> 
                    <td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>����ó</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("fc3_c1")){%>
				<tr> 
                    <td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>����ó</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>�����μ���</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>�ѹ�����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc3_c2")){%>
				<tr> 
                    <td class=title>������������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc4_c3")){%>
				<tr> 
                    <td class=title>�ŷ�����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>�ŷ�ó</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>�ŷ��ݾ�</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>��ǥȮ����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc5_c1")){%>
				<tr> 
                    <td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc5_c3")){%>
				<tr> 
                    <td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac1_c1")){%>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�������� �ż�<br/>/�����û�� ���翩��</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>������ȸ����å<br/>/��������</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>������ȸ����å<br/>/��������</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>���� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>������� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac2_c1")){%>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>����μ�</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ����(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>ERP�� ��ǥ����(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>�����μ��� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ����(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac3_c1")){%>
				<tr> 
                    <td class=title>�ش�� or �б�</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>�ݾ�(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>�ݾ�(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ����(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac4_c2")){%>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ�ݾ�(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>�����޿���������ǥ�ݾ�(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ����(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac5_c1")){%>
				<tr> 
                    <td class=title>��꺸��(���Ⱓ)</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>������� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac6_c2")){%>
				<tr> 
                    <td class=title>�ش�б�</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>�ݾ�(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>�ݾ�(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ����(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac7_c2")){%>
				<tr> 
                    <td class=title>���μ����� ǰ�Ǽ���ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>���μ����� ǰ������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>���μ����� ��ǥ�� �ݾ�</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>���μ��Ű� Ȯ������ �ݾ�</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ����</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��������� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac8_c3")){%>
				<tr> 
                    <td class=title>�ΰ���ġ���Ű� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>�ݾ�</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ�ݾ�</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ����</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac10_c4")){%>
				<tr> 
                    <td class=title>�������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ��ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��������� ���� ���翩��</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc1_c1")){%>
				<tr> 
                    <td class=title>�λ��������� ǰ�Ǽ� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>��������� ���� ���� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc2_c2")){%>
				<tr> 
                    <td class=title>ǰ�ǹ�ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>ǰ������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��������� ���� ���� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc2_c3")){%>
				<tr> 
                    <td class=title>�޿�������ǥ����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>��������� ���� ���� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>(A) = (B)���� ����(*)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc4_c1")){%>
				<tr> 
                    <td class=title>�����Ļ���ǥ����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�����Ļ���ǥ���ι�ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��������� ���� ���� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>���� ���� ���� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("mc1_c1")){%>
				<tr> 
                    <td class=title>ȸ��/ȸ��</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�Ǿ�</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��������ȸ ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic1_c1")){%>
				<tr> 
                    <td class=title>������Ʈ��(����)</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�Ⱓ(from ~ to)</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>�ۼ���</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>�ۼ���</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>��ǥ�̻���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic1_c2")){%>
				<tr> 
                    <td class=title>������Ʈ��(����)</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�Ⱓ(from ~ to)</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>(1)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>(2)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>(3)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>(4)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>(5)</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic4_c1")){%>
				<tr> 
                    <td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�۾����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>������(�̻�����)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>�̻��� �߻���<br/> ��� �� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>�̻��� ������ ���<br/> ���� ��ġ ��ȹ</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>�̻��� �߻��� ���<br/> ��ġ �Ϸ� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic4_c2")){%>
				<tr> 
                    <td class=title>�����۾�����</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�����۾���</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>������û��</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>������û��</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>������û����</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��������</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>�̻�߻��� �� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<tr> 
                    <td class=title>�̻�߻��� ���� ��ġ ��ȹ</td>
                    <td>&nbsp;<%=ht.get("VALUE8")%></td>
				</tr>
				<tr> 
                    <td class=title>�̻�߻��� ��ġ �Ϸ� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE9")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic5_c1")){%>
				<tr> 
                    <td class=title>����Ͻ�</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>�����</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>��ֳ���</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>��ֹ߰���</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ�ϷῩ��</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ��</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>��ġ���� ���翩��</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<tr> 
                    <td class=title>��߹�����å ���翩��</td>
                    <td>&nbsp;<%=ht.get("VALUE8")%></td>
				</tr>
				<tr> 
                    <td class=title>������ Ȯ�γ��� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE9")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic6_c1")){%>
				<tr> 
                    <td class=title>����ȭ�� ������å ¡������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>������å �濵�� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>����å������ ������å<br/> �ֱ��� ���俩��</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>����å������ ������å<br/> �����ֱ�</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>�������� ������å��<br/>�ݿ��Ǿ� �ִ��� ����</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic6_c5")){%>
				<tr> 
                    <td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>������</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>����PC</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>����PC�����</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>PC���˰��</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>���˽�����</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic7_c1")){%>
				<tr> 
                    <td class=title>��û��</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>��û��</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>�����μ��� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>���������μ��� ���ο���</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>

				
				<%}%>
                <tr> 
                    <td class=title>������</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%> <%=ht.get("REG_DT")%></td>
                </tr>
                <tr> 
                    <td class=title>÷������</td>
                    <td>&nbsp;                      
                       
							<%if(attach_vt.size() <= 0){%>
								<a href="javascript:reg_file()"><img src=/acct/images/center/button_in_reg.gif align=absmiddle border=0></a>
							<%}else{%>
								<%for(int i=0; i< attach_vt.size(); i++){
									Hashtable at = (Hashtable)attach_vt.elementAt(i);       
								%>
						
							
							<%if(at.get("FILE_TYPE").equals("image/jpeg")||at.get("FILE_TYPE").equals("image/pjpeg")||at.get("FILE_TYPE").equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=at.get("FILE_TYPE")%>','<%=at.get("SEQ")%>');" title='����' ><%=at.get("FILE_NAME")%></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=at.get("SEQ")%>" target='_blank'><%=at.get("FILE_NAME")%></a>
							<%}%>
								<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=at.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
                        <%}%>
                      
                    </td>
                </tr>
                <tr> 
                    <td class=title>Ȯ�ΰ��</td>
                    <td>&nbsp;
                      <%if(String.valueOf(ht.get("APP_ID")).equals("")){%>
                        <select name="result">
	                  <option value="">����</option>
                          <option value="Y">����</option>
                          <option value="N">������</option>
                        </select>
                      <%}else{%>
                        <%if(String.valueOf(ht.get("RESULT")).equals("Y")){%>����<%}%>
                        <%if(String.valueOf(ht.get("RESULT")).equals("N")){%>������<%}%>
                      <%}%>
                    </td>
                </tr>                     
                <%if(!String.valueOf(ht.get("APP_ID")).equals("")){%>           
                <tr> 
                    <td class=title>Ȯ����</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("APP_ID")),"USER")%> <%=ht.get("APP_DT")%></td>
                </tr>
                <%}%>
                <%if(!String.valueOf(ht.get("RES_ID")).equals("")){%>           
                <tr> 
                    <td class=title>�ɻ���</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("RES_ID")),"USER")%> <%=ht.get("RES_DT")%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(String.valueOf(ht.get("APP_ID")).equals("")){%>
    <tr>
      <td align="right">
        <a href="javascript:app_save()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[��Ȯ��]</a>        
      </td>      
    <tr>   
    <%}%>      
    <%if(!String.valueOf(ht.get("APP_ID")).equals("") && String.valueOf(ht.get("RES_ID")).equals("")){%>
    <tr>
      <td align="right">
        <a href="javascript:res_save()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[�ɻ�Ϸ�]</a>        
      </td>      
    <tr>   
    <%}%>
	<%if(!String.valueOf(ht.get("APP_ID")).equals("") && !String.valueOf(ht.get("RES_ID")).equals("")){%>
	<tr>
		<td><a href="javascript:Print();"><img src=/acct/images/center/button_print.gif align=absmiddle border=0></a></td>
	</tr>
	<input type='hidden' name='st_dt' 		value='<%=s_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=e_dt%>'>
  <input type='hidden' name='s_cnt' 		value='1'> 
  <input type='hidden' name="value1" 	value="<%=ht.get("VALUE1")%>">
  <input type='hidden' name="value2" 	value="<%=ht.get("VALUE2")%>">
  <input type='hidden' name="value3" 	value="<%=ht.get("VALUE3")%>">
  <input type='hidden' name="value4" 	value="<%=ht.get("VALUE4")%>">
  <input type='hidden' name="value5" 	value="<%=ht.get("VALUE5")%>">
  <input type='hidden' name="value6" 	value="<%=ht.get("VALUE6")%>">
  <input type='hidden' name="value7" 	value="<%=ht.get("VALUE7")%>">			
  <input type='hidden' name="value8" 	value="<%=ht.get("VALUE8")%>">
  <input type='hidden' name="value9" 	value="<%=ht.get("VALUE9")%>">
  <input type='hidden' name="value10" 	value="<%=ht.get("VALUE10")%>">
  <input type='hidden' name="value11" 	value="<%=ht.get("VALUE11")%>">
  <input type='hidden' name="value12" 	value="<%=ht.get("VALUE12")%>">
  <input type='hidden' name="value13" 	value="<%=ht.get("VALUE13")%>">
  <input type='hidden' name="value14" 	value="<%=ht.get("VALUE14")%>">
  <input type='hidden' name="value15" 	value="<%=ht.get("VALUE15")%>">
  <input type='hidden' name="value16" 	value="<%=ht.get("VALUE16")%>">
  <input type='hidden' name="value17" 	value="<%=ht.get("VALUE17")%>">			
  <input type='hidden' name="value18" 	value="<%=ht.get("VALUE18")%>">
  <input type='hidden' name="value19" 	value="<%=ht.get("VALUE19")%>">
  <input type='hidden' name="value20" 	value="<%=ht.get("VALUE20")%>">
  
	<%}%>
		
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>