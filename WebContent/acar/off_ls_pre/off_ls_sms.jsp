<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.fee.*, acar.cont.*, acar.client.*, acar.user_mng.*, acar.partner.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 	= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String s_destphone = request.getParameter("s_destphone")==null?"0":request.getParameter("s_destphone");
	if(fee_tm.equals("")) fee_tm = "A";
	if(tm_st1.equals("")) tm_st1 = "0";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");
	
	//�α���
	UsersBean user_bean2 = umd.getUsersBean(reg_id);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	if(base.getUse_yn().equals("Y") && memo_st.equals("client")){
		car_mgrs = a_db.getCarMgrClientList(base.getClient_id(), "Y");
		mgr_size = car_mgrs.size();
	}
	
	//���������
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);
	
	String[] pre = request.getParameterValues("pr");
	String msg = "";
	int msglen = 0;
	
	
	int su = 0;
	
	String[] c_id = new String[pre.length];
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	for(int i=0; i<pre.length; i++){
		c_id[i]=  pre[i].substring(0,6);
		
		pre[i] = pre[i].substring(7);
		msg = msg+pre[i]+"\n" ;
		su++;
	}
	msglen = msg.length();
	

	String car_mng_id = "";
	
	//����� Ź�� ���԰���
	Vector vt = se_dt.getServ_offList_Auction();
	int vt_size = vt.size();
	
	//����� Ź�� ���԰��� �����
	Vector vt2 = se_dt.getServ_offList_Auction_Cons();
	int vt_size2 = vt2.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='from_page' value='credit_memo'>
<input type='hidden' name='s_destphone_off' value=''>
<%	
	for(int i=0; i<c_id.length; i++){
		car_mng_id  = c_id[i];		
%>
   <input type="hidden" name="c_id" value="<%=car_mng_id%>">
<%	}%>

<table border="0" cellspacing="0" cellpadding="0" width=450>
	<tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������Ȳ  > <span class=style5>�Ű�����������Ȳ</span></span></td>	
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td colspan="2" class=h></td>
    </tr>		
    <tr>
	    <td>
		  <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���ڹ߼�</span>
		  </td>
	</tr>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=450>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="15%">����</td>
                    <td width=90%>
        			  &nbsp;&nbsp;						
					      <select name="s_destphone" onchange="javascript:document.form1.destphone.value=this.value;">
						      <option value="">����</option>
						      <% for(int i=0; i< vt_size; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
							  %>		
        				      <option value="<%=ht.get("OFF_TEL")%>"><%=ht.get("OFF_NM")%></option>
        				      <% } %>
        				    
        			  </select>
        			  &nbsp;&nbsp;���Ź�ȣ : <input type='text' size='15' name='destphone' value='' maxlength='100' class='text'>		
					</td>
			    </tr>
                <tr> 
                    <td class='title'>�߽�</td>
                    <td>
        			  &nbsp;&nbsp;�߽Ź�ȣ : <input type='text' size='15' name='sendphone' value='<%=user_bean.getUser_m_tel()%>' maxlength='100' class='text'>
        			  &nbsp;�߽��ڸ� : <input type='text' size='15' name='sendname' value='<%=user_bean.getUser_nm()%>' maxlength='100' class='text'> 
					</td>
			    </tr>			
                <tr> 
                    <td class='title'>�޼���</td>
                    <td>
        			  &nbsp;&nbsp;<textarea name='msg' rows='15' cols='60' readOnly class='text' style='IME-MODE: active' ><%=msg%></textarea>					  
					</td>
			    </tr>	
			    <tr> 
                    <td class='title'>����</td>
                    <td width=90%>
	                    <select name="loc" ">
							      <option value="">����</option>
							      <option value="1">����</option>
							      <option value="2">�λ�</option>
							      <option value="3">����</option>
							      <option value="4">�뱸</option>
							      <option value="5">����</option>							      
	        			 </select>
        			</td>
			    </tr>		
            </table>
		</td>
	</tr>	
    <tr> 
        <td colspan="2" class=h></td>
    </tr>			
	<tr>
		<td colspan="2" align='right'> 
		<a href="javascript:SandFaxS()">[����]</a>&nbsp;
		<a href="javascript:SandFaxB()">[�λ�]</a>&nbsp;
		<a href="javascript:SandFaxD()">[����]</a>&nbsp;
		<a href="javascript:SandFaxG()">[�뱸]</a>&nbsp;
		<a href="javascript:SandFaxJ()">[����]</a>&nbsp;
		<a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		<a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>&nbsp;
		<a href="javascript:save_actn_id()">�������</a><!-- ����� ID, ������, ���񼭷� üũ =Y, modify_id = ck_acar_id �����ϵ��� ����. -->
		</td>
	</tr>
    <tr> 
        <td colspan="2" class=h></td>
    </tr>	
   
	<% for(int i=0; i< vt_size; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
	<tr>
		<td><%=ht.get("OFF_NM")%></td>
	</tr>	
	<% 		for(int j=0; j< vt_size2; j++){
				Hashtable ht2 = (Hashtable)vt2.elementAt(j);
				if(String.valueOf(ht2.get("OFF_NM")).equals(String.valueOf(ht.get("OFF_NM")))){					
	%>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp; - <%=ht2.get("EMP_NM")%></td><td>FAX:&nbsp;&nbsp;<%=ht2.get("EMP_FAX")%></td>
	</tr>	
	<%			} %>
	<%		} %>
	
	<%	} %>
							  
