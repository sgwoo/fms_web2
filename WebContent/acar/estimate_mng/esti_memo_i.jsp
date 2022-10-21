<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_mst.*, acar.estimate_mng.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	e_bean = e_db.getEstimateCase(est_id);
	
	//CAR_NM : ��������
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function save(){
		var fm = document.form1;
		if(fm.est_id.value == ''){ alert('est_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(fm.user_id.value == ''){ alert('user_id�� �����ϴ�. Ȯ���Ͻʽÿ�.'); return; }
		if(!confirm('����Ͻðڽ��ϱ�?')){	return; }					
		fm.target = "i_no";
		fm.submit();
	}
	
	function change(arg){
		var fm = document.form1;
		//arg = trim(arg);
		if(arg=='01')	fm.note.value = "������";
		else if(arg=='02')	fm.note.value = "���";
		else if(arg=='03')	fm.note.value = "���׳�";
		else if(arg=='04')	fm.note.value = "����� ��Ȯ��";
		else if(arg=='05')	fm.note.value = "�������";
		else if(arg=='06')	fm.note.value = "������ü";
		else if(arg=='07')	fm.note.value = "�ܱ�뿩";
		else if(arg=='08')	fm.note.value = "�񱳰�����";
		else if(arg=='09')	fm.note.value = "����������ȸ";
		else if(arg=='10')	fm.note.value = "�����ü���������";
		else if(arg=='11')	fm.note.value = "Ÿ�緻Ʈ(����)�� �����";
		else if(arg=='12')	fm.note.value = "�Һα�����";
		else if(arg=='13')	fm.note.value = "��Ⱓ����";
		else if(arg=='14')	fm.note.value = "�̸�������";
		else if(arg=='15')	fm.note.value = "��������";
		else if(arg=='16')	fm.note.value = "���ü��";
		else if(arg=='17')	fm.note.value = "������";
		else if(arg=='18')	fm.note.value = "��Ÿ";
	}
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;
                    	<%if (from_page.equals("esti_mng_sc_in.jsp")) {%>
                    	<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > �������������� > <span class=style5>��ȭ����</span></span>
                    	<%} else if (from_page.equals("esti_sh_sc_in.jsp")) {%>
                    	<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > �縮������������ > <span class=style5>��ȭ����</span></span>
                    	<%} else if (from_page.equals("esti_ext_sc_in.jsp")) {%>
                    	<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > ������������� > <span class=style5>��ȭ����</span></span>
                    	<%} else {%>
                    	<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > �������� > �������������� > <span class=style5>��ȭ����</span></span> : ��ȭ����
                    	<%}%>
                    </td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class="line">
	        <table border="0" cellspacing="1" cellpadding=0 width=100%>
	  <%if(e_bean.getEst_ssn().length() < 13){%>
                <tr>
                    <td class=title width=14%>��ȣ</td>
                    <td width=36%>&nbsp;<%=e_bean.getEst_nm()%></td>
                    <td width=14% class=title>����ڹ�ȣ</td>
                    <td width=36%>&nbsp;<%=e_bean.getEst_ssn()%></td>
                </tr>
                <tr>
                    <td class=title>��ǥ��</td>
                    <td>&nbsp;<%=e_bean.getMgr_nm()%></td>
                    <td class=title>��ǥ��<br>�������</td>
                    <td>&nbsp;<%=e_bean.getMgr_ssn()%></td>
                </tr>
        		<%}else{%>
                <tr>
                    <td class=title width=14%>����</td>
                    <td width=36%>&nbsp;<%=e_bean.getEst_nm()%></td>
                    <td width=14% class=title>�������</td>
                    <td width=36%>&nbsp;<%=e_bean.getEst_ssn()%></td>
                </tr>
                <tr>
                    <td class=title>����</td>
                    <td colspan="3">&nbsp;<%=e_bean.getJob()%></td>
                </tr>
        		<%}%>
                <tr>
                    <td class=title>��ȭ��ȣ</td>
                    <td align="left">&nbsp;<%=e_bean.getEst_tel()%></td>
                    <td class=title>FAX</td>
                    <td>&nbsp;<%=e_bean.getEst_fax()%></td>
                </tr>
                <%if(!e_bean.getTalk_tel().equals("")){%>		
                <tr>
                    <td class=title>��㿬��ó</td>
                    <td colspan="3">&nbsp;<%=e_bean.getTalk_tel()%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
    	<td class=line>            
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr>                 
                    <td class=title>�ſ뵵����</td>
                    <td colspan=5>
                    &nbsp;<% if(e_bean.getSpr_yn().equals("3")) out.print("�ż�����"); %>
                    <% if(e_bean.getSpr_yn().equals("0")) out.print("�Ϲݱ��"); %>
                    <% if(e_bean.getSpr_yn().equals("1")) out.print("�췮���"); %>
                    <% if(e_bean.getSpr_yn().equals("2")) out.print("�ʿ췮���"); %>
    			    </td>
                </tr>    	  
                <tr>                 
                    <td class=title>����</td>
                    <td colspan="3">
                        <table border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=cm_bean.getCar_comp_nm()%> <%=cm_bean.getCar_nm()%> <%=cm_bean.getCar_name()%></td>  
                            </tr>
                        </table>
                    </td>              
                    <td class=title>��������</td>                
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean.getO_1())%>��</td>
                </tr>
                <tr>                 
                    <td class=title>�ɼ�</td>
                    <td colspan="3">&nbsp;<%=e_bean.getOpt()%></td>                
                    <td class=title>����</td>                
                    <td>&nbsp;<%=e_bean.getCol()%></td>
                </tr>
                <tr>                 
                    <td class=title width=14%>�뿩��ǰ</td>                    
                    <td width=21%>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%></td>                    
                    <td width=14% class=title>�뿩�Ⱓ</td>                    
                    <td width=15%>&nbsp;<%=e_bean.getA_b()%>����</td>                    
                    <td class=title width=14%>�������</td>                    
                    <td width=22%>&nbsp;
                    	<%=c_db.getNameByIdCode("0032", "", e_bean.getA_h())%>                    	
                    </td>
                </tr>
                <tr>                 
                    <td class=title>������</td>                
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>��</td>                
                    <td class=title>������</td>                
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%>��</td>                
                    <td class=title>���ô뿩��</td>                
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>��</td>
                </tr>
                <tr>                 
                    <td class=title>���뿩��</td>
                    <td colspan=5>&nbsp;<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>��</td>
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
                        <table  border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td class=title width=22%>��¥</td>
                                <td class=title width=14%>�ۼ���</td>
                                <td class=title width=64%>��ȭ����</td>
                            </tr>
                        </table>        					
                    </td>        					
                    <!-- <td width=16>&nbsp;</td> -->
				</tr>
            </table>
		</td>
	</tr>
    <tr>
		<td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td colspan=2><iframe src="./esti_memo_i_in.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>&from_page=<%=from_page%>" name="i_in" width="100%" height="160" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>    
    <tr>
        <td></td>
    </tr>
<form action="./esti_memo_null_ui.jsp" name="form1" method="POST" >
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="est_id" value="<%=est_id%>">
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="from_page" value="<%=from_page%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
				<!--
                <tr>
                    <td class=title width="100">����</td>
                    <td align="center" width="430"><input type="text" name="sub" value="" size="69" class=text></td>
                </tr>
                -->
                <tr>
                    <td class=title width=14%>
                    	<span title="01:������ 02:��� 03:���׳� 04:����ڹ�Ȯ�� 05:������� 06:������ü 07:�ܱ�뿩 08:�񱳰����� 09:����������ȸ 10:�����ü���������� 11:Ÿ�緻Ʈ(����)�ΰ���� 12:�Һα����� 13:��Ⱓ���� 14:�̸������� 15:�������� 16:���ü�� 17:������ 18:��Ÿ">��ȭ����</span>
                    </td>
                    <td>&nbsp;
                    	<textarea class=default name="note" cols=77 rows=5 onBlur="javascript:change(this.value);"></textarea>
                    </td>
                </tr>

           </table>
        </td>
    </tr>
</form>
    <tr>    	
        <td align="right"><a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;<a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>