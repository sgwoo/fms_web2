<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.user_mng.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "09");
	
	int cnt = 4; //��Ȳ ��� ������ �Ѽ�
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-250;//��Ȳ ���μ���ŭ ���� ���������� ������
		
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//��ü���
	function all_tax(){
		var fm = inner.document.form1;	
		fm.reg_st.value = "all";
		fm.reg_gu.value = "1";
		fm.mail_auto_yn.value = document.form1.mail_auto_yn.value;
		
		if(confirm('û������ ���� �����Ͻðڽ��ϱ�?')){
			fm.target = "i_no";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();	
		}
		
		fm.tax_out_dt.value = '';									
	}
	//�������
	function select_tax(){
		var fm = inner.document.form1;	
		fm.reg_st.value = "select";				
		fm.reg_gu.value = "1";	
		fm.mail_auto_yn.value = document.form1.mail_auto_yn.value;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("���ݰ�꼭�� ������ ����� �����ϼ���.");
			return;
		}	
		
		fm.tax_out_dt.value = document.form1.tax_out_dt.value;
		
		if(confirm('û������ ���� �����Ͻðڽ��ϱ�?')){
			fm.target = "i_no";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();	
			
			fm.tax_out_dt.value = '';				
		}
	}	
	
	//��ü ���ռ������
	function select_tax_case(){
		var fm = inner.document.form1;	
		fm.reg_st.value = "select";				
		fm.reg_gu.value = "2";		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("���ݰ�꼭�� ������ ����� �����ϼ���.");
			return;
		}	
		
		if(document.form1.tax_out_dt.value == ''){ alert('���� ������ �������ڸ� �Է��Ͻʽÿ�.'); return; }
		
		fm.tax_out_dt.value = document.form1.tax_out_dt.value;
				
		if(confirm('û���� �� ��꼭�� �����մϴ�. �½��ϱ�?')){
			fm.target = "d_content";	
			fm.action = "tax_reg_step1_case.jsp";
			fm.submit();	
			
			fm.tax_out_dt.value = '';		
		}
	}	
		

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td>	  
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <select name="mail_auto_yn">
        <option value="Y">�ŷ����� ����� ���� �ڵ��߼�</option>
        <option value="N">�ŷ����� ������ ���� �����߼�</option>
      </select>
	   <a href="javascript:select_tax();" title='���ù���'><img src="/acar/images/center/button_stbh.gif" align="absmiddle" border="0"></a>&nbsp;
	   <a href="javascript:all_tax();" title='��ü����'><img src="/acar/images/center/button_jcbh.gif" align="absmiddle" border="0"></a>&nbsp;	   
	  <%	if(nm_db.getWorkAuthUser("ȸ�����",user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  /&nbsp;�������� : <input type='text' name='tax_out_dt' value='' size='11' class=text>&nbsp;
	  <a href="javascript:select_tax_case();" title='���չ���'><img src=/acar/images/center/button_rep_all.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	  <%	}%>	   
	  <%}%>	  
	  &nbsp;* ���ǿ����� ��� ȸ���������� ó��
	  </td>
    </tr>  
    <tr> 
      <td height="<%=height%>"><iframe src="issue_1_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td><!--����ͳ��� - sh ���� - ��ܸ޴� ���� - (���μ�*40)-->
    </tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
