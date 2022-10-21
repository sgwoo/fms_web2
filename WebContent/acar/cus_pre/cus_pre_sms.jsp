<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.fee.*, acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"1":request.getParameter("c_id");
	String car_no 	= request.getParameter("car_no")==null?"1":request.getParameter("car_no");	

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String destphone = "";

	UserMngDatabase umd = UserMngDatabase.getInstance();
	
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
	
	
	
	//���������
	UsersBean user_bean = umd.getUsersBean(base.getMng_id());
	
	if(base.getCar_st().equals("4")){
		user_bean = umd.getUsersBean(base.getMng_id2());
	}
	
	//�ܱ����� ��� ������ �߽���
	//if(!user_bean2.getLoan_st().equals("")){
	//	user_bean = user_bean2;
	//}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//SMS �߼۳���(100���̳��߼ۺ�)
	function viewSmsHistory(){
		var fm = document.form1;
		var SUBWIN="/fms2/con_fee/view_sms_history.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&firm_nm=<%=client.getFirm_nm()%>";	
		window.open(SUBWIN, "ViewSmsHis", "left=50, top=100, width=1000, height=800, scrollbars=yes, status=yes");
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ں�����������Ȳ > <span class=style5>���ڹ߼�</span></span></td>	
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
	    <td align='right'>
			  <a href="javascript:viewSmsHistory();" title='SMS �߼۳���'>[SMS �߼۳���]</a>
		  </td>		  
	</tr>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=750>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width="10%">����</td>
                    <td width=90%>
        			 
        				<%for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(mgr.getMgr_st().equals("�����̿���")){
							destphone = mgr.getMgr_m_tel()+""; %>
        				&nbsp;&nbsp;[<%=mgr.getMgr_st()%>]  <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%>
        				<%}}%>	
        			  &nbsp;&nbsp;���Ź�ȣ : <input type='text' size='15' name='destphone' value='<%=destphone%>' maxlength='100' class='text'>	
					  <input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
					  <input type='hidden' name='car_no' value='<%=car_no%>'>
						
					</td>
			    </tr>
                <tr> 
                    <td class='title'>�߽�</td>
                    <td>
        			  &nbsp;&nbsp;�߽Ź�ȣ : <input type='text' size='15' name='sendphone' value='<%=user_bean.getUser_m_tel()%>' maxlength='100' class='text'>
        			  &nbsp;�߽��ڸ� : <input type='text' size='15' name='sendname' value='<%=user_bean.getUser_nm()%>' maxlength='100' class='text'> 
        			  &nbsp;</font>
					</td>
			    </tr>			
                <tr> 
                    <td class='title'>�޼���</td>
                    <td>
        			  &nbsp;&nbsp;<textarea name='msg' rows='10' cols='72' class='text' onKeyUp="javascript:checklen()" style='IME-MODE: active' readOnly><%=client.getFirm_nm()%>���� �ȳ��Ͻʴϱ�. ģ���� �ŷڷ� ��ô� �Ƹ���ī�Դϴ�. 

������ �̿����� �ڵ���(<%=car_no%>)�˻� �ǽø� ���� ��� ���¾�ü���� ���Կ��� �����帱 �����Դϴ�. 
������ ������ ���������� ���� ���� ��Ź�帳�ϴ�. �����մϴ�. 

(��)�Ƹ���ī www.amazoncar.co.kr </textarea>
        			 
					</td>
			    </tr>	
				 <tr> 
                    <td class='title'>�����Ͻ�</td>
                    <td colspan="4">
					  &nbsp;&nbsp;<input type="text" name="req_dt" size="12" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'>
					                                    <select name="req_dt_h">
                        									<%for(int i=0; i<24; i++){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        									<%}%>
                      									</select>
                      									<select name="req_dt_s">
                        									<%for(int i=0; i<59; i+=5){%>
                        									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                        									<%}%>
                     									 </select>
                     									 <input type="hidden" name="msg_type" value="5"> 			  
														<input type='hidden' size='30' name='msg_subject' value='' maxlength='30' class='text' value="���� �˻� �ȳ� ����">
					</td>
              


			    </tr>										
            </table>
		</td>
	</tr>	
	 
	<tr>
		<td colspan="2" align='right'> 
		  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		  <%}%>
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>			
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--

	//���� ������
	function SandSms(){
		var fm = document.form1;				
		if(confirm('���ڸ� �����ðڽ��ϱ�?'))				
		{				
			
			fm.action = "/acar/cus_pre/cus_pre_sms_a.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}
//-->
</script>
</body>
</html>
