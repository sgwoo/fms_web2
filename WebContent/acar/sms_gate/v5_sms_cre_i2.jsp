<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*"%>
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
	Hashtable ht = umd.getSmsV5(cmid, cmst);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "SMS");
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
	
	//���� ��ȸ
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
		
		if(fm.no_num.checked){
		
		}else{
			if(fm.destphone.value == ''){ alert('���Ź�ȣ�� �Է��Ͻʽÿ�.'); 	return; }
		}
		
		if(fm.key_nice.value != '' || fm.key_kcb.value != ''){
			if(fm.key_name.value == '')	{ alert('������ �����Ͻʽÿ�.'); 		return; }
			if(fm.birth_dt.value == '')	{ alert('��������� �����Ͻʽÿ�.'); 		return; }			
			
			if(fm.birth_dt.value.length < 6 || fm.birth_dt.value.length > 6)		{ alert('�������(YYMMDD)�� Ȯ���Ͻʽÿ�.'); 	return;}		
		}
		
		if(confirm('�ſ���ȸ �̷��� ����Ͻðڽ��ϱ�?'))				
		{				
			fm.action = "v5_sms_cre_i_a2.jsp";
			fm.target = "i_no";		
			fm.submit();	
		}
	}	
	
	function search_eval_key(){
		var fm = document.form1;
		window.open("/fms2/lc_rent/search_eval_key.jsp?from_page=/acar/sms_gate/v5_sms_cre_i2.jsp&gubun1="+fm.key_name.value+"&gubun2="+fm.birth_dt.value+"&gubun3="+fm.destphone.value, "SEARCH_EVAL_KEY", "left=10, top=10, width=900, height=300, scrollbars=yes, status=yes, resizable=yes");	
	}		
	
//-->
</script>	
</head>

<body onLoad="javascript:document.form1.firm_nm.focus();">
<form action="" name="form1" method="post" >
<INPUT TYPE="hidden" NAME="check" value="Y">
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
                    <td colspan='3'>&nbsp;����</td>
                </tr>
                <tr>
				    <td class="title" width=12%>����</td>
                    <td  colspan='3'>&nbsp;<input type="text" name="firm_nm" size="30" class="text" value="" onKeyDown="javasript:enter()">
						<input type='hidden' name='client_id' value=''>
						<input type='hidden' name='rent_l_cd' value=''>
						<a href="javascript:cust_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
						&nbsp;						
					</td>
                </tr>
                <tr>
				    <td class="title" width=12%>������</td>
                    <td width=38%>&nbsp;<input type="text" name="destname" size="30" class="text" value=""></td>
                    <td width=12% class="title">���Ź�ȣ</td>
                    <td width=38%>&nbsp;<input type="text" name="destphone" size="15" class="text" value=""> <input type="checkbox" name="no_num" value="N">���鵿��</td>
                </tr>


				 <tr>
				    <td class="title" width=12%>�Ƿ���</td>
                    <td width=38%>&nbsp;<select name='bus_id'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>	
					</td>
                    <td width=12% class="title">��ȸ���</td>
                    <td width=38%>&nbsp;NICE : <select name='score'>
						<option value="����ȸ">����ȸ</option>
                        <option value="1���">1���</option>
						<option value="2���">2���</option>
						<option value="3���">3���</option>
						<option value="4���">4���</option>
						<option value="5���">5���</option>
						<option value="6���">6���</option>
						<option value="7���">7���</option>
						<option value="8���">8���</option>
						<option value="9���">9���</option>
						<option value="10���">10���</option>
						</select>
						&nbsp;KCB : <select name='score2'>
						<option value="����ȸ">����ȸ</option>
                        <option value="1���">1���</option>
						<option value="2���">2���</option>
						<option value="3���">3���</option>
						<option value="4���">4���</option>
						<option value="5���">5���</option>
						<option value="6���">6���</option>
						<option value="7���">7���</option>
						<option value="8���">8���</option>
						<option value="9���">9���</option>
						<option value="10���">10���</option>
						</select>
						</td>
                </tr>

                <tr>
                    <td class="title">���� </td>
                    <td colspan="3">&nbsp;<input type='text' size='30' name='msg_subject' value='�ſ���ȸ�� ���� �̹߼� ��' maxlength='30' class='text'>&nbsp;(30���̳�)</td>
                </tr>
                <tr>
                    <td class="title">�޸�</td>
                    <td colspan="3">&nbsp;<textarea name="msg" rows="5" cols="95" class="text">�ſ���ȸ�� ���ڹ߼��� ���� ����.</textarea></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ſ���ȸ ��üŰ</span>	        
	    </td>
	</tr>    
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="700" border="0" cellspacing="1" cellpadding="0">	
                <tr>
				    <td class="title" width=12%>����</td>
                    <td>&nbsp;<input type="text" name="key_name" size="15" class="text" value=""></td>                    
				    <td class="title" width=12%>�������</td>
                    <td >&nbsp;<input type="text" name="birth_dt" size="15" maxlength='8' class="text" value=""> (YYMMDD)</td>                    
                </tr>
                <tr>
				    <td class="title" width=12%>NICE ��üŰ</td>
                    <td width=38%>&nbsp;<input type="text" name="key_nice" size="15" class="text" value="">            
                    </td>
                    <td width=12% class="title">KCB ��üŰ</td>
                    <td width=38%>&nbsp;<input type="text" name="key_kcb" size="15" class="text" value=""> 
                    &nbsp;<a href="javascript:search_eval_key()" onMouseOver="window.status=''; return true" title="�ſ���ȸ ��üŰ ��ȸ�ϱ�"><img src=/acar/images/center/button_in_cf_dc.gif border=0 align=absmiddle></a>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
            
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
			<a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
		</td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>