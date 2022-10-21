<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String chk = request.getParameter("chk")==null?"":request.getParameter("chk");  //�����Է� ����
	String bb_chk = request.getParameter("bb_chk")==null?"":request.getParameter("bb_chk");  //������ ����
	String t_chk = request.getParameter("t_chk")==null?"":request.getParameter("t_chk");  //���� ��ȭ
	
	if (!bb_chk.equals("") &&  !t_chk.equals("") ) {
		bb_chk = "";
	}
	
	EstiDatabase e_db = EstiDatabase.getInstance(); 
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	u_bean = umd.getUsersBean(user_id);
	
	e_bean = e_db.getEstiSpeCase(est_id);
	

%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript">
<!--

	function tell_save(gubun){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.user_id.value == ''){ alert('user_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		
		
		if(gubun=='00')	{
			fm.note.value = "��ȭ��";
			fm.gubun.value = "0";
		} else if(gubun=='01')	{
		   fm.note.value = "������";
		   fm.gubun.value = "1";
		} else if(gubun=='02')  {
			fm.note.value = "���(�߸��ȹ�ȣ)";
		 	fm.gubun.value = "2";
		} else if(gubun=='19')  {
		alert(gubun);
			fm.note.value = "������ ���ڹ߼�";
		 	fm.gubun.value = "1";
		}
		
	//	if(!confirm('����Ͻðڽ��ϱ�?')){	return; }	
		fm.action = "guest_memo_null_ui.jsp";		
		fm.target = "i_no";
		fm.submit();
	}
	
	function save(){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.user_id.value == ''){ alert('user_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.note.value == ''){ 	alert('��ȭ������ �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(!confirm('����Ͻðڽ��ϱ�?')){	return; }					
		fm.target = "i_no";
		fm.submit();
	}
	
	function change(arg){
		var fm = document.form1;
		//arg = trim(arg);
	//	if(arg=='00')		fm.note.value = "��ȭ��";
	//	else if(arg=='01')	fm.note.value = "������";
	//	else if(arg=='02')	fm.note.value = "���(�߸��ȹ�ȣ)";
		
		
		if(arg=='03')	fm.note.value = "���׳�";
		else if(arg=='04')	fm.note.value = "����� ��Ȯ��";
		else if(arg=='05')	fm.note.value = "�������";
		else if(arg=='06')	fm.note.value = "������ü";
		else if(arg=='07')	fm.note.value = "�ܱ�뿩";
		else if(arg=='08')	fm.note.value = "�񱳰�����";
		else if(arg=='09')	fm.note.value = "����������ȸ";
		else if(arg=='10')	fm.note.value = "�����ü���������";
		else if(arg=='11')	fm.note.value = "Ÿ�緻Ʈ(����)�� �����";
		else if(arg=='12')	fm.note.value = "�Һα�����";
		else if(arg=='13')	fm.note.value = "��Ⱓ����";
		else if(arg=='14')	fm.note.value = "�̸�������";
		else if(arg=='15')	fm.note.value = "��������";
		else if(arg=='16')	fm.note.value = "���ü��";
		else if(arg=='17')	fm.note.value = "������";
		else if(arg=='18')	fm.note.value = "��Ÿ";
		else if(arg=='19')	fm.note.value = "�����߹��ڹ߼�";
	}
	
	//���ڳ��� �߼��ϱ�
function msg_send(){ 
	fm = document.form1;
	
	if(!confirm("[�Ƹ���ī ������ ��ȭ��Ƚ��ϴ�. ���ں��ø� ���� ��Ź�帳�ϴ�.] ������ ���� ���ڳ����� �߼��Ͻðڽ��ϱ�?"))	return;
	fm.target = "i_no";
		
	fm.action = "send_case.jsp";
	fm.submit();		
	tell_save("19");
}
	
//-->
</script>
</head>
<body leftmargin="15" >
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �����ý��� > <span class=style5>����㳻��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
	    <td class="line">
    	    <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr>
                    <td class=title width=20%>�ۼ���</td>
<%
	UsersBean user_bean = umd.getUsersBean(e_bean.getReg_id());
%>                    
                    <td width=30% >&nbsp;<%=user_bean.getUser_nm()%></td>
                    <td class=title width=20%>�ۼ�����</td>
                    <td width=30% >&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%></td>
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
	    <td class="line">
    	    <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr>
                    <td class=title width=20%>����/���θ�</td>
                    <td colspan="3">&nbsp;<%=e_bean.getEst_nm()%></td>
                </tr>
                 <tr>
                    <td class=title width=20%>�����</td>
                    <td width=30%>&nbsp;<%=e_bean.getEst_agnt()%></td>
                    <td class=title width=20%>��ȭ��ȣ</td>
                    <td width=30%>&nbsp;<%=e_bean.getEst_tel()%></td>
                </tr>
                <tr>
                    <td class=title width=20%>��Ÿ��û����</td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=e_bean.getEtc()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    <tr>
    	<td>&nbsp;</td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
                    <td class=line2></td>
                </tr>
				<tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 cellpadding="0" width="100%">
                            <tr> 
                                <td class=title width=22%>��¥</td>
                                <td class=title width=14%>�ۼ���</td>
                                <td class=title width=64%>��ȭ����</td>
                            </tr>
                        </table>					
                    </td>					
                    <td width=17>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td>
	        <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./guest_memo_i_in.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>" name="i_in" width="100%" height="150" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>    
    <tr>
    	<td class=h></td>
    </tr>
<form action="./guest_memo_null_ui.jsp" name="form1" method="POST" >
 <input type="hidden" name="user_id" value="<%=user_id%>">
 <input type="hidden" name="est_id" value="<%=est_id%>">
 <input type="hidden" name="cmd" value="">
 <input type="hidden" name="gubun" value="">
 
<input type="hidden" name="sendname" value="<%=u_bean.getUser_nm()%>">
<input type="hidden" name="sendphone" value="<%=u_bean.getUser_m_tel()%>">
<input type="hidden" name="user_pos" value="<%=u_bean.getUser_pos()%>">
<input type="hidden" name="destphone" value="<%=e_bean.getEst_tel()%>">
<input type="hidden" name="destname" value="<%=e_bean.getEst_agnt()%>">
<input type="hidden" name="msg_type" value="0">
<input type="hidden" name="msgs" value="">
 
<% if ( chk.equals("1") || !bb_chk.equals("")  ) {%> 
 	<tr>
        <td></td>
    </tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ȭ���� ���� Ŭ��</span></td>
	</tr>
	
    <tr></tr>
    <tr></tr>
    <tr>    	
    <td align="left">   
    <a href="javascript:tell_save('00')"><img src=/acar/images/center/button_call_con.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
    <a href="javascript:tell_save('01')"><img src=/acar/images/center/button_call_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
    <a href="javascript:tell_save('02')"><img src=/acar/images/center/button_call_nnum.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
	<a href="javascript:msg_send()">[�����߹��ڹ߼�]</a>&nbsp;&nbsp; 
     </td>
    </tr>
    <tr></tr>
	<tr><td><font color=red>***</font>&nbsp;[��ȭ����]�� ��ȭ�� �õ��ϴ� ������ ������ ���� ��� ��û�� ���� ��ȭ�� ����� ������ Ŭ���� �Ͽ��� �մϴ�.</td></tr>
	<tr></tr>
<% } %>	
	
	<tr>
    <td></td>
    </tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����� �Է�</span></td>
	</tr>
	
	<tr></tr>
 	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>                   
            
                <tr>
                    <td class=title width=18% rowspan="2"></td>
                    <td>&nbsp;<textarea name="note" cols=77 rows=4 onBlur="javascript:change(this.value);" class=default></textarea></td>
                </tr>
                <tr>
                    <td style="font-size:8pt; height:53;">
					&nbsp;03:���׳� 04:����ڹ�Ȯ�� 05:������� 06:������ü 07:�ܱ�뿩 08:�񱳰�����<br> 
					&nbsp;09:����������ȸ 10:�����ü���������� 11:Ÿ�緻Ʈ(����)�ΰ���� 12:�Һα�����<br>
					&nbsp;13:��Ⱓ���� 14:�̸������� 15:�������� 16:���ü�� 17:������ 18:��Ÿ 19:�����߹��ڹ߼�</td>
                </tr>
               			
           </table>
        </td>
    </tr>
    
</form>
	<tr></tr>
	<tr><td><font color=red>***</font>&nbsp;����� ��ȣ�� ����Ͻø� ���մϴ�.</td></tr>
<% if ( chk.equals("1") || !bb_chk.equals("") ) {%> 	
<% } else {%> 
	<tr><td><font color=red>***</font>&nbsp;Ư���� �Է��� ������� ������ [�ݱ�]�� �ٷ� Ŭ���ϼŵ� �˴ϴ�.</td></tr>
<% } %>	
    <tr>    	
    <td align="right">   
    <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
    <a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>