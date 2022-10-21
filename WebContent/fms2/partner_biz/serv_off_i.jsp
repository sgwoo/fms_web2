<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*, acar.partner.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	
	//PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getServ_empAll();
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//�����縮��Ʈ
	//Vector bank_vt =  ps_db.getCodeList("0003");
//	int bank_size = bank_vt.size();
	
	CodeBean code_r [] = c_db.getFinanceCode("");
	
	Hashtable ht = se_dt.getServOff(off_id);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function ServOffReg(){
	var fm = document.form1;
	if(fm.off_nm.value==""){ alert("��ȣ�� �Է��� �ּ���!"); fm.off_nm.focus(); return; }
	
	<%if(cmd.equals("u")){%>
		if(!confirm('�ش��ü�� �����Ͻðڽ��ϱ�?')){ return; }
		fm.cmd.value = "off_u";
	<%}else{%>
		if(fm.car_comp_id.value=="" || fm.car_comp_id.value=="0000"){ alert("��ü������ ������ �ּ���!");  return; }
		<%if(gubun1.equals("0001")){%>
		if(fm.gubun_b.value==""){ alert("������� �з������� ������ �ּ���!");  return; }
		<%}%>
		if(!confirm('�ش��ü�� ����Ͻðڽ��ϱ�?')){ return; }
		fm.cmd.value = "off_i";
	<%}%>
	
	fm.action = "serv_emp_a.jsp";
	fm.target = "i_no";
	fm.submit();
}

//���༱�ý� ���¹�ȣ ��������
function change_bank(){
	var fm = document.form1;
	var bank_code = fm.bank.options[fm.bank.selectedIndex].value;		
	fm.bank_id.value = bank_code.substring(0,4);
	fm.off_nm.value = bank_code.substring(5);
	
}

//-->
</script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/1.9.0/jquery.js"></script>
<script>
    $(function(){
        $("#car_comp_id").change(function(){
            a = $("#car_comp_id").val();
            if(a == "0001")
				document.form1.bank.disabled = false;
			else
				document.form1.bank.disabled = true;
        });
		$("select[name=bank]").val();

    });
	

