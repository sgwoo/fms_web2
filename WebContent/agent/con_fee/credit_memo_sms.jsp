<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.fee.*, acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 	= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	
	if(fee_tm.equals("")) fee_tm = "A";
	if(tm_st1.equals("")) tm_st1 = "0";
	
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
	
	if(base.getUse_yn().equals("Y") && memo_st.equals("client")){
		car_mgrs = a_db.getCarMgrClientList(base.getClient_id(), "Y");
		mgr_size = car_mgrs.size();
	}
	
	//���������
	UsersBean user_bean = umd.getUsersBean(base.getBus_id2());
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//��ü����Ȯ�� �� ���ڳ��� �ڵ�����
	function viewSmsMsg3(){
		var fm = document.form1;
		var SUBWIN="view_sms_msg_3.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&client=<%=client%>";	
		window.open(SUBWIN, "ViewSmsMsg", "left=100, top=100, width=850, height=800, scrollbars=yes, status=yes");
	}
	
	//SMS �߼۳���(100���̳��߼ۺ�)
	function viewSmsHistory(){
		var fm = document.form1;
		var SUBWIN="view_sms_history.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&firm_nm=<%=client.getFirm_nm()%>";	
		window.open(SUBWIN, "ViewSmsHis", "left=50, top=100, width=1000, height=800, scrollbars=yes, status=yes");
	}
	
	function display_cng(){
		var fm = document.form1;	
		if(fm.memo_st.value == 'client'){
			fm.memo_st.value = '';
		}else{
			fm.memo_st.value = 'client';		
		}
		fm.action = 'credit_memo_sms.jsp';
		fm.submit();	
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
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='from_page' value='credit_memo'>
<input type='hidden' name='memo_st' value='<%=memo_st%>'>

<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > <span class=style5><%if(memo_st.equals("client")){%>�ŷ�ó ����<%}else{%>��� <%=l_cd%><%}%></span></span></td>	
                    <td class=bar align="right">&nbsp;<a href="javascript:display_cng()">[<%if(memo_st.equals("client")){%>��ະ<%}else{%>�ŷ�ó����<%}%> ����]</a></td>
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
        			  &nbsp;&nbsp;						
					    <select name="s_destphone" onchange="javascript:document.form1.destphone.value=this.value;">
						<option value="">����</option>
        				<%if(!client.getM_tel().equals("")){%>
        				<option value="<%=client.getM_tel()%>">[��&nbsp;&nbsp;&nbsp;ǥ&nbsp;&nbsp;&nbsp;��] <%=client.getM_tel()%> <%=client.getClient_nm()%></option>
        				<%}%>
        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
        				<option value="<%=client.getCon_agnt_m_tel()%>">[���ݰ�꼭] <%=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
        				<%}%>
        				<%if(!site.getAgnt_m_tel().equals("")){%>
        				<option value="<%=site.getAgnt_m_tel()%>">[�������ݰ�꼭] <%=site.getAgnt_m_tel()%> <%=site.getAgnt_nm()%></option>
        				<%}%>
        				<%for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(!mgr.getMgr_m_tel().equals("")){%>
        				<option value="<%=mgr.getMgr_m_tel()%>">[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%></option>
        				<%}}%>	
        				<option value="<%=user_bean.getUser_m_tel()%>">[���������] <%=user_bean.getUser_m_tel()%> <%=user_bean.getUser_nm()%></option>
        			  </select>
        			  &nbsp;&nbsp;���Ź�ȣ : <input type='text' size='15' name='destphone' value='' maxlength='100' class='text'>		
						<!--
        			  &nbsp;&nbsp;
					    [���߼���]
						<br>
        			  &nbsp;&nbsp;						
					    <select name="s_destphone" id="s_destphone" multiple="multiple" style="height:100px;width:300px;">
        				<%if(!client.getM_tel().equals("")){%>
        				<option value="<%=client.getM_tel()%>">[�� ǥ ��] <%=client.getM_tel()%> <%=client.getClient_nm()%></option>
        				<%}%>
        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
        				<option value="<%=client.getCon_agnt_m_tel()%>">[���ݰ�꼭] <%=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
        				<%}%>
        				<%if(!site.getAgnt_m_tel().equals("")){%>
        				<option value="<%=site.getAgnt_m_tel()%>">[�������ݰ�꼭] <%=site.getAgnt_m_tel()%> <%=site.getAgnt_nm()%></option>
        				<%}%>
        				<%for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(!mgr.getMgr_m_tel().equals("")){%>
        				<option value="<%=mgr.getMgr_m_tel()%>">[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%></option>
        				<%}}%>	
        				<option value="<%=user_bean.getUser_m_tel()%>">[���������] <%=user_bean.getUser_m_tel()%> <%=user_bean.getUser_nm()%></option>
						<option value="019-354-2348">[�׽���1] 019-354-2348 ������</option>
						<option value="019-354-2348">[�׽���2] 019-354-2348 ������</option>
        			  </select>
					  &nbsp;&nbsp;<span class=style4>(CtrlŰ�� Ŭ���ϰ� ���콺�� ����)</span>
						<br>
        			  &nbsp;&nbsp;[�����Է�] ���Ź�ȣ : <input type='text' size='15' name='destphone' value='' maxlength='100' class='text'>	
					  -->						  			
					</td>
			    </tr>
                <tr> 
                    <td class='title'>�߽�</td> 
                    <td>
        			  &nbsp;&nbsp;�߽Ź�ȣ : <input type='text' size='15' name='sendphone' value='<%=user_bean.getUser_m_tel()%>' maxlength='100' class='text'>
        			  &nbsp;�߽��ڸ� : <input type='text' size='15' name='sendname' value='<%=user_bean.getUser_nm()%>' maxlength='100' class='text'> 
        			  &nbsp;<input type='checkbox' name="auto_yn" value='Y' checked onClick="javascript:checklen()"><span class=style4> -�Ƹ���ī- ���� ���뿡 �ڵ� ����</span></font>
					</td>
			    </tr>			
                <tr> 
                    <td class='title'>�޼���</td>
                    <td>
					  &nbsp;&nbsp;<a href="javascript:viewSmsMsg3();" title='��ü����Ȯ�� �� ���ڳ��� �ڵ�����'><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>
        			  &nbsp;&nbsp;<textarea name='msg' rows='10' cols='72' class='text' onKeyUp="javascript:checklen()" style='IME-MODE: active'></textarea>
        			  &nbsp;&nbsp;���� <input class="default" type="text" name="msglen" size="3" readonly value=0>byte
					</td>
			    </tr>		
                <tr> 
                    <td class='title'>�����Ͻ�</td>
                    <td>
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
					</td>
			    </tr>										
                <tr> 
                    <td class='title'>����Ÿ��</td>
                    <td>
					  &nbsp;&nbsp;<input type="radio" name="msg_type" value="0" checked> �ܹ���(SMS) <span class=style4>�� 80byte ������ ���� ����</span>
					  | ���࿹��Ǽ� : <input class="default" type="text" name="msg_cnt" size="3" readonly value=0>��
					  <br>
					  &nbsp;&nbsp;<input type="radio" name="msg_type" value="5"> �幮��(MMS) <span class=style4>�� 2000byte�̳� ���ڿ�</span>					  
					  &nbsp;&nbsp;&nbsp;&nbsp;| ���� : <input type='text' size='30' name='msg_subject' value='' maxlength='30' class='text'>&nbsp;(30���̳�)
					</td>
			    </tr>										
            </table>
		</td>
	</tr>	
	<tr>
		<td colspan="2"> 
		  &nbsp;&nbsp;<span class=style4>�� [-�Ƹ���ī- ���� ���뿡 �ڵ� ����]�� ���õǾ��� ��� ��byte�� 10byte�� �߰��Ǿ� ǥ�õ˴ϴ�.</span>
		</td>
	</tr>				
	<tr>
		<td colspan="2" align='right'> 
		  <a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--

