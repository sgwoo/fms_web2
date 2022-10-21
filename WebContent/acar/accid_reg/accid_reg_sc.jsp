<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");//�������
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");//�˻�����
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");//�˻���
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"2":request.getParameter("l_cd");//����ȣ
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	int our_p = 0;
	int ot_p = 0;
	
	if(s_gubun1.equals("1"))		ot_p = 100;
	else if(s_gubun1.equals("2"))	our_p = 100;
	else if(s_gubun1.equals("8"))	our_p = 100;
	else if(s_gubun1.equals("6"))	our_p = 100;
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "01");
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);

	//��������
	String ins_st = ai_db.getInsSt(c_id);
	InsurBean ins = ai_db.getIns(c_id, ins_st);
	String ins_com_nm = ai_db.getInsComNm(c_id);
		
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();	
	
	//�ֱ��Էº� �����Ʈ
	Vector accids = as_db.getAccidCarHList(c_id);
	int accid_size = accids.size();
	
	if(accid_size >5) accid_size = 5;
	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//������ ���ฮ��Ʈ ��ȸ
	function res_search(){
		var fm = document.form1;	
		if(fm.c_id.value == ''){ alert('�����˻��� �ٽ� �Ͻʽÿ�.'); return; }	
		window.open("search_res.jsp?c_id="+fm.c_id.value, "SEARCH_RES", "left=100, top=100, width=700, height=400, scrollbars=yes");		
	}
	
	//������ �Ⱓ�� ����Ͻ� ��
	function dt_chk(){
		var fm = document.form1;	
		if(fm.car_st.value == '2' && fm.sub_rent_gu.value != '99'){
			var st_dt = replaceString("-","",fm.sub_rent_st.value);
			var et_dt = replaceString("-","",fm.sub_rent_et.value);
			var dt = replaceString("-","",fm.accid_dt.value);
			if(fm.sub_rent_st.value !='' && st_dt > dt){ alert('������ ���Ⱓ�� ������ڰ� ���� �ʽ��ϴ�.'); return; 	}
			if(fm.sub_rent_et.value !='' && et_dt < dt){ alert('������ ���Ⱓ�� ������ڰ� ���� �ʽ��ϴ�.'); return;	}
		}
	}	
		
	function save(){
		var fm = document.form1;
		
		if(fm.accid_st.value = '8' && fm.accid_dt.value == ''){ fm.accid_dt.value = fm.reg_dt.value; }		
		if(fm.accid_dt_h.value == ''){ fm.accid_dt_h.value='00'; }		
		if(fm.accid_dt_m.value == ''){ fm.accid_dt_m.value='00'; }		
		
		dt_chk();
		
		fm.h_accid_dt.value = fm.accid_dt.value+fm.accid_dt_h.value+fm.accid_dt_m.value;	
		
		if(fm.m_id.value == '' || fm.l_cd.value == '' || fm.c_id.value == ''){ alert('������ �����Ͻʽÿ�.'); return; }
		if(fm.accid_st.value == ''){ alert('��������� �����Ͻʽÿ�.'); return; }
		if(fm.reg_dt.value == ''){ alert('�������ڸ� �Է��Ͻʽÿ�.'); return; }		
		if(fm.reg_id.value == ''){ alert('�����ڸ� �����Ͻʽÿ�.'); return; }	
		if(fm.accid_st.value != '8' && fm.accid_dt.value == ''){ alert('����Ͻø� �Է��Ͻʽÿ�.'); return; }		
		
		
		var accid_reg_chk = 0;
		
		//�ֱٵ�Ϻа���
		<%for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>			
			if(replaceString("-","",fm.h_accid_dt.value) == '<%=accid.get("ACCID_DT")%>'){
				accid_reg_chk = accid_reg_chk + 1;				
			}			
		<%}%>	
		
		if(accid_reg_chk > 0){		
			if(!confirm('������ �Ͻÿ� ��ϵ� ��� �ֽ��ϴ�. ����Ͻðڽ��ϱ�?')){	return;	}		
		}else{		
			if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}		
		}
		
		fm.target = 'i_no';
		fm.action = 'accid_reg_a.jsp';
		fm.submit();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='accid_reg_a.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="s_gubun1" value='<%=s_gubun1%>'>