</script>
</head>
<body leftmargin="10">
<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="off_type" value="<%=off_type%>">
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="bank_id" value="">
<%if(cmd.equals("i")){%>
<div class="navigation">
	<span class=style1>���԰��� ></span><span class=style5>��ü ���</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title width="10%">��������</td>
					<td align='left' width="40%">&nbsp;
						<select name="car_comp_id" style="width:100px" id="car_comp_id">
                        <%for(int i=0; i<cc_r.length; i++){
        											cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm_cd() %></option>
                        <%}%>
						</select>&nbsp;&nbsp;
						<select name="gubun_b" style="width:150px">
							<option value="">������� �з�����</option>
                           <option value="1">����</option>
						   <option value="2">��������</option>
						   <option value="3">ĳ��Ż</option>
						   <option value="4">ī��</option>
						   <option value="5">����</option>
						   <option value="0">��Ÿ</option>
						</select>
					</td>
				
                    <td class=title width="10%">��ȣ</td>
                    <td colspan="" align=left>&nbsp;
					<%if(gubun1.equals("0001")){%>
						<select name='bank'   disable=true onChange='javascript:change_bank()'>
							<option value=''>�����縮��Ʈ</option>
							<% 	 for(int i=0; i< code_r.length; i++){
      					       code_bean = code_r[i]; 	%>
      					    <option value='<%= code_bean.getCode()%>:<%= code_bean.getNm()%>'><%= code_bean.getNm()%></option>				
							<%	}%>
						</select>
					<%}%>
						<input type="text" name="off_nm" value="" size="25" class=text>

					</td>
				</tr>
                <tr> 
                    <td class=title width="15%">��������</td>
                    <td>&nbsp;
						<select name="br_id">
							<option value="S1">����</option>
							<option value="B1">����</option>
						</select>
					</td>
					<td class=title width="15%">��ǥ��ȭ</td>
                    <td align="">&nbsp;
					<input type="text" name="off_tel" value="" size="25" class=text></td>
				</tr>
				<tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('off_post').value = data.zonecode;
								document.getElementById('off_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>			
				  <td class=title width="15%">�ּ�</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="off_post" id="off_post" size="10" maxlength='7'>&nbsp;<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;
					<input type="text" name="off_addr" id="off_addr" size="100">
				  </td>
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
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title width="15%">�ŷ�����</td>
					<td align="" colspan="5">&nbsp;
					<input type="text" name="note" value="" size="100" class=text></td>
				</tr>
                <tr> 
                    <td class=title width="15%">���ʵ������</td>
                    <td align=left>&nbsp;
						<input type="text" name="reg_dt" value="<%=AddUtil.getDate()%>" size="20" class=white></td>
                    <td class=title width="15%">���ʰŷ���������</td>
                    <td>&nbsp;
						<input type="text" name="start_dt" value="" size="20" class=text></td>
					<td class=title width="15%">�ŷ���������</td>
                    <td>&nbsp;
						<input type="text" name="close_dt" value="" size="20" class=text></td>
				</tr>
				 <tr>
                    <td class=title width="15%">���</td>
                    <td align="" colspan="5">&nbsp;
					<input type="text" name="deal_note" value="" size="100" class=text></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right">
		<input type="button" class="button" value="���" onclick="ServOffReg()"/>
		<input type="button" class="button" value="�ݱ�" onclick="window.close()"/>
		
		<!--<a href='javascript:ServOffReg()' onMouseOver="window.status=''; return true"  class="ml-btn-4" style="text-decoration: none;">���</a> 
        &nbsp;&nbsp;<a href='javascript:self.close();window.close();' onMouseOver="window.status=''; return true"  class="ml-btn-4" style="text-decoration: none;">�ݱ�</a> -->
        </td>
    </tr>
  
</table>
<%}else if(cmd.equals("u")){%>
<div class="navigation">
	<span class=style1>���԰��� ></span><span class=style5>��ü ����</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title width="15%">��������</td>
					<td align='left'  width="40%">&nbsp;
						<select name="car_comp_id" style="width:100px">
                        <%for(int i=0; i<cc_r.length; i++){
        											cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(ht.get("CAR_COMP_ID").equals(cc_bean.getCode())){%> selected <%}%>><%= cc_bean.getNm_cd() %></option>
                        <%}%>
						</select>&nbsp;&nbsp;
						<select name="gubun_b" style="width:150px">
							<option value="">������� �з�����</option>
                           	<option value="1" <%if(ht.get("GUBUN_B").equals("1")){%>selected<%}%>>����</option>
						   	<option value="2" <%if(ht.get("GUBUN_B").equals("2")){%>selected<%}%>>��������</option>
						   	<option value="3" <%if(ht.get("GUBUN_B").equals("3")){%>selected<%}%>>ĳ��Ż</option>
						   	<option value="4" <%if(ht.get("GUBUN_B").equals("4")){%>selected<%}%>>ī��</option>
						   	<option value="5" <%if(ht.get("GUBUN_B").equals("5")){%>selected<%}%>>����</option>
						   	<option value="0" <%if(ht.get("GUBUN_B").equals("0")){%>selected<%}%>>��Ÿ</option>
						</select>
					</td>
				
                    <td class=title width="15%">��ȣ</td>
                    <td colspan="" align=left>&nbsp;
						<input type="text" name="off_nm" value="<%=ht.get("OFF_NM")%>" size="30" class=text>
					&nbsp;��������ڵ�<input type="text" name="cpt_cd" value="<%=ht.get("CPT_CD")%>" size="5" class=text>
						</td>
				</tr>
                <tr> 
                    <td class=title width="15%">��������</td>
                    <td>&nbsp;
						<select name="br_id">
							<option value="S1" <%if(ht.get("BR_ID").equals("S1")){%> selected <%}%>>����</option>
							<option value="B1" <%if(ht.get("BR_ID").equals("B1")){%> selected <%}%>>����</option>
						</select>
					</td>
					<td class=title width="15%">��ǥ��ȭ</td>
                    <td align="">&nbsp;
					<input type="text" name="off_tel" value="<%=ht.get("OFF_TEL")%>" size="25" class=text></td>
				</tr>
				<tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('off_post').value = data.zonecode;
								document.getElementById('off_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				  <td class=title width="15%">�ּ�</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="off_post" id="off_post" size="10" maxlength='7' value="<%=ht.get("OFF_POST")%>">&nbsp;<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;
					<input type="text" name="off_addr" id="off_addr" size="100" value="<%=ht.get("OFF_ADDR")%>">
				  </td>
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
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title width="15%">�ŷ�����</td>
					<td align="" colspan="5">&nbsp;
					<input type="text" name="note" value="<%=ht.get("NOTE")%>" size="100" class=text></td>
				</tr>
                <tr> 
                    <td class=title width="15%">���ʵ������</td>
                    <td align=left>&nbsp;
						<input type="text" name="reg_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>" size="20" class=white></td>
                    <td class=title width="15%">���ʰŷ���������</td>
                    <td>&nbsp;
						<input type="text" name="start_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DT")))%>" size="20" class=text></td>
					<td class=title width="15%">�ŷ���������</td>
                    <td>&nbsp;
						<input type="text" name="close_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLOSE_DT")))%>" size="20" class=text></td>
				</tr>
				 <tr>
                    <td class=title width="15%">���</td>
                    <td align="" colspan="5">&nbsp;
					<input type="text" name="deal_note" value="<%=ht.get("DEAL_NOTE")%>" size="100" class=text></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right">
		<input type="button" class="button" value="����" onclick="ServOffReg()"/>
		<input type="button" class="button" value="�ݱ�" onclick="window.close()"/>
		
		<!--<a href='javascript:ServOffReg()' onMouseOver="window.status=''; return true"  class="ml-btn-4" style="text-decoration: none;">����</a> 
        &nbsp;&nbsp;<a href='javascript:self.close();window.close();' onMouseOver="window.status=''; return true"  class="ml-btn-4" style="text-decoration: none;">�ݱ�</a> -->
        </td>
    </tr>
  
</table>
<%}%>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>