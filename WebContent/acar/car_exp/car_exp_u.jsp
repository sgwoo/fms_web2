<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*,acar.common.*"%>
<%@ page import="acar.mng_exp.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='../../include/table_t.css'>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function modify()
	{
		if(confirm('�����Ͻðڽ��ϱ�?'))
		{
			var fm = document.form1;
			if((fm.car_mng_id.value == '')){		alert('������ �����Ͻʽÿ�');	return;	}
			else if(!isCurrency(fm.rtn_amt.value) || (parseDigit(fm.rtn_amt.value).value > 9))	{	alert('�ݾ��� Ȯ���Ͻʽÿ�');	return;	}
			else if(!isDate(fm.rtn_dt.value)){	alert('���⿹������ Ȯ���Ͻʽÿ�');	return;	}
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String exp_st = request.getParameter("exp_st")==null?"":request.getParameter("exp_st");
	String est_dt = request.getParameter("est_dt")==null?"":request.getParameter("est_dt");
	String user_id = "";
	String br_id = "";
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "08");
	
	GenExpBean exp = ex_db.getGenExp(car_mng_id, exp_st, est_dt);
	
	//��������
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//�ڵ���ȸ��&����&�ڵ�����
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(exp.getRent_mng_id(), exp.getRent_l_cd());
	
	Vector exps = ex_db.getCarExpList("", "", "", "", "", "", "", "99", car_mng_id, "", "");
	Hashtable ht = (Hashtable)exps.elementAt(0);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
  	//�����������
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  
	//�����з�
	CodeBean[] code41 = c_db.getCodeAll3("0041");
	int code41_size = code41.length;
	
%>
<form action='car_exp_u_a.jsp' name='form1' method='post'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='exp_st' value='<%=exp_st%>'>
<input type='hidden' name='est_dt' value='<%=est_dt%>'>
<input type='hidden' name='rtn_cau' value='<%=ht.get("RTN_ST")%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width="17%" class='title'>������ȣ</td>
                    <td width="26%">&nbsp;<%=exp.getCar_no()%></td>
                    <td width='17%' class='title'>����</td>
                    <td width="40%">&nbsp;<%=mst.getCar_nm()+" "+mst.getCar_name()%></span></td>
                </tr>
                <tr> 
                    <td class='title'> ���ʵ���� </td>
                    <td>&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                    <td class='title'> ���� </td>
                    <td>
                      &nbsp;<%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                      
        			</td>
                </tr>
                <tr>
                    <td class='title'>��ⷮ</td>
                    <td>&nbsp;<%=cr_bean.getDpm()%>cc</td>
                    <td class='title'>�뵵</td>
                    <td>
                      &nbsp;<%if(cr_bean.getCar_use().equals("1")){%>������<%}else if(cr_bean.getCar_use().equals("2")){%>�ڰ���<%}%></option>
                      </select>			
        			</td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>            
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
                <tr> 
                    <td width="17%" class='title'>��������</td>
                    <td colspan="">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_END_DT")))%></td>
					<td width="17%" class='title'>���μ���</td>
                    <td width="">&nbsp;<%=Util.parseDecimal(String.valueOf(ht.get("EXP_AMT")))%>��</td>
                </tr>
                <tr> 
                    <td width="17%" class='title'> �������� </td>
                    <td width="40%">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXP_DT")))%></td>
					<td class='title'>�����߻�����</td>
                    <td>&nbsp;<input type='text' name='rtn_cau_dt' class='whitetext' size='11' maxlength='11'  value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RTN_CAU_DT")))%>'onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>ȯ�޻���</td>
                    <td>&nbsp;<%=ht.get("RTN_CAU")%></td>
                    <td class='title'>ȯ�ޱ���</td>
                    <td>&nbsp;<select name="exp_gubun">
					<option value="2" <%if(String.valueOf(ht.get("EXP_GUBUN")).equals("2"))%> selected<%%>>ȯ��</option>
                        <option value="1" <%if(String.valueOf(ht.get("EXP_GUBUN")).equals("1"))%> selected<%%>>�Ա�</option>
                        
                        <option value="3" <%if(String.valueOf(ht.get("EXP_GUBUN")).equals("3"))%> selected<%%>>���</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class='title'>ȯ�ޱ��</td>
                    <td>
        			  &nbsp;<select name="car_ext">
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(String.valueOf(ht.get("CAR_EXT")).equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                    <td class='title'>����������ȣ</td>
                    <td>&nbsp;<input type='text' name='exp_car_no' class='text' size='15' maxlength='20'  value='<%=ht.get("EXP_CAR_NO")%>'></td>			  
                </tr>
                <tr>
                    <td class='title'>ȯ�޽�û��</td>
                    <td>&nbsp;<input type='text' name='rtn_req_dt' class='text' size='11' maxlength='11'  value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RTN_REQ_DT")))%>'onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                    <td class='title'>ȯ�޿����ݾ�</td>
                    <td>&nbsp;<input type='text' name='rtn_est_amt' class='num' size='10' maxlength='12'  value='<%=Util.parseDecimal(String.valueOf(ht.get("RTN_EST_AMT")))%>'onBlur='javascript:this.value = parseDecimal(this.value);'>
                    ��</td>
                </tr>
                <tr> 
                    <td class='title'>ȯ������</td>
                    <td>&nbsp;<input type='text' name='rtn_dt' class='text' size='11' maxlength='11'  value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RTN_DT")))%>'onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                    <td class='title'>ȯ�ޱݾ�</td>
                    <td>&nbsp;<input type='text' name='rtn_amt' class='num' size='10' maxlength='12'  value='<%=Util.parseDecimal(String.valueOf(ht.get("RTN_AMT")))%>'onBlur='javascript:this.value = parseDecimal(this.value);'>
        			��</td>
                </tr>
				<tr> 
                    <td class='title' width="17%">���</td>
                    <td colspan="3">&nbsp;<TEXTAREA NAME="exp_gita" ROWS="5" COLS="75"><%=ht.get("EXP_GITA")%></TEXTAREA></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
		<td align='right'>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			<a href='javascript:modify()'><img src=../images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;		
		<%}%>
			<a href='javascript:window.close()'><img src=../images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>    
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>