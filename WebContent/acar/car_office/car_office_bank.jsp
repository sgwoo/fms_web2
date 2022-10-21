<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String car_off_nm 	= request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_comp_nm 	= request.getParameter("car_comp_nm")==null?"":request.getParameter("car_comp_nm");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//����������
	co_bean = cod.getCarOffBean(car_off_id);
	
	car_off_nm = co_bean.getCar_off_nm();
	car_comp_nm = co_bean.getCar_comp_nm();
	
	//��Ÿ���¸���Ʈ
	Vector vt = c_db.getBankAccList("car_off_id", car_off_id, "");
	int vt_size = vt.size();
	
	//���ฮ��Ʈ
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function CarOffReg()
{
	var fm = document.form1;
	if(fm.st.value == '')		fm.st.value = 'etc';
	if(fm.st.value == 'main' && '<%=co_bean.getAcc_no()%>' != '')	{ alert('��ǥ���´� �̹� ��� �Ǿ� �ֽ��ϴ�.'); return; }
	if(fm.seq.value != '')		{ alert('�̹� ��ϵ� �����Դϴ�.'); 		return; }
	if(fm.bank_cd.value == '')		{ alert('���°��������� �Է��Ͻʽÿ�.'); 	return; }
	if(fm.acc_no.value == '')	{ alert('���¹�ȣ�� �Է��Ͻʽÿ�.'); 		return; }
	if(fm.acc_nm.value == '')	{ alert('���¿����ָ� �Է��Ͻʽÿ�.'); 		return; }		
	if(fm.st.value == 'etc'){
		if(fm.acc_st.value == '')	{ alert('���±����� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.use_yn.value == '')	{ fm.use_yn.value = 'Y'; //alert('��뿩�θ� �Է��Ͻʽÿ�.'); 	return; 
		}
	}
	if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
	fm.cmd.value = "i";
	fm.action = "car_office_bank_a.jsp"
	fm.target = "i_no"
	fm.submit();
}

function CarOffUp()
{
	var fm = document.form1;
	if(fm.seq.value == '')		{ alert('�̵�ϵ� ���̶� �����Ҽ� �����ϴ�.'); return; }
	if(fm.bank_cd.value == '')		{ alert('���°��������� �Է��Ͻʽÿ�.'); 	return; }
	if(fm.acc_no.value == '')	{ alert('���¹�ȣ�� �Է��Ͻʽÿ�.'); 		return; }
	if(fm.acc_nm.value == '')	{ alert('���¿����ָ� �Է��Ͻʽÿ�.'); 		return; }			
	if(fm.st.value == 'etc'){
		if(fm.acc_st.value == '')	{ alert('���±����� �Է��Ͻʽÿ�.'); 	return; }
		if(fm.use_yn.value == '')	{ alert('��뿩�θ� �Է��Ͻʽÿ�.'); 	return; }
	}	
	if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
	fm.cmd.value = "u";
	fm.action = "car_office_bank_a.jsp"
	fm.target = "i_no"
	fm.submit();
}

function CarOffDel(){
	var fm = document.form1;
	if(fm.st.value == 'main')	{ alert('��ǥ���´� �����Ҽ� �����ϴ�.'); return; }
	if(fm.seq.value == '')		{ alert('������ ���°� �����ϴ�.'); return; }
	if(!confirm('�����Ͻðڽ��ϱ�?')){	return;	}
	if(!confirm('���������� �����ϴ�. �����Ͻðڽ��ϱ�?')){	return;	}	
	fm.cmd.value = "d";
	fm.action = "car_office_bank_a.jsp"
	fm.target = "i_no"
	fm.submit();
}

function setCarOffBank(st, seq, bank, acc_st, acc_no, acc_nm, use_yn, bank_cd){
	var fm = document.form1;
	fm.st.value 		= st;
	fm.seq.value 		= seq;
	fm.bank.value 		= bank;
	fm.bank_cd.value 		= bank_cd;
	fm.acc_st.value 	= acc_st;	
	fm.acc_no.value 	= acc_no;
	fm.acc_nm.value 	= acc_nm;
	fm.use_yn.value 	= use_yn;
}

function SelfReload(){
	var fm = document.form1;
	fm.action = "car_office_bank.jsp"
	fm.target = "OfficeBank"
	fm.submit();
}
//-->
</script>
</head>
<body leftmargin="15">
<form action="car_office_bank_a.jsp" name="form1" method="POST" >
  <input type="hidden" name="car_comp_id" value="<%= car_comp_id %>">
  <input type="hidden" name="car_off_id" value="<%= car_off_id %>">
  <input type="hidden" name="car_comp_nm" value="<%= car_comp_nm %>">
  <input type="hidden" name="car_off_nm" value="<%= car_off_nm %>">
  <input type="hidden" name="st" value="">
  <input type="hidden" name="seq" value="">
  <input type="hidden" name="cmd" value="">    
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>�����Ұ���</span></span> : �����Ұ��°���</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=15% class=title>�ڵ���ȸ��</td>
			    	<td width=35%><%= car_comp_nm %></td>
			    	<td width=15% class=title>�ڵ���������</td>
			        <td width=35%><%= car_off_nm %></td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ǥ����</span></td>
    </tr>			
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=5% class=title>����</td>												
			    	<td width=33% class=title>���°�������</td>				
			    	<td width=22% class=title>���¹�ȣ</td>
			    	<td width=40% class=title>������</td>
            	</tr>
            	<tr>
			    	<td align=center>1</td>								
			    	<td align=center><%=co_bean.getBank()%></td>
			        <td align=center><a href="javascript:setCarOffBank('main','0','<%=co_bean.getBank()%>','','<%=co_bean.getAcc_no()%>','<%=co_bean.getAcc_nm()%>','Y','<%=co_bean.getBank_cd()%>')" onMouseOver="window.status=''; return true"><%=co_bean.getAcc_no()%><%if(co_bean.getAcc_no().equals("")){%>�̵��<%}%></a></td>
					<td align=center><%=co_bean.getAcc_nm()%></td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ����</span></td>
    </tr>		
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=5% class=title>����</td>								
			    	<td width=20% class=title>���°�������</td>				
			    	<td width=13% class=title>���±���</td>									
			    	<td width=22% class=title>���¹�ȣ</td>
			    	<td width=28% class=title>������</td>
			    	<td width=12% class=title>��뿩��</td>					
            	</tr>
				<%	for (int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);%>
            	<tr>
			    	<td align=center><%=i+2%></td>				
			    	<td align=center><%=ht.get("BANK_NM")%></td>
			    	<td align=center><%=ht.get("ACC_ST_NM")%></td>					
			        <td align=center><a href="javascript:setCarOffBank('etc','1','<%=ht.get("BANK_NM")%>','<%=ht.get("ACC_ST")%>','<%=ht.get("ACC_NO")%>','<%=ht.get("ACC_NM")%>','<%=ht.get("USE_YN")%>','<%=ht.get("BANK_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ACC_NO")%></a></td>
					<td align=center><%=ht.get("ACC_NM")%></td>
					<td align=center><%=ht.get("USE_YN")%></td>					
            	</tr>
				<%	}%>
				<%	if(vt_size==0){%>
				<tr>
					<td colspan='6' align=center>����Ÿ�� �����ϴ�.</td>
				</tr>
				<%	}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td><hr></td>
    </tr>		
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
            	<tr>
			    	<td width=25% class=title>���°�������</td>				
			    	<td width=13% class=title>���±���</td>									
			    	<td width=22% class=title>���¹�ȣ</td>
			    	<td width=28% class=title>������</td>
			    	<td width=12% class=title>��뿩��</td>					
            	</tr>
            	<tr>
			    	<td align=center>
			    		<input type='hidden' name="bank" 			value="">
						<select name="bank_cd">
							<option value="">����</option>
							<%	for(int i=0; i<cd_r.length; i++){
        							cd_bean = cd_r[i];%>
            				<option value="<%= cd_bean.getCode() %>"><%= cd_bean.getNm() %></option>
							<%	}%> 					
						</select>
					</td>
			    	<td align=center>
						<select name="acc_st">
							<option value="">����</option>
            				<option value="1">��������</option>
            				<option value="2">�������</option>							
						</select>
					</td>					
			        <td align=center><input type="text" name="acc_no" value="" size="22" class=text></td>
					<td align=center><input type="text" name="acc_nm" value="" size="30" class=text></td>
			    	<td align=center>
						<select name="use_yn">
							<option value="">����</option>
            				<option value="Y">���</option>
            				<option value="N">�̻��</option>							
						</select>
					</td>								
            	</tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td>* F5Ű�� Ŭ���ϸ� �ʱ�ȭ �˴ϴ�. </td>
    </tr>	
    <tr>
        <td align=right>
			<a href="javascript:CarOffReg()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
			<a href="javascript:CarOffUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;
			<%if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>
			<a href="javascript:CarOffDel()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>&nbsp;
			<%}%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>			
		</td>
    </tr>			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
