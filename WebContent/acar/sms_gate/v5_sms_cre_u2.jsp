<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String cmid		= request.getParameter("cmid")==null?"":request.getParameter("cmid");
	String cmst		= request.getParameter("cmst")==null?"":request.getParameter("cmst");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Hashtable ht = umd.getSmsV5No(cmid, cmst);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//�ܱ�뿩---------------------------------------------------------------------------------------------------------
	
	//�� ��ȸ
	function cust_select(){
		var fm = document.form1;
		window.open("search_client.jsp?s_kd=1&t_wd="+fm.firm_nm.value, "CLIENT_SEARCH", "left=50, top=50, width=820, height=450, status=yes");
	}	
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') cust_select();
	}	
	
	//���� ������
	function SandSms(){
		var fm = document.form1;			
		if(fm.destname.value == '')	{ alert('�����ڸ� �Է��Ͻʽÿ�.'); 		return; }
		if(fm.destphone.value == ''){ alert('���Ź�ȣ�� �Է��Ͻʽÿ�.'); 	return; }

		if(confirm('������ ���� �Ͻðڽ��ϱ�?'))				
		{	
			fm.cmd.value = "u";			
			fm.action = "v5_sms_cre_i_a2.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}

	}


//-->
</script>	
</head>

<body onLoad="javascript:document.form1.destname.focus();">
<form action="" name="form1" method="post" >
	<input type="hidden" name="cmid" value="<%=ht.get("CMID")%>">
	<input type="hidden" name="pk_key_no" value="<%=ht.get("KEY_NO")%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
	<input type='hidden' name="cmd" value="">  
<table width="700" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>SMS����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="700" border="0" cellspacing="1" cellpadding="0">
                <tr>
				    <td class="title" width=12%>�߼۴��</td>
                    <td colspan='3'>&nbsp;��</td>
                </tr>
                <tr>
				    <td class="title" width=12%>������</td>
                    <td width=38%>&nbsp;<input type="text" name="destname" size="30" class="text" value="<%= ht.get("DEST_NAME") %>"></td>
                    <td width=12% class="title">���Ź�ȣ</td>
                    <td width=38%>&nbsp;<input type="text" name="destphone" size="15" class="whitetext" value="<%= ht.get("DEST_PHONE") %>"></td>
                </tr>

				 <tr>
				    <td class="title" width=12%>�Ƿ���</td>
                    <td width=38%>&nbsp;<select name='bus_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(ht.get("BUS_ID").equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>	
					</td>
                    <td width=12% class="title">��ȸ���</td>
                    <td width=38%>&nbsp;<select name='score'>
                        			<option value="1���" <%if(ht.get("SCORE").equals("1���"))%>selected<%%>>1���</option>
						<option value="2���" <%if(ht.get("SCORE").equals("2���"))%>selected<%%>>2���</option>
						<option value="3���" <%if(ht.get("SCORE").equals("3���"))%>selected<%%>>3���</option>
						<option value="4���" <%if(ht.get("SCORE").equals("4���"))%>selected<%%>>4���</option>
						<option value="5���" <%if(ht.get("SCORE").equals("5���"))%>selected<%%>>5���</option>
						<option value="6���" <%if(ht.get("SCORE").equals("6���"))%>selected<%%>>6���</option>
						<option value="7���" <%if(ht.get("SCORE").equals("7���"))%>selected<%%>>7���</option>
						<option value="8���" <%if(ht.get("SCORE").equals("8���"))%>selected<%%>>8���</option>
						<option value="9���" <%if(ht.get("SCORE").equals("8���"))%>selected<%%>>9���</option>
						<option value="10���" <%if(ht.get("SCORE").equals("10���"))%>selected<%%>>10���</option>
						</select>
                </tr>

                <tr>
                    <td class="title">���� </td>
                    <td colspan="3">&nbsp;<input type='text' size='30' name='msg_subject' value='<%= ht.get("SUBJECT") %>' maxlength='30' class='whitetext'>&nbsp;(30���̳�)</td>
                </tr>
                <tr>
                    <td class="title">�޼��� </td>
                    <td colspan="3">&nbsp;<textarea name="msg" rows="5" cols="95" class="text"><%= ht.get("MSG_BODY") %></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <%	if(!String.valueOf(ht.get("KEY_NO")).equals("")){
    		ContEvalBean eval_key = a_db.getContEvalKey(String.valueOf(ht.get("KEY_NO")));	
    		if(!eval_key.getKey_no().equals("")){
    %>
    <tr>
        <td class=h></td>
    </tr> 	    
    <tr>
	<td class=line2></td>		
    </tr>
    <tr>
	<td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                    
                    <td width="30%" class='title'>����</td>
                    <td width="16%" class='title'>�������</td>
                    <td width="18%" class='title'>�޴�����ȣ</td>
                    <td width="18%" class='title'>NICE</td>		  
                    <td width="18%" class='title'>KCB</td>                    
                </tr>
                <tr>                     
                    <td align='center'><input type="text" name="key_name" size="15" class="text" value="<%=eval_key.getKey_name()%>"></td>		  
                    <td align='center'><input type="text" name="birth_dt" size="15" maxlength='8' class="text" value="<%=eval_key.getKey_birth_dt()%>"></td>
                    <td align='center'><input type="text" name="key_m_tel" size="15" class="text" value="<%=eval_key.getKey_m_tel()%>"></td>
                    <td align='center'><input type="text" name="key_nice" size="15" class="text" value="<%=eval_key.getKey_nice()%>"></td>
                    <td align='center'><input type="text" name="key_kcb" size="15" class="text" value="<%=eval_key.getKey_kcb()%>"></td>
                </tr>    				
            </table>
        </td>
	</tr>    
    <%		}
    	}%>
    <!--	    
    <tr>
        <td>
            * ���� �ſ���ȸ�϶� �޸� �̸�/�������/�ڵ�����ȣ/�������/��üŰ�� �־��ּ���.
        </td>
    </tr> 	    
    -->
    <tr>
        <td class=h></td>
    </tr> 	
    <tr> 
        <td align="right">
			<a href="javascript:SandSms()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
		</td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>