<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* �ڵ� ����:�뿩��ǰ�� */
	int good_size = goods.length;		
	
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ_������
	int user_size = users.size();
	
	LoginBean login = LoginBean.getInstance();
	if(t_wd.equals("") && s_kd.equals("4"))		t_wd = login.getCookieValue(request, "acar_id");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��ȸ
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2'||fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //�ۼ���,�����
			fm.t_wd.value = fm.reg_id.options[fm.reg_id.selectedIndex].value;		
		}
		fm.action = "guest_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2'||fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //�ۼ���, �����
			td_input.style.display	= 'none';
			td_reg.style.display 	= '';
		}else{
			td_input.style.display	= '';
			td_reg.style.display 	= 'none';
			fm.t_wd.value = '';
		}
	}	
	//���÷��� Ÿ��
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun4.options[fm.gubun4.selectedIndex].value == '3'){ //�Ⱓ
			esti.style.display 	= '';
			fm.esti_m_dt.value		= '';
			esti_m_dt.style.display = 'none';
		}else{
			esti.style.display 	= 'none';
		}
	}
	//esti_m_cng_dt
	function esti_m_cng_dt(){
		var fm = document.form1;
		if(fm.esti_m_dt.options[fm.esti_m_dt.selectedIndex].value == '3'){ //�Ⱓ 
			esti_m_dt.style.display 	= '';
			fm.gubun4.value = '';
			esti.style.display = 'none';
		}else{ 
			esti_m_dt.style.display 	= 'none'; 
		} 
	} 
	
//-->
</script>
</head>
<body>
<form action="./guest_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > <span class=style5>����ȭ����û</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border=0 cellspacing=1 cellpadding=0 width="100%">
                <tr> 
                    <td width="450">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="150">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                                    <select name="gubun4" onChange='javascript:cng_dt()'>
                                      <option value="">��ü</option>
                                      <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>���</option>
                                      <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>����</option>
                                      <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>�Ⱓ</option>
                                  </select></td>
                                <td width="300" id='esti' style="display:<%if(!gubun4.equals("3")){%>none<%}else{%>''<%}%>">
                                  <input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                  ~
                                  <input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                </td>
                            </tr>
                        </table>  
                    </td>
                    <td width="200"><img src=/acar/images/center/arrow_sdyb.gif align=absmiddle>&nbsp;
                        <select name="esti_m" onChange='javascript:cng_input()'>
                            <option>��ü</option>
                            <option value="1" <%if(esti_m.equals("1"))%>selected<%%>>�Ϸ�</option>
                            <option value="2" <%if(esti_m.equals("2"))%>selected<%%>>�̻��</option>
                        </select></td>
                    <td width=200>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                        <select name="s_kd" onChange='javascript:cng_input()'>
                            <option>��ü</option>
                            <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>����</option>
                            <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>�ۼ���</option> 
                            <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>����</option> 
            				<option value="4" <%if(s_kd.equals("4"))%>selected<%%>>�����</option>
                          </select> </td>
                    <td width=150> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id=td_input <%if(s_kd.equals("2")||s_kd.equals("4")){%>style='display:none'<%}%> width="100%"> 
                                    <input type="text" name="t_wd" size="20" value="<%=t_wd%>" class=text onKeyDown="javasript:EnterDown()"> 
                                </td>
                                <td id=td_reg <%if(!(s_kd.equals("2")||s_kd.equals("4"))){%>style='display:none'<%}%>> 
                                    <select name="reg_id">
                                      <option value="">��ü</option>
                                      <%	if(user_size > 0){
                							for (int i = 0 ; i < user_size ; i++){
                							Hashtable user = (Hashtable)users.elementAt(i);	%>
                                      <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                                      <%		}
                						}		%>
                                    </select> 
                                </td>
                            </tr>
                        </table>
                    </td>
        			<td>&nbsp;</td>
                    <td><a href="javascript:search()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

