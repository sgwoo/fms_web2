<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���γ��� ����
	function view_tax(m_id, l_cd, c_id, seq, rent_mon, cls_st)
	{
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.c_id.value = c_id;
		fm.seq.value = seq;
		fm.rent_mon.value = rent_mon;		
		fm.cls_st.value = cls_st;				
		if(seq == ''){
			fm.action = 'tax_scd_i.jsp';
		}else{
			fm.action = 'tax_scd_u.jsp';
		}
		fm.target= 'd_content';
		fm.submit();
	}

	//����Ʈ ���� ��ȯ
	function pop_excel(idx){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "popup_excel"+idx+".jsp";
		fm.submit();
	}	
				
	//�����ٰ��� �̵�
	function tax_scd(){
		var fm = document.form1;
		fm.gubun2.value = '5';
		fm.gubun3.value = '2';		
		fm.sort_gubun.value = "3";
		fm.asc.value = "1";
		fm.target = "d_content";
		fm.action = "tax_scd_frame_s.jsp";
		fm.submit();
	}	
	
	//�����ٰ��� �̵�
	function stat_tax(){
		var fm = document.form1;
		fm.gubun2.value = '5';
		fm.gubun3.value = '2';		
		fm.sort_gubun.value = "3";
		fm.asc.value = "1";
		fm.target = "d_content";
		fm.action = "stat_tax_frame_s.jsp";
		fm.submit();
	}				
-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	LoginBean login = LoginBean.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?login.getCookieValue(request, "acar_id"):request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-70;//��Ȳ ���μ���ŭ ���� ���������� ������
%>
<form name='form1' action='/acar/con_tax/tax_pay_sc.jsp' target='' method='post'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='cls_st' value=''>
<input type='hidden' name='rent_mon' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='est_mon' value='<%=est_mon%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='pay'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width='800'>
<tr> </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width='800'>
	<tr>
		<td align='right' width='800'>
<%//if(auth_rw.equals("R/W")){%>
<%//	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
<!--			<a href='javascript:tax_scd()' onMouseOver="window.status=''; return true">������ �ۼ� ����Ʈ </a>-->
<%//	}%>
			<a href='javascript:stat_tax()' onMouseOver="window.status=''; return true">�����Һ� ������Ȳ</a>
<%if(gubun3.equals("2")){%>
			&nbsp;&nbsp;<input type="button" name="excel1" value="���뿩_Excel" onClick="javascript:pop_excel(1);" size="14">
			&nbsp;<input type="button" name="excel2" value="�Ű�_Excel" onClick="javascript:pop_excel(2);" size="10">
<%	}else{%>	
			&nbsp;&nbsp;<input type="button" name="excel3" value="���뿩_Excel" onClick="javascript:pop_excel(3);" size="14">
			&nbsp;<input type="button" name="excel4" value="�Ű�_Excel" onClick="javascript:pop_excel(4);" size="10">
<%	}%>			
		</td>
	</tr>
	<tr>
		<td>
		<%if(!gubun2.equals("5")){%>
		<%	if(gubun3.equals("2")){%>
			<iframe src="/acar/con_tax/tax_pay_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="800" height="450" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='yes' marginwidth='0' marginheight='0'></iframe>
		<%	}else{%>			
			<iframe src="/acar/con_tax/tax_est_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="800" height="450" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='yes' marginwidth='0' marginheight='0'></iframe>		
		<%	}
		  }else{%>					
			<iframe src="/acar/con_tax/tax_reg_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&auth=<%=auth%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&est_mon=<%=est_mon%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="i_no" width="800" height="450" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='yes' marginwidth='0' marginheight='0'></iframe>		
		<%	}%>		  
		</td>
	</tr>
	<tr>
	</tr>
	<tr>
		<td width='800'>* ���λ����߻����� : ���뿩 = �뿩���� 6���� �������� / �Ű� = �Ű�����</td>
	</tr>
	

      </table>
    </td>
  </tr>
</table>
</form>
</body>
</html>