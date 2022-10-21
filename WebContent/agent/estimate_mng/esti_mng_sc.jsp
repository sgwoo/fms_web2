<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//��Ȳ ���μ���ŭ ���� ���������� ������
		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--


	//��������ϱ�
	function select_print(){
		var fm = EstiList.document.form1;	
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
		 	alert("������ �����ϼ���.");
			return;
		}	
		
		alert("�μ�̸������ ������ Ȯ���� ����Ͻñ⸦ �����մϴ�.");
				
		fm.target = "_blank";
		fm.action = "/acar/main_car_hp/esti_doc_select_print.jsp";
		fm.submit();	
	}
		
	//���ø��Ϲ߼�
	function select_email(){
		var fm = EstiList.document.form1;	
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
		 	alert("������ �����ϼ���.");
			return;
		}	
		
		fm.target = "_blank";
		fm.action = "/acar/apply/select_mail_input.jsp";
		fm.submit();	

	}		

	//���û����ϱ�
	function select_delete(){
		var fm = EstiList.document.form1;	
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
		 	alert("������ ������ �����ϼ���.");
			return;
		}	
		
		if(!confirm('�����Ͻðڽ��ϱ�? ������ �ۼ��ڿ� ������ ��쿡�� �����մϴ�.')){	return; }
		
		fm.cmd.value = 'select_delete';		
		
		fm.target = "i_no";
		fm.action = "esti_mng_d_a.jsp";
		fm.submit();	

	}		

//-->
</script>
</head>
<body> 
<form name='form1' action='' method='post'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>	  
	   	<a href="javascript:select_print();" title='���� ����ϱ�'><img src=/acar/images/center/button_print_se.gif align=absmiddle border=0></a>&nbsp;
	   	<a href="javascript:select_email();" title='���� ���Ϲ߼��ϱ�'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>&nbsp;	   	   	
	   	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   	<a href="javascript:select_delete();" title='���� �����ϱ�'><img src=/acar/images/center/button_delete_s.gif align=absmiddle border=0></a>&nbsp;	   	
	  </td>
    </tr>  
  <tr>
	<td>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
		  <tr>
			<td colspan=2><iframe src="./esti_mng_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&gubun5=<%=gubun5%>&gubun6=<%=gubun6%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>" name="EstiList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
		  </tr>								
	  </table>
    </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>