<input type='hidden' name="s_kd" value='<%=s_kd%>'>
<input type='hidden' name="t_wd" value='<%=t_wd%>'>
<input type='hidden' name="m_id" value='<%=m_id%>'>
<input type='hidden' name="l_cd" value='<%=l_cd%>'>
<input type='hidden' name="c_id" value='<%=c_id%>'>
<input type='hidden' name="car_st" value='<%=cont.get("CAR_ST")%>'>
<input type='hidden' name="accid_st" value='<%=s_gubun1%>'>
<input type='hidden' name="rent_st" value='<%=rent_st%>'>
<input type='hidden' name="car_no" value='<%=cont.get("CAR_NO")%>'>
<input type='hidden' name="gubun" value='<%=gubun%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name="h_accid_dt" value=''>
<input type='hidden' name="bus_id2" value='<%=cont.get("BUS_ID2")%>'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="9%">����ȣ</td>
                    <td width="12%">&nbsp;<%=l_cd%></td>
                    <td class=title width="9%">��ȣ</td>
                    <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%></td>
                    <td class=title width="9%">�����</td>
                    <td width="11%">&nbsp;<%=cont.get("CLIENT_NM")%></td>
                    <td class=title width="9%">��뺻����</td>
                    <td width="14%">&nbsp;<%=cont.get("R_SITE")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(cont.get("INIT_REG_DT")))%></td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=cont.get("USER_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>����ȸ��</td>
                    <td >&nbsp;<b><font color='#990000'><%=ins_com_nm%></font></b></td>
                    <td class=title>���ι��</td>
                    <td width=9%> 
                      <%if(ins.getVins_pcp_kd().equals("1")){%>
                      &nbsp;����
                      <%}%>
                      <%if(ins.getVins_pcp_kd().equals("2")){%>
                      &nbsp;����
                      <%}%>
                    </td>
                    <td width=9% class=title>�빰���</td>
                    <td width=9%> 
                      <%if(ins.getVins_gcp_kd().equals("6")){%>
                      &nbsp;5��� 
                      <%}%>
					  <%if(ins.getVins_gcp_kd().equals("8")){%>
                      &nbsp;3��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("7")){%>
                      &nbsp;2��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("3")){%>
                      &nbsp;1��� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("1")){%>
                      &nbsp;3õ���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("2")){%>
                      &nbsp;1õ5�鸸�� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("5")){%>
                      &nbsp;1õ���� 
                      <%}%>
                      <%if(ins.getVins_gcp_kd().equals("4")){%>
                      &nbsp;5õ���� 
                      <%}%>
                    </td>
                    <td class=title>�ڱ��ü</td>
                    <td colspan="3">&nbsp;1�δ���/���: 
                      <%if(ins.getVins_bacdt_kd().equals("1")){%>
                      3���
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("2")){%>
                      1��5õ����
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("3")){%>
                      3õ����
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("4")){%>
                      1õ5�鸸��
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("5")){%>
                      5õ����
                      <%}%>
                      <%if(ins.getVins_bacdt_kd().equals("6")){%>
                      1���
                      <%}%>
                      , 1�δ�λ�: 
                      <%if(ins.getVins_bacdt_kc2().equals("1")){%>
                      3���
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("2")){%>
                      1��5õ����
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("3")){%>
                      3õ����
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("4")){%>
                      1õ5�鸸��
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("5")){%>
                      5õ����
                      <%}%>
                      <%if(ins.getVins_bacdt_kc2().equals("6")){%>
                      1���
                      <%}%>
                    </td>
                </tr>
                <tr>
                  <td class=title>�Ǻ�����</td>
                  <td>&nbsp;
				    <%if(ins.getCon_f_nm().equals("�Ƹ���ī")){%><%=ins.getCon_f_nm()%><%}else{%><b><font color='#990000'><%=ins.getCon_f_nm()%></font></b><%}%></td>
		  <td class=title>���迬��</td>
                  <td>&nbsp;
                    	<%if(ins.getAge_scp().equals("1")){%>21���̻�<%}%>
                        <%if(ins.getAge_scp().equals("4")){%>24���̻�<%}%>
                        <%if(ins.getAge_scp().equals("2")){%>26���̻�<%}%>
                        <%if(ins.getAge_scp().equals("3")){%>������<%}%>
                        <%if(ins.getAge_scp().equals("5")){%>30���̻�<%}%>
                        <%if(ins.getAge_scp().equals("6")){%>35���̻�<%}%>
                        <%if(ins.getAge_scp().equals("7")){%>43���̻�<%}%>
			<%if(ins.getAge_scp().equals("8")){%>48���̻�<%}%>
                  </td>              		    
                  <td class=title>������������</td>
                  <td>&nbsp;
                    <%if(ins.getVins_canoisr_amt()>0){%>
                    ����<%}else{%>-
                  <%}%></td>
                  <td class=title>�ڱ���������</td>
                  <td>&nbsp;
				    <%if(ins.getVins_cacdt_cm_amt()>0){%>
					<b><font color='#990000'>
                    ����
				    ( ���� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>����,
					�ڱ�δ�� <%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>����)
					</font></b>
					<%}else{%>-
                  <%}%>
                  </td>
                  <td class=title>������å��</td>
                  <td>&nbsp;
                  	<%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(String.valueOf(cont.get("CAR_ST")).equals("2")){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%><a href="javascript:res_search()">�뿩����</a></td>
                    <td width=12%> 
                      <input type="text" name="sub_rent_gu_nm" value="" size="10" class=whitetext>                      
                      <input type='hidden' name="rent_s_cd" value=''>
                      <input type='hidden' name="sub_rent_gu" value=''>
                    </td>
                    <td class=title width=9%>��ȣ</td>
                    <td width=27%> 
                      <input type="text" name="sub_firm_nm" value="" size="25" class=whitetext>
                    </td>
                    <td class=title width=9%>���Ⱓ</td>
                    <td width=34%> 
                      <input type="text" name="sub_rent_st" value="" size="10" class=whitetext>
                      ~ 
                      <input type="text" name="sub_rent_et" value="" size="10" class=whitetext>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�޸�</td>
                    <td colspan="5">
                  <input type="text" name="memo" size="105" class="text">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%}%>	
	
<%	if(accid_size > 0) {%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����̷� (�ֱ� �ִ�5��)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
            	<tr> 
                	<td width='5%' class='title'>����</td>
                        <td width='10%' class='title'>�����</td>
                        <td width='15%' class='title'>����Ͻ�</td>
                        <td width='15%' class='title'>��ȣ</td>                        
                        <td width='10%' class='title'>����������ȣ</td>
                        <td width='15%' class='title'>������</td>
                        <td width='15%' class='title'>�����</td>
                        <td width='6%' class='title'>������</td>
                        <td width='9%' class='title'>��������</td>
                </tr>
                <tr> 
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                          <tr> 
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><a name="<%=i+1%>"><%=i+1%> 
                              <%if(accid.get("USE_YN").equals("Y")){%>
                              <%}else{%>
                              (�ؾ�) 
                              <%}%>
                            </a></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=accid.get("ACCID_ST_NM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>                            
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'> 
                              <%if(accid.get("FIRM_NM").equals("(��)�Ƹ���ī") && !accid.get("CUST_NM").equals("")){%>
                              <span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'>(<%=accid.get("RES_ST")%>)<%=Util.subData(String.valueOf(accid.get("CUST_NM")), 6)%></span>	
                              <%}else{%>
                              <span title='<%=accid.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 11)%></span> 
                              <%}%>
                            </td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align="center"><%=accid.get("OUR_NUM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> >&nbsp;<span title='<%=accid.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_ADDR")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> >&nbsp;<span title='<%=accid.get("ACCID_CONT")%> <%=accid.get("ACCID_CONT2")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_CONT"))+" "+String.valueOf(accid.get("ACCID_CONT2")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(accid.get("REG_DT")))%></td>
                          </tr>
          <%		}%>

                </tr>
            </table>
        </td>
    </tr>
<%	}%>	
 	<tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>��������</td>
                    <td width=30%>
                      <input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=9%>������</td>
                    <td colspan=2 width=52%> 
                      <select name='reg_id'>
                        <option value="">������</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title width=9%>�����</td>
                    <td colspan="3" >
                      <input type="checkbox" name="dam_type1" value="Y"  <%if(s_gubun1.equals("2") || s_gubun1.equals("3"))%>checked<%%>>
                      ���� 
                      <input type="checkbox" name="dam_type2" value="Y"  <%if(s_gubun1.equals("2") || s_gubun1.equals("3"))%>checked<%%>>
                      �빰 
                      <input type="checkbox" name="dam_type3" value="Y"  <%if(!s_gubun1.equals("3"))%>checked<%%>>
                      �ڼ� 
                      <input type="checkbox" name="dam_type4" value="Y"  <%if(!s_gubun1.equals("3"))%>checked<%%>>
                      ����</td>
                </tr>               
                <tr> 
                    <td class=title>Ư�̻���</td>
                    <td colspan="3">
                      <textarea name="sub_etc" cols="120" class="text" rows="3"></textarea>
                    </td>                                   
                </tr>
            </table>
        </td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
	<%if(!s_gubun1.equals("4")){%>
    <tr id=tr1 style="display:<%if(s_gubun1.equals("4")){%>none<%}else{%>''<%}%>"> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                              <td class=title colspan="2">�������</td>
                              <td width=30%>
                                <select name='accid_type'>
                                  <option value="">����</option>
                                  <option value="1">������</option>
                                  <option value="2">������</option>
                                  <option value="3">�����ܵ�</option>
                                  <option value="4">���뿭��</option>
                                </select>
                              </td>
                              <td class=title width=9%>����Ͻ�</td>
                              <td width="52%"> 
                                <input type="text" name="accid_dt" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                <input type="text" name="accid_dt_h" size="2" class=text maxlength="2">
                                �� 
                                <input type="text" name="accid_dt_m" size="2" class=text maxlength="2">
                                �� <font color="#808080">(�ð�:0-23)</font> </td>
                            </tr>
                            <tr> 
                              <td class=title colspan="2">������</td>
                              <td colspan="3">
                                <select name='accid_type_sub'>
                                  <option value="">����</option>
                                  <option value="1">���Ϸ�</option>
                                  <option value="2">������</option>
                                  <option value="3">ö��ǳθ�</option>
                                  <option value="4">Ŀ���</option>
                                  <option value="5">����</option>
                                  <option value="6">������</option>
                                  <option value="7">����</option>
                                  <option value="8">��Ÿ</option>
                                </select>
                                <input type="text" name="accid_addr" class=text size="110">
                              </td>
                            </tr>
                            <tr> 
                              <td class=title width=3% rowspan="2">������</td>
                              <td class=title width=6% height="76">��?</td>
                              <td colspan="3" height="76"> 
                                <textarea name="accid_cont" cols="120" rows="3"></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td class=title>���?</td>
                              <td colspan="3"> 
                                <textarea name="accid_cont2" cols="120" rows="4"></textarea>
                              </td>
                            </tr>
                            <tr> 
                              <td class=title colspan="2">���Ǻ���</td>
                              <td>��� 
                                <input type="text" name="our_fault_per" size="4" value="<%=our_p%>" class=num onBlur='javascript:document.form1.ot_fault_per.value=Math.abs(toInt(this.value)-100);'>
                                : 
                                <input type="text" name="ot_fault_per" size="4" value="<%=ot_p%>" class=num onBlur='javascript:document.form1.our_fault_per.value=Math.abs(toInt(this.value)-100);'>
                                ���� </td>
                              <td class=title>�ߴ���ǿ���</td>
                              <td> 
                                <select name="imp_fault_st">
                                  <option value="">����</option>
                                  <option value="1">����</option>
                                  <option value="2">��ȣ����</option>
                                  <option value="3">�ӵ�����</option>
                                  <option value="4">Ⱦ�ܺ���</option>
                                  <option value="5">�߾Ӽ�ħ��</option>
                                  <option value="6">����ĵ���</option>
                                  <option value="7">������������</option>
                                  <option value="8">ö��</option>
                                  <option value="9">�ε�</option>
                                  <option value="10">��Ÿ</option>
                                </select>
                                <input type="text" name="imp_fault_sub" size="30" class=text>
                              </td>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��� ���</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=9%>�ӵ�</td>
                    <td width=30%> 
                      <input type="text" name="speed" value="" size="4" class=num>
                      km/h </td>
                    <td class=title width=9%>�������</td>
                    <td width=52%> 
                      <input type="radio" name="weather" value="1" checked>
                      ���� 
                      <input type="radio" name="weather" value="2">
                      �帲 
                      <input type="radio" name="weather" value="3">
                      �� 
                      <input type="radio" name="weather" value="4">
                      �Ȱ� 
                      <input type="radio" name="weather" value="5">
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>��������</td>
                    <td> 
                      <input type="radio" name="road_stat" value="1" checked>
                      ���� 
                      <input type="radio" name="road_stat" value="2">
                      ������</td>
                    <td class=title>���θ����</td>
                    <td> 
                      <input type="radio" name="road_stat2" value="1" checked>
                      ���� 
                      <input type="radio" name="road_stat2" value="2">
                      ���� 
                      <input type="radio" name="road_stat2" value="3">
                      ���� 
                      <input type="radio" name="road_stat2" value="4">
                      ��Ÿ</td>
                </tr>
            </table>
        </td>
    </tr>		
	<%}else{%>	
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr> 
                              <td class=title width=9%>�������</td>
                              <td width=30%> 
                                <select name='accid_type'>
                                  <option value="">����</option>
                                  <option value="1">������</option>
                                  <option value="2">������</option>
                                  <option value="3" selected>�����ܵ�</option>
                                  <option value="4">���뿭��</option>
                                </select>
                              </td>
                              <td class=title width=9%>����Ͻ�</td>
                              <td width=52%> 
                                <input type="text" name="accid_dt" size="11" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                                <input type="text" name="accid_dt_h" size="2" class=text  maxlength="2">
                                �� 
                                <input type="text" name="accid_dt_m" size="2" class=text  maxlength="2">
                                �� <font color="#808080">(�ð�:0-23)</font> </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��� ���</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
              <tr> 
                <td class=title width=9%>�ӵ�</td>
                <td width=30%> 
                  <input type="text" name="speed" value="" size="4" class=num >
                  km/h </td>
                <td class=title width="80">�������</td>
                <td width="450"> 
                  <input type="radio" name="weather" value="1" checked>
                  ���� 
                  <input type="radio" name="weather" value="2">
                  �帲 
                  <input type="radio" name="weather" value="3">
                  �� 
                  <input type="radio" name="weather" value="4">
                  �Ȱ� 
                  <input type="radio" name="weather" value="5">
                  ��</td>
              </tr>
              <tr> 
                <td class=title width=9%>��������</td>
                <td width=52%> 
                  <input type="radio" name="road_stat" value="1" checked>
                  ���� 
                  <input type="radio" name="road_stat" value="2">
                  ������</td>
                <td class=title width="70">���θ����</td>
                <td> 
                  <input type="radio" name="road_stat2" value="1" checked>
                  ���� 
                  <input type="radio" name="road_stat2" value="2">
                  ���� 
                  <input type="radio" name="road_stat2" value="3">
                  ���� 
                  <input type="radio" name="road_stat2" value="4">
                  ��Ÿ</td>
              </tr>
            </table>
        </td>
    </tr>			
	<%}%>		
    <tr> 
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        <%}%>	  
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
