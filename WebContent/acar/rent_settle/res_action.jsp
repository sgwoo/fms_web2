<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");		
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "01");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "EMP"); //����� ����Ʈ
	int user_size = users.size();	

	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	
	String rent_st = rc_bean.getRent_st();
%>

<html>
<head>

<title>����ý��� <%if(mode.equals("R")){%>����ó��<%}else{%>�Ⱓ����<%}%></title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.mode.value == 'R'){
			if(fm.ret_dt.value == ''){ 		alert('�����Ͻø� �Է��Ͻʽÿ�'); 			fm.ret_dt.focus(); 			return; }
			if(fm.ret_loc.value == ''){ 	alert('������ġ�� �Է��Ͻʽÿ�'); 			fm.ret_loc.focus(); 		return; }		
			if(fm.ret_mng_id.value == ''){ 	alert('��������ڸ� �����Ͻʽÿ�'); 		fm.ret_mng_id.focus(); 		return; }						
			if(fm.ret_dt.value != '')
				fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value;			
		}else{
			if(fm.add_dt.value == ''){ 		alert('�������ڸ� �Է��Ͻʽÿ�'); 			fm.add_dt.focus(); 			return; }		
		}
		if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		fm.action = 'res_action_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.<%if(mode.equals("R")){%>ret_dt<%}else{%>add_dt<%}%>.focus();">
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='h_ret_dt' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=480>
    <tr> 
      <td><font color="navy">����ý��� -> ��������</font>-> <font color="red"><%if(mode.equals("R")){%>����ó��<%}else{%>�Ⱓ����<%}%></font></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=480>
          <tr> 
            <td class=title>��౸��</td>
            <td align="center"> 
               <%if(rent_st.equals("1")){%>
                �ܱ�뿩 
                <%}else if(rent_st.equals("2")){%>
                ������� 
                <%}else if(rent_st.equals("3")){%>
                ������ 
                <%}else if(rent_st.equals("9")){%>
                ������� 
                <%}else if(rent_st.equals("10")){%>
                �������� 
                <%}else if(rent_st.equals("4")){%>
                �����뿩 
                <%}else if(rent_st.equals("5")){%>
                �������� 
                <%}else if(rent_st.equals("6")){%>
                �������� 
                <%}else if(rent_st.equals("7")){%>
                �������� 
                <%}else if(rent_st.equals("8")){%>
                ������ 
                <%}else if(rent_st.equals("11")){%>
                �����
                <%}else if(rent_st.equals("12")){%>
                ����Ʈ
                <%}%>	
            </td>
            <td class=title>������ȣ</td>
            <td align="center"><%=reserv.get("CAR_NO")%></td>
            <td class=title>����</td>
            <td align="left">&nbsp;<%=rc_bean2.getCust_nm()%></td>
            <td class=title>��ȣ</td>
            <td align="center"><%=rc_bean2.getFirm_nm()%></td>
          </tr>
          <tr> 
                    <td class=title width=12%>����</td>
                    <td colspan="7">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>  
          <tr> 
            <td class=title>�뿩�Ⱓ</td>
            <td colspan="7"> <%=AddUtil.ChangeDate4(rc_bean.getRent_start_dt())%>�� 
              ~ <%=AddUtil.ChangeDate4(rc_bean.getRent_end_dt())%>��</td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(!rc_bean.getSub_c_id().equals("")){ 
    	//��������
    	Hashtable reserv2 = rs_db.getCarInfo(rc_bean.getSub_c_id());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    
                <tr>            
                    <td class=title width=10%>������ȣ</td>
                    <td width=20%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>    
    <%if(rc_bean.getSub_c_id().equals("") && !rc_bean.getSub_l_cd().equals("")){ 
    	//��������
    	Hashtable reserv2 = a_db.getRentBoardSubCase(rc_bean.getSub_l_cd());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2">          
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                
                    <td class=title width=10%>������ȣ</td>
                    <td width=20%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>    
    <tr> 
      <td>&nbsp;</td>
    </tr>
	<%if(mode.equals("R")){%>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=480>
          <tr> 
            <td class=title width="80">���������Ͻ�</td>
            <td><%=AddUtil.ChangeDate4(rc_bean.getRet_plan_dt())%>��</td>
          </tr>
          <tr> 
            <td class=title>�����Ͻ�</td>
            <td> 
              <input type="text" name="ret_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
              <select name="ret_dt_h">
                <%for(int i=0; i<25; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>��</option>
                <%}%>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title>������ġ</td>
            <td>
              <input type="text" name="ret_loc" value="<%=rc_bean.getRet_loc()%>" size="60" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title>���������</td>
            <td>
              <select name='ret_mng_id'>
                <option value="">������</option>
                <%if(user_size > 0){
					for (int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getRet_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%	}
				}%>
              </select>
			</td>
          </tr>
        </table>
      </td>
    </tr>
	<%}else if(mode.equals("A")){%>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="1" width=480>
          <tr> 
            <td class=title width="80">���������Ͻ�</td>
            <td><%=AddUtil.ChangeDate4(rc_bean.getRet_plan_dt())%>��</td>
          </tr>
          <tr> 
            <td class=title>��������</td>
            <td> 
              <input type="text" name="add_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<%}%>		
    <tr> 
      <td align="right">
	  	<%if((auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) && (br_id.equals("S1") || rc_bean.getBrch_id().equals(br_id))){%>		  	  	  
	    <a href='javascript:save();'> 
        <img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"> 
        </a>&nbsp;
	  	<%}%>							
	    <a href='javascript:document.form1.reset();'> 
        <img src="/images/calcel.gif" width="50" height="18" aligh="absmiddle" border="0"> 
        </a>&nbsp;		
	    <a href="javascript:self.close()" onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
