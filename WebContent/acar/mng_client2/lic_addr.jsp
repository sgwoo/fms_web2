<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.client.*,acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����: 
	function update_post(idx){
		var fm = document.form1;
		
		if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
			alert('����� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
			return;
		}
		if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
			alert('�����̿��� ���������ȣ�� ��Ȯ�� �Է��Ͻʽÿ�.');
			return;
		}
		if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
			alert('�����̿��� ���������ȣ �̸��� �Է��Ͻʽÿ�.');
			return;
		}
		if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
			alert('�����̿��� ���������ȣ ���踦 �Է��Ͻʽÿ�.');
			return;
		}
						
		if(confirm('�����Ͻðڽ��ϱ�?')){
			fm.target = 'i_no';
			fm.submit();
		}		
	}
	

//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mgr_st = request.getParameter("mgr_st")==null?"":request.getParameter("mgr_st");	
	
	ClientBean client = al_db.getNewClient(client_id);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//�����̷�
	Vector vt = a_db.getLcRentCngHList(m_id, l_cd, "lic_no");
	int vt_size = vt.size();
	
	//�����̷�
	Vector vt2 = a_db.getLcRentCngHList(m_id, l_cd, "mgr_lic_no");
	int vt_size2 = vt2.size();
		
	//�����̷�
	Vector vt3 = a_db.getLcRentCngHList(m_id, l_cd, "client.lic_no");
	int vt_size3 = vt3.size();		
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' method='post' action='lic_addr_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>

<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mode' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=610>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�ŷ�ó > <span class=style5><%=client.getFirm_nm()%> </span></span></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=610>
                <%if(user_id.equals("000029")){ %>
				<tr>
				  <td colspan=2 class=title>�� ���������ȣ</td>
				  <td>&nbsp;&nbsp;<input type="text" name="view_lic_no" id="view_lic_no" size="30" value="<%=client.getLic_no()%>" readonly class="whitetext"></td>
				</tr>
				<%}%>
				<tr>
				  <td colspan=2 class=title>����� ���������ȣ</td>
				  <td>&nbsp;&nbsp;<input type="text" name="lic_no" id="lic_no" size="30" value="<%=base.getLic_no()%>"></td>
				</tr>
				<tr>
				  <td rowspan='3' class=title width='50'>����<br>�̿���</td>
				  <td class=title width='100'>���������ȣ</td>
				  <td width='460'>&nbsp;&nbsp;<input type="text" name="mgr_lic_no" id="mgr_lic_no" size="30" value="<%=base.getMgr_lic_no()%>"></td>
				</tr>
				<tr>
				  <td class=title>�̸�</td>
				  <td>&nbsp;&nbsp;<input type="text" name="mgr_lic_emp" id="mgr_lic_emp" size="15" value="<%=base.getMgr_lic_emp()%>"></td>
				</tr>
				<tr>
				  <td class=title>����</td>
				  <td>&nbsp;&nbsp;<input type="text" name="mgr_lic_rel" id="mgr_lic_rel" size="15" value="<%=base.getMgr_lic_rel()%>"></td>
				</tr>
                <tr>
                    <td colspan=2 class='title'>�ŷ�ó  ��� �ϰ����� </td>
                    <td>&nbsp;<input type="checkbox" name="all_upchk" value="Y"> 
                    (���� �������� �ŷ�ó�� ��� ����� ���������ȣ �ϰ� �����ϴ� ��) </td>
                </tr>
                <tr>
                    <td colspan=2 class='title'>�� ���� ���� </td>
                    <td>&nbsp;<input type="checkbox" name="all_upchk2" value="Y" checked> 
                    (���� �������� ������-���� ���������ȣ �����ϴ� ��) </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
	    <a href="javascript:update_post();"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp; 
        <a href='javascript:window.close()'><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>	
    <tr> 
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>		  	  
    <tr> 
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="20%" class='title'>������ </td>
                    <td width="20%" class='title'>������</td>
                    <td width="30%" class='title' >�������</td>
                    <td width="15%" class='title' >��������</td>
                    <td width="15%" class='title' >������</td>			  
                </tr>
                <%if(vt_size > 0){
    				for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					String old_value = String.valueOf(ht.get("OLD_VALUE"));
    					String new_value = String.valueOf(ht.get("NEW_VALUE"));%>
                <tr> 
                    <td align="center"><%=old_value%></td>
                    <td align="center"><%=new_value%></td>
                    <td align="center" ><%=ht.get("CNG_CAU")%></td>
                    <td align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%></td>
                    <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%></td>
                </tr>
    		<%  		}
    			}
    		%>		
                <%if(vt_size2 > 0){
    				for (int i = 0 ; i < vt_size2 ; i++){
    					Hashtable ht = (Hashtable)vt2.elementAt(i);
    					String old_value = String.valueOf(ht.get("OLD_VALUE"));
    					String new_value = String.valueOf(ht.get("NEW_VALUE"));%>
                <tr> 
                    <td align="center"><%=old_value%></td>
                    <td align="center"><%=new_value%></td>
                    <td align="center" ><%=ht.get("CNG_CAU")%></td>
                    <td align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%></td>
                    <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%></td>
                </tr>
    		<%  		}
    			}
    		%>		
                <%if(vt_size3 > 0){
    				for (int i = 0 ; i < vt_size3 ; i++){
    					Hashtable ht = (Hashtable)vt3.elementAt(i);
    					String old_value = String.valueOf(ht.get("OLD_VALUE"));
    					String new_value = String.valueOf(ht.get("NEW_VALUE"));%>
                <tr> 
                    <td align="center"><%=old_value%></td>
                    <td align="center"><%=new_value%></td>
                    <td align="center" ><%=ht.get("CNG_CAU")%></td>
                    <td align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CNG_DT")))%></td>
                    <td align="center" ><%=c_db.getNameById(String.valueOf(ht.get("CNG_ID")), "USER")%></td>
                </tr>
    		<%  		}
    			}
    		%>		
            </table>
        </td>
    </tr>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
