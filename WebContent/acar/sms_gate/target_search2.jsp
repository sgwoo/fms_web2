<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("auth_rw")==null?"S1":request.getParameter("auth_rw");
	String gubun1 		= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm 		= request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort 		= request.getParameter("sort")==null?"":request.getParameter("sort");	
	String cng_rsn 		= request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String commi_yn 	= request.getParameter("commi_yn")==null?"":request.getParameter("commi_yn");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	
	//�õ�
	Vector sidoList = c_db.getZip_sido();
	int sido_size = sidoList.size();

	


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="javascript">
<!--
function cng_input(){
	var fm = document.form1;
	if(fm.gubun.options[fm.gubun.selectedIndex].value == "reg_id"||
		fm.gubun.options[fm.gubun.selectedIndex].value == "upd_id"){ //���ʴ����, ���������
		td_gu_nm.style.display	= 'none';
		td_s_bus.style.display	= '';
		fm.s_bus.focus();
	}else{		
		td_gu_nm.style.display	= '';
		td_s_bus.style.display	= 'none';
		fm.gu_nm.value ="";
		fm.gu_nm.focus();
	}
}

//�ʱ�ȭ
function renew(){
	opener.smsList.location.href = "./sms_list.jsp";
	location.href = "./target_search2.jsp";
}

//�з����м��ý� �����ܰ� �����ֱ�
function show_next(arg){
	var fm = document.form1;
	if(arg=='7'){
		tr_search.style.display = "";
	}
}

//�˻���� �θ������쿡�� �����ֱ�
function SearchCarOffP2(){
	fm = document.form1;
	opener.smsList.smsList_t.location.href = "./sms_list_t.jsp";
	fm.target = "smsList_in";
	if(fm.gubun.options[fm.gubun.selectedIndex].value == "reg_id"||
		fm.gubun.options[fm.gubun.selectedIndex].value == "upd_id"){ //���������
		fm.gu_nm.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
	}		
	fm.action = "./sms_list_in.jsp";
	fm.submit();
}
//�ߺ��� ��ȸ
function check_double(){
	window.open("about:blank", "check_double", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	if(fm.gubun.options[fm.gubun.selectedIndex].value == "reg_id"||
		fm.gubun.options[fm.gubun.selectedIndex].value == "upd_id"){ //���������
		fm.gu_nm.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
	}	
	fm.target = "check_double";
	fm.action = "./sms_list_double.jsp";
	fm.submit();
}
//��ȣ����üũ
function check_num(){
	window.open("about:blank", "check_num", "left=30, top=110, width=750, height=550, scrollbars=yes, status=yes");	
	fm = document.form1;
	if(fm.gubun.options[fm.gubun.selectedIndex].value == "reg_id"||
		fm.gubun.options[fm.gubun.selectedIndex].value == "upd_id"){ //���������
		fm.gu_nm.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
	}	
	fm.target = "check_num";
	fm.action = "./sms_list_check_num.jsp";
	fm.submit();

}
function EnterDown(){
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchCarOffP2();	
}

-->
</script>
</head>

<body>
<form method="post" name="form1">
<input type="hidden" name="gubun1" value="<%= gubun1 %>">
<input type="hidden" name="gubun2" value="<%= gubun2 %>">
<table width="320" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td align="right"><a href="javascript:renew()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_init.gif" border="0" align="absbottom"></a> 
				<a href="javascript:this.close();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_close.gif" border="0" align="absbottom"></a></td>
  </tr>
  <tr>
    <td class="line"><table width="320" border="0" cellspacing="1" cellpadding="0">
      <tr>
        <td width="79" class="title">�߼۴��</td>
            <td colspan="2">&nbsp;�������</td>
        </tr>
      <tr>
            <td class="title">�߼۹��</td>
            <td colspan="2">&nbsp;����</td>
        </tr>
      <tr>
        <td colspan="3"><font color="#666666">���ش��׸��� ������ �ֽñ� �ٶ��ϴ�.</font></td>
        </tr>
      <tr>
        <td class="title">�˻��׸�</td>
        <td width="100">
		  <select name="gubun" onChange="javascript:cng_input();">
            <option value="">��ü</option>
            <option value="emp_nm" >����</option>
            <option value="emp_m_tel" >�ڵ���</option>
            <option value="emp_email" >�̸���</option>
            <option value="reg_id" >���ʵ����</option>
            <option value="upd_id" >�����</option>
          </select></td>
        <td id="td_gu_nm" width="137" style="display:none;"><input name="gu_nm" type="text" class="text" size="10" style="IME-MODE:active;" onKeyDown="javascript:EnterDown();">&nbsp;</td>
        <td id="td_s_bus" width="137" style="display:none;">
		  <select name='s_bus'>
            <option value="">������</option>
            <%	if(user_size > 0){
					for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
            <option value='<%=user.get("USER_ID")%>' <%if(gu_nm.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                  <%		}
					}		%>
			
          </select></td>		
      </tr>
      <tr>
            <td class="title">�����<br>��������</td>
            <td colspan="2">
			  <select name="cng_rsn">
                        <option value=""  <% if(cng_rsn.equals("")) out.println("selected");%>>==��ü==</option>
                        <option value="1" <% if(cng_rsn.equals("1")) out.println("selected");%>>1.�ֱٰ��</option>
                        <option value="2" <% if(cng_rsn.equals("2")) out.println("selected");%>>2.�����</option>
                        <option value="3" <% if(cng_rsn.equals("3")) out.println("selected");%>>3.��ȭ���</option>
                        <option value="4" <% if(cng_rsn.equals("4")) out.println("selected");%>>4.�������</option>
                        <option value="5" <% if(cng_rsn.equals("5")) out.println("selected");%>>5.��Ÿ</option>
                      </select>
			</td>
        </tr>	  
      <tr>
            <td class="title">����(����)��</td>
            <td colspan="2">
			  <input type="text" name="st_dt" size="12" value="<%=st_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      ~ 
                      <input type="text" name="end_dt" size="12" value="<%=end_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value)'>
			</td>
        </tr>	  		
      <tr>
            <td class="title">�ŷ�����</td>
            <td colspan="2">
			  <select name="commi_yn">
                        <option value=""  <% if(commi_yn.equals("")) out.println("selected");%>>==��ü==</option>
                        <option value="Y" <% if(commi_yn.equals("Y")) out.println("selected");%>>��</option>
                        <option value="N" <% if(commi_yn.equals("N")) out.println("selected");%>>��</option>
                      </select>
			</td>
        </tr>	  		
    </table></td>
  </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="center">
	  <a href="javascript:check_num();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_check_jb.gif" border="0" align="absbottom"></a>
        &nbsp; 
		<a href="javascript:check_double();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_check_or.gif" border="0" align="absbottom"></a>
		&nbsp;
        <a href="javascript:show_next('7');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_next.gif"  border="0" align="absbottom"></a>
      </td>
    </tr>
    <tr>
      <td align="center">&nbsp;</td>
    </tr>
    <tr id="tr_search" style="display:none;"> 
      <td align="center"><a href="javascript:SearchCarOffP2()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_search.gif" border="0" align="absbottom"></a></td>
    </tr>
  
</table>
</form>
</body>
</html>
