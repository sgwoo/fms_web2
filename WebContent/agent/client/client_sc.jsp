<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
   	//��ũ���� �ΰ��̻��ΰ�� ����
   	
	int cnt = 2; //�˻� ���μ�
    	int sh_height = cnt*sh_line_height;
  	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-150;//��Ȳ ���μ���ŭ ���� ���������� ������
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc 	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	String incom_dt = request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq	= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "22", "01", "01");
	
	Hashtable stat = l_db.getClientStat(s_kd, t_wd);
	
	if(!from_page.equals("")){
		height = 450;
	}	

	if(height <100) height = 467;
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//�ŷ�ó ���� 
	function view_client(client_st, client_id, from_page, firm_nm, client_nm, o_zip, o_addr, enp_no, ssn, lic_no)
	{
		var fm = document.form1;
		
		//��ü�ݾ��� �ִ��� Ȯ���Ѵ�.
		if (from_page == '/agent/lc_rent/lc_reg_step2.jsp' || from_page == '/agent/lc_rent/lc_cng_client_c.jsp' ){
			if(fm.client_id.value != client_id && fm.badamt_chk.value == ''){
				alert(firm_nm+' ���� ��ü�ݾ��� ���� [Ȯ��] �Ͻʽÿ�.');
				return;
			}
		}
				
		if (from_page == '' ){		   
			fm.client_id.value = client_id;
			fm.target = "d_content";
			fm.action = "client_c.jsp";
			fm.submit();
		} else {
			fm.client_id.value = client_id;
			if (from_page == '/agent/lc_rent/lc_reg_step2.jsp' || from_page == '/agent/lc_rent/lc_cng_client_c.jsp' ){
				if(client_st=='2' && ssn.length < 13 ){
					if(!confirm('���ΰ��ε� �ֹε�Ϲ�ȣ�� ��� �Էµ��� �ʾҽ��ϴ�. �ѹ��� ��꼭��������� ������û�� �� ���ּ���'))		return;
				}
				parent.opener.form1.client_st.value = client_st;	
				if(parent.opener.form1.lic_no.value != '' && lic_no != '' && parent.opener.form1.lic_no.value!=lic_no){
					if(confirm('���� ������ ���� ���������ȣ ������ �ֽ��ϴ�. �� ������ �����ðڽ��ϱ�?')){
						parent.opener.form1.lic_no.value = lic_no;
					}
				}else if(parent.opener.form1.lic_no.value == '' && lic_no != ''){
					parent.opener.form1.lic_no.value = lic_no;
				}				
			}
				
			if(client_st == '1'){
				parent.opener.tr_client_guar_st.style.display	= '';
				if(ssn == ''){
					parent.opener.tr_lic_no1.style.display	= '';
				}else{
					parent.opener.tr_lic_no1.style.display	= 'none';	
				}					
				parent.opener.tr_lic_no2.style.display	= 'none';
				parent.opener.tr_lic_no3.style.display	= '';		
			}else{
				parent.opener.tr_client_guar_st.style.display	= 'none';
				parent.opener.tr_lic_no1.style.display	= '';
				parent.opener.tr_lic_no2.style.display	= '';
				parent.opener.tr_lic_no3.style.display	= '';
			}
			
			parent.opener.tr_client_share_st.style.display	= '';	
			
			parent.opener.form1.client_id.value = client_id;
			parent.opener.form1.client_nm.value = client_nm;
			parent.opener.form1.firm_nm.value = firm_nm;
			parent.opener.form1.t_zip[0].value = o_zip;
			parent.opener.form1.t_addr[0].value = o_addr;						
			parent.opener.form1.tax_agnt.value = client_nm;
			parent.opener.form1.ssn.value = ssn;
			parent.self.close();
		}	
	}
	
	//�ŷ�ó ���
	function reg_client(from_page)
	{
		var fm = document.form1;	
		if (from_page == '' ){
			fm.target = "d_content";
			fm.action = "client_i.jsp";
			fm.submit();
		}else{
			fm.target = "CLIENT";
			fm.action = "client_i.jsp";
			fm.submit();
		}		
	}
	

	//�ŷ�ó ��ü�ݾ�
	function cl_dlyamt(client_id)
	{
		var fm = document.form1;	
		window.open('/acar/account/stat_settle_sc_in_view_sub_list_client.jsp?from_page='+document.form1.from_page.value+'&client_id='+client_id, "CLIENT_DLVAMT", "left=10, top=10, width=1200, height=560, resizable=yes, scrollbars=yes, status=yes");
	}
	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body leftmargin="15">

<form name='form1' method='post' target='d_content' action='/agent/client/client_c.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type="hidden" name="incom_dt" value="<%=incom_dt%>">
<input type="hidden" name="incom_seq" value="<%=incom_seq%>">
<input type="hidden" name="s_height" 		value="<%=s_height%>">
<input type="hidden" name="emp_top_height" 	value="<%=emp_top_height%>">
<input type='hidden' name='badamt_chk_from' value='client_sc.jsp'>
<input type='hidden' name='badamt_chk' value=''> 


<table border="0" cellspacing="0" cellpadding="2" width='100%'>
<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	<tr>
		<td align='right'><a href="javascript:reg_client('<%=from_page%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>
<%	}%>
	
	<tr>	
		<td>
			<iframe src="/agent/client/client_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" >
			</iframe>
		</td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>
</table>
</form>
</body>
</html>