</table>
<input type='hidden' name='su' value='<%=su%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
	//���� ������
	function SandSms(){
		var fm = document.form1;				
		if(fm.destphone.value == ''){ alert("������� �����ϼ���."); return;	}
		if(confirm('���ڸ� �����ðڽ��ϱ�?'))				
		{				
			fm.s_destphone_off.value = fm.s_destphone.options[fm.s_destphone.selectedIndex].text;
			fm.action = "off_ls_sms_send.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}
	
	//�����ID����.
	function save_actn_id(){
		var fm = document.form1;				
		if(fm.destphone.value == ''){ alert("������� �����ϼ���."); return;	}
		if(confirm('������� ����Ͻðڽ��ϱ�?'))				
		{				
			fm.s_destphone_off.value = fm.s_destphone.options[fm.s_destphone.selectedIndex].text;
			fm.action = "off_ls_save_actn_id.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}
	
	//�ѽ�������
	function SandFaxS(){
		var fm = document.form1;	
		
		if(!confirm('�ѽ��� �����ðڽ��ϱ�?')){	return;	}
		
		window.open('about:blank', "SendFaxS", "left=0, top=0, width=550, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SendFaxS";
		fm.action = "off_ls_faxS.jsp";
		fm.submit();
	}
	
	function SandFaxB(){
		var fm = document.form1;	
		if(!confirm('�ѽ��� �����ðڽ��ϱ�?')){	return;	}
		
		window.open('about:blank', "SendFaxB", "left=0, top=0, width=550, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SendFaxB";
		fm.action = "off_ls_faxB.jsp";
		fm.submit();
	}
	
	function SandFaxD(){
		var fm = document.form1;				
		if(!confirm('�ѽ��� �����ðڽ��ϱ�?')){	return;	}
		
		window.open('about:blank', "SendFaxD", "left=0, top=0, width=550, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SendFaxD";
		fm.action = "off_ls_faxD.jsp";
		fm.submit();

	}
	function SandFaxG(){
		var fm = document.form1;				
		if(!confirm('�ѽ��� �����ðڽ��ϱ�?')){	return;	}
		
		window.open('about:blank', "SandFaxG", "left=0, top=0, width=550, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SandFaxG";
		fm.action = "off_ls_faxG.jsp";
		fm.submit();

	}
	function SandFaxJ(){
		var fm = document.form1;				
		if(!confirm('�ѽ��� �����ðڽ��ϱ�?')){	return;	}
		
		window.open('about:blank', "SandFaxJ", "left=0, top=0, width=550, height=600, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SandFaxJ";
		fm.action = "off_ls_faxJ.jsp";
		fm.submit();

	}
//-->
</script>
</body>
</html>