checklen();

//�޽��� �Է½� string() ���� üũ
function checklen()
{
	var msgtext, msglen;
	var maxlen = 0;
	
	msgtext = document.form1.msg.value;
	msglen = document.form1.msglen.value;
	
	if(document.form1.auto_yn.checked == false){
		maxlen = 80;
	}else{
		maxlen = 65;
		msgtext = msgtext + '-�Ƹ���ī-';
	}

	maxlen = 2000;
	
	var i=0,l=0;
	var temp,lastl;
	
	//���̸� ���Ѵ�.
	while(i < msgtext.length)
	{
		temp = msgtext.charAt(i);
		
		if (escape(temp).length > 4)
			l+=2;
		else if (temp!='\r')
			l++;
		// OverFlow
		if(l>maxlen)
		{
			alert("�޽������� ��� ���� �̻��� ���� ���̽��ϴ�.\n �޽��������� �ѱ� "+(maxlen/2)+"��, ����"+(maxlen)+"�ڱ����� ���� �� �ֽ��ϴ�.");
			temp = document.form1.msg.value.substr(0,i);
			document.form1.msg.value = temp;
			l = lastl;
			break;
		}
		lastl = l;
		i++;
	}
	form1.msglen.value=l;
	
	
	var msg_cnt = Math.floor(l/80);
	if(l%80 != 0) msg_cnt++;
	form1.msg_cnt.value=msg_cnt;
	
}	
	//���� ������
	function SandSms(){
		var fm = document.form1;				
		if(confirm('���ڸ� �����ðڽ��ϱ�?'))				
		{				
			
			fm.action = "fee_memo_sms.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}
//-->
</script>
</body>
</html>
