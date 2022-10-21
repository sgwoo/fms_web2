<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(cmd, dt){
		var fm = document.form1;
		if(cmd == 'd' && !confirm('�����Ͻðڽ��ϱ�?')){	return;	}
		if(cmd == 'i' && !confirm('����Ͻðڽ��ϱ�?')){	return;	}
		fm.cmd.value = cmd;
		fm.dt.value = dt;		
		fm.action = 'car_scd_add_a.jsp';
		fm.target = 'i_no';
		fm.submit();			
	}
</script>
</head>
<body leftmargin="15" onLoad="javascript:document.form1.start_dt.focus()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "10", "01");
	
	
	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());	
	String rent_st = rc_bean.getRent_st();
	String ret_dt = "";
	
	//�����ٸ���Ʈ
	Vector scds = rs_db.getRentCarScdList(c_id, s_cd);
	int scd_size = scds.size();	
	
	
	if(scd_size > 0){    	
		Hashtable scd = (Hashtable)scds.elementAt(scd_size-1);
		ret_dt = rs_db.addDay(String.valueOf(scd.get("DT")), 1); 	//����(<-������)
	}    	
		
%>
<form action="" name="form1" method="post" >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='f_page' value='<%=f_page%>'>
<input type='hidden' name='h_deli_dt' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='dt' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�����ٰ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line  colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=12%>��౸��</td>
                    <td width=12%> &nbsp;
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
                      �������� 
                      <%}else if(rent_st.equals("5")){%>
                      �������� 
                      <%}else if(rent_st.equals("6")){%>
                      �������� 
                      <%}else if(rent_st.equals("7")){%>
                      �������� 
                      <%}else if(rent_st.equals("8")){%>
                      ������ 
                      <%}else if(rent_st.equals("11")){%>
                      ��Ÿ 
                      <%}else if(rent_st.equals("12")){%>
                      ����Ʈ
                      <%}%>
                    </td>
                    <td class=title width=12%>������ȣ</td>
                    <td width=16%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title width=7%>����</td>
                    <td align="left" width=11%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=7%>��ȣ</td>
                    <td width=23%>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>���Ⱓ</td>
                    <td colspan="7">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~<%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
                <tr>
                    <td class=title>�������</td>
                    <td colspan="7">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%>~<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class=line align="right" colspan=2>
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr> 
                    <td class=title width=12%>�����ٻ���</td>
                    <td> 
                      &nbsp;<input type="text" name="start_dt" value="<%=ret_dt%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      �Ϻ��� 
                      <input type="text" name="end_dt" value="" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      �ϱ��� &nbsp;<a href="javascript:save('i', '');"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr> 
        <td></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="7%">����</td>
                    <td class=title width="20%">����</td>
                    <td class=title width="15%">�ð�</td>
                    <td class=title width="13%">ȸ��</td>
                    <td class=title width="15%">����</td>
                    <td class=title width="15%">��뿩��</td>
                    <td class=title width="15%">ó��</td>
                </tr>
              <%	if(scd_size > 0){
    					for(int i = 0 ; i < scd_size ; i++){
    						Hashtable scd = (Hashtable)scds.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(scd.get("DT")))%></td>
                    <td align="center"><%=scd.get("TIME")%></td>
                    <td align="center"><%=scd.get("TM")%></td>
                    <td align="center"><%=scd.get("USE_ST")%></td>
                    <td align="center"><%=scd.get("USE_YN")%></td>
                    <td align="center"> <a href="javascript:save('d', '<%=scd.get("DT")%>');"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='7' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td><font color="#666666">* ���� : 0-����, 1-����, 2-������</font></td>
        <td align="right"><a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>	
</table>  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
