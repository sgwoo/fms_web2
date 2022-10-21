<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.client.*, acar.cus_pre.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String gs_s_dt 	= request.getParameter("gs_s_dt")==null?"":request.getParameter("gs_s_dt");
	String gs_e_dt 	= request.getParameter("gs_e_dt")==null?"":request.getParameter("gs_e_dt");
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String rent_mng_id = c_db.getRent_mng_id(rent_l_cd);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//���������
	UsersBean user_bean = umd.getUsersBean(base.getBus_id2());
	
	String sms_msg = "";
	
	
	sms_msg =client.getFirm_nm()+" ����. ������ȣ " + car_no+  "�� �ڵ��� �˻� �������� " +gs_s_dt+"���� " + gs_e_dt + "���� �Դϴ�. ����� " + user_bean.getUser_nm() + ". ����ó " + user_bean.getUser_m_tel() + ". ��ȭ��ư�� �����ø� ����ڿ��� ����˴ϴ�.";

	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='/acar/cus_pre/cus_pre_sc_gs_send_sms.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > ������������ > ����ں�����������Ȳ > <span class=style5>���ں�����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>
			 <table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
			        <td class=line2></td>
			    </tr>
			 	<tr>
			 		<td class='line'>
			 			<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<tr>
								<td width=20% class='title'>����ȣ</td>
								<td width=25%>&nbsp;<%=rent_l_cd%></td>
								<td width=18% class='title'>��ȣ</td>
								<td width=37%>
								    <table border="0" cellspacing="0" cellpadding="3" width=100%>
							            <tr><td><%=client.getFirm_nm()%></td>
							            </tr>
							        </table>
							    </td>
							</tr>
						  </table>
					  </td>
			    </tr>
			     	   							
				<tr> 
				       <td class=h></td>
				</tr>
				
				<tr>
					<td class='line' >			
			            <table border="0" cellspacing="1" cellpadding="0" width=100%>
			                <tr> 
			                    <td width=100%><br>
								  &nbsp;&nbsp;<font color=red>[����]</font>
			        			  &nbsp;&nbsp;&nbsp;&nbsp;<select name="s_destphone" onchange="javascript:document.form1.destphone.value=this.value;">
			                        <option value="">==����==</option>
			        				<%if(!client.getM_tel().equals("")){%>
			        				<option value="<%=client.getM_tel()%>"><%=client.getM_tel()%><%=client.getClient_nm()%></option>
			        				<%}%>
			        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
			        				<option value="<%=client.getCon_agnt_m_tel()%>"><%=client.getCon_agnt_m_tel()%><%=client.getCon_agnt_nm()%></option>
			        				<%}%>
			        				<%if(!site.getAgnt_m_tel().equals("")){%>
			        				<option value="<%=site.getAgnt_m_tel()%>"><%=site.getAgnt_m_tel()%><%=site.getAgnt_nm()%></option>
			        				<%}%>
			        				<%for(int i = 0 ; i < mgr_size ; i++){
			        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
			        					if(!mgr.getMgr_m_tel().equals("")){%>
			        				<option value="<%=mgr.getMgr_m_tel()%>"><%=mgr.getMgr_m_tel()%><%=mgr.getMgr_nm()%></option>
			        				<%}}%>	
			        				<option value="<%=user_bean.getUser_m_tel()%>"><%=user_bean.getUser_m_tel()%><%=user_bean.getUser_nm()%></option>
									
			        			  </select>
			        			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���Ź�ȣ : <input type='text' size='15' name='destphone' value='' maxlength='100' class='text'>
			        			  <br>
								  &nbsp;&nbsp;<font color=red>[�߽�]</font>
			        			  &nbsp;&nbsp;&nbsp;&nbsp;�߽Ź�ȣ : <input type='text' size='15' name='sendphone' value='<%=user_bean.getUser_m_tel()%>' maxlength='100' class='text'>
			        			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�߽��ڸ� : <input type='text' size='15' name='sendname' value='<%=user_bean.getUser_nm()%>' maxlength='100' class='text'> 
			        			  <br>
			        			   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name="auto_yn" value='Y' checked onClick="javascript:checklen()"><span class=style4> -�Ƹ���ī- ���� ���뿡 �ڵ� ����</span></font>
			        			  <br>
								  &nbsp;&nbsp;<font color=red>[����]</font>
			        			  &nbsp;&nbsp;&nbsp;&nbsp;<textarea name='msg' rows='5' cols='68' class='text' onKeyUp="javascript:checklen()" style='IME-MODE: active'><%=sms_msg%></textarea>
								  <br>
			        			  &nbsp;&nbsp;<input class="whitenum" type="text" name="msglen" size="2" maxlength="2" readonly value=0>byte
								
								  &nbsp;&nbsp;<a href="javascript:SendSms();"><img src=/acar/images/center/button_in_send.gif border=0 align=absmiddle></a><br><br></td>
			                </tr>
			              
			            </table>
					</td>
				</tr>	
	
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'>&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>
</table>
</form>
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
}	
	//���� ������
function SendSms()
{
		var fm = document.form1;
		
		if (fm.destphone.value == '') {
			alert("���Ź�ȣ�� �����ϼž� �մϴ�.");
			return;
		}	
					
		if(confirm('���ڸ� �����ðڽ��ϱ�?'))				
		{				
					
			if(document.form1.auto_yn.checked == true){
				fm.msg.value = fm.msg.value+"-�Ƹ���ī-";
			}else{
				fm.msg.value = fm.msg.value;	
			}	
					
			fm.action = "cus_pre_sc_gs_send_sms.jsp";
			fm.target = "i_no";		
		
			fm.submit();	
		}
}
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>