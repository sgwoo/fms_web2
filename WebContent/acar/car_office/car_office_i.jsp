<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.bill_mng.*, acar.user_mng.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	String car_off_id = "";					//������ID
    	String car_comp_id = "";				//ȸ���ID
    	String car_comp_nm = "";				//ȸ����̸�
    	String car_off_nm = "";					//�����Ҹ�
    	String car_off_st = "";					//�����ұ���
    	String owner_nm = "";					//������
    	String car_off_tel = "";				//�繫����ȭ
    	String car_off_fax = "";				//�ѽ�
    	String car_off_post = "";				//�����ȣ
    	String car_off_addr = "";				//�ּ�
    	String bank = "";						//���°�������
    	String bank_cd = "";						//���°�������
    	String acc_no = "";						//���¹�ȣ
    	String acc_nm = "";						//������
	String ven_code = "";					//�׿����ŷ�ó�ڵ�
	String manager = "";					//����
    	String agnt_nm = "";					//���ǹ���
    	String agnt_m_tel = "";					//���ǹ�����ȭ
    	String agnt_email = "";					//���ǹ��ڸ���
    	String cmd = "";
    	String enp_no = "";
    	String use_yn = "Y";
	int count = 0;
	
	
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert ����
	}
	if(request.getParameter("car_off_id")!=null)
	{
		car_off_id = request.getParameter("car_off_id");
		
		co_bean = cod.getCarOffBean(car_off_id);
		
		car_off_id 		= co_bean.getCar_off_id();
		car_comp_id 		= co_bean.getCar_comp_id();
		car_comp_nm 		= co_bean.getCar_comp_nm();
		car_off_nm 		= co_bean.getCar_off_nm();
		car_off_st 		= co_bean.getCar_off_st();
		owner_nm 		= co_bean.getOwner_nm();
		car_off_tel 		= co_bean.getCar_off_tel();
		car_off_fax 		= co_bean.getCar_off_fax();
		car_off_post 		= co_bean.getCar_off_post();
		car_off_addr 		= co_bean.getCar_off_addr();
		bank 			= co_bean.getBank();
		bank_cd 			= co_bean.getBank_cd();
		acc_no 			= co_bean.getAcc_no();
		acc_nm 			= co_bean.getAcc_nm();
		ven_code 		= co_bean.getVen_code();
		manager 		= co_bean.getManager();
		agnt_nm 		= co_bean.getAgnt_nm();
		agnt_m_tel 		= co_bean.getAgnt_m_tel();
		agnt_email 		= co_bean.getAgnt_email();
		enp_no	 		= co_bean.getEnp_no();
		use_yn	 		= co_bean.getUse_yn();
	}
	
	//������ ����Ʈ
	CarCompBean cc_r [] = cod.getCarCompAll();
	
	//���� ����Ʈ
	CodeBean cd_r [] = c_db.getCodeAllCms("0003");
	
	//�׿��� �ŷ�ó ����
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
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
	var theForm = document.form1;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.submit();
}
function CarOffUp()
{
	var theForm = document.form1;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('�����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "u";
	theForm.submit();
}

function NeomTradReg(){
	var theForm = document.form1;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('�׿����ŷ�ó�� ����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.cmd.value = "neom";
	theForm.submit();	
}

function CheckField()
{
	var theForm = document.form1;
	if(theForm.car_comp_id.value=="")
	{
		alert(" �����縦 �����Ͻʽÿ�.");
		theForm.car_comp_id.focus();
		return false;
	}
	if(theForm.car_off_nm.value=="")
	{
		alert("�����Ҹ� �Է��Ͻʽÿ�.");
		theForm.car_off_nm.focus();
		return false;
	}
	
	if(theForm.car_off_tel.value=="")
	{
		alert("�繫����ȭ��ȣ�� �Է��Ͻʽÿ�.");
		theForm.car_off_tel.focus();
		return false;
	}
	if(theForm.car_off_tel.value=="")
	{
		alert("�ѽ���ȣ���Է��Ͻʽÿ�.");
		theForm.car_off_tel.focus();
		return false;
	}
	return true;
}
function go_list(){
	location.href = "./car_office_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%= user_id %>&br_id=<%= br_id %>&gubun1=<%= gubun1 %>&gubun2=<%= gubun2 %>&gubun3=<%= gubun3 %>&gubun4=<%= gubun4 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>";
}

	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=400, scrollbars=yes");		
	}		

//�����Ұ��°���
function BankAccMng(){
	var theForm = document.form1;
	var car_off_id = theForm.car_off_id.value;
	var car_off_nm = theForm.car_off_nm.value;
	var car_comp_id = theForm.car_comp_id.value;
	var car_comp_nm = '<%=car_comp_nm%>';
	
	var SUBWIN="./car_office_bank.jsp?car_off_id="+car_off_id+"&car_off_nm="+car_off_nm+"&car_comp_id="+car_comp_id+"&car_comp_nm="+car_comp_nm;	
	window.open(SUBWIN, "OfficeBank", "left=100, top=100, width=820, height=500, scrollbars=no");
}	
//-->
</script>
</head>
<body>
<form action="./car_off_null_ui.jsp" name="form1" method="POST" >
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="use_yn" value="<%=use_yn%>">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ����������� > <span class=style5>�����ҵ��</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td align=right>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
		<%	if(car_off_id.equals("")){%>
            <a href="javascript:CarOffReg()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
		<%	}else{%>
			<a href="javascript:CarOffUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;
		<%	}%>
		<%}%>
			<a href="javascript:go_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>�������</td>
			    	<td width=20%>
			    		&nbsp;<select name="car_comp_id">
			    			<option value="">����</option>
<%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
        
        if(cc_bean.getNm().equals("������Ʈ")) continue;
%>
            				<option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
<%}%> 					</select>
						<script>
						document.form1.car_comp_id.value = '<%= car_comp_id %>';
						</script>
			    	</td>			    	
			    	<td width=12% class=title>����</td>
                    <td width=24%>
                    	&nbsp;<input type="radio" name="car_off_st" value="1" <% if(car_off_st.equals("1")||car_off_st.equals("")) out.println("checked"); %>>����&nbsp;
                    	<input type="radio" name="car_off_st" value="2" <% if(car_off_st.equals("2")) out.println("checked"); %>>�븮��&nbsp;
                    	
                 	</td>
                    <td class=title width=12%>��������</td>
                    <td width=20%>&nbsp;<input type="text" name="owner_nm" value="<%= owner_nm %>" size="22" class=text></td>                    
			    </tr>
                <tr>                    
                    <td class=title>�����Ҹ�</td>
			        <td>&nbsp;<input type="hidden" name="car_off_id" value="<%= car_off_id %>"><input type="text" name="car_off_nm" value="<%= car_off_nm %>" size="22" class=text></td>
			    	
                    <td class=title>��ȭ</td>
               		<td>&nbsp;<input type="text" name="car_off_tel" value="<%= car_off_tel %>" size="22" class=text></td>
               		<td class=title>FAX</td>
               		<td>&nbsp;<input type="text" name="car_off_fax" value="<%= car_off_fax %>" size="30" class=text></td>
                    
                </tr>
                <tr>
                    <td class=title>����ڵ�Ϲ�ȣ</td>
               	    <td>&nbsp;
               	      <input type='text' name='enp_no' value='<%=enp_no%>' size='15' class='text' maxlength='15'> ('-'����)							
               	    </td>
               		<td class=title>�׿����ŷ�ó</td>
               		<td colspan=3>&nbsp;<input type='text' name='ven_name' size='40' value='<%=ven.get("VEN_NAME")==null?car_off_nm:ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <input type='text' name='ven_code' size='7' value='<%=ven_code%>' class='text'>
			  		  <%if(nm_db.getWorkAuthUser("������",user_id) || ven_code.equals("")){ %>		
			  		  <br>
			  		  &nbsp;<input type="checkbox" name="ven_autoreg_yn" value="Y" checked> ������ ��Ͻ� �׿����ŷ�ó�� �ڵ� ����Ѵ�. (�����Ҹ�, ����ڵ�Ϲ�ȣ)
			  		  <%} %>
					</td>
                </tr>    
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
								function openDaumPostcode() {
									new daum.Postcode({
										oncomplete: function(data) {
											document.getElementById('car_off_post').value = data.zonecode;
											document.getElementById('car_off_addr').value = data.address;
											
										}
									}).open();
								}
				</script>							
                <tr>
                    <td class=title>�ּ�</td>
               		<td colspan=5>&nbsp;
					<input type="text" name='car_off_post' id="car_off_post" value="<%= car_off_post %>" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='car_off_addr' id="car_off_addr" value="<%= car_off_addr %>" size="100">

                </tr>                
                <tr>
                    <td class=title>�ŷ�����</td>
               		<td>
						&nbsp;
						<input type='hidden' name="bank" 			value="<%=bank%>">
						<select name="bank_cd">
							<option value="">����</option>
<%
    for(int i=0; i<cd_r.length; i++){
        cd_bean = cd_r[i];
        //�ű��ΰ�� �̻������ ����
				if(cd_bean.getUse_yn().equals("N"))	 continue;
%>
            				<option value="<%= cd_bean.getCode() %>" <%if(bank.equals(cd_bean.getNm())||bank_cd.equals(cd_bean.getCode())){%> selected <%}%>><%= cd_bean.getNm() %></option>
<%}%> 					</select>
               		</td>
               		<td class=title>���¹�ȣ</td>
               		<td>&nbsp;<input type="text" name="acc_no" value="<%= acc_no %>" size="22" class=text></td>
               		<td class=title>������</td>
               		<td>&nbsp;<input type="text" name="acc_nm" value="<%= acc_nm %>" size="30" class=text></td>
                </tr>
                <tr>                    
                    <td class=title>�����</td>
			        <td>&nbsp;<input type="text" name="manager" value="<%= manager %>" size="22" class=text></td>			    	
                    <td class=title>�����</td>
			        <td>&nbsp;<input type="text" name="agnt_nm" value="<%= agnt_nm %>" size="22" class=text></td>			    	
                    <td class=title>����ó</td>
               		<td>&nbsp;<input type="text" name="agnt_m_tel" value="<%= agnt_m_tel %>" size="22" class=text></td>                    
                </tr>				
                <tr>                    
                    <td class=title>��꼭���Ÿ���</td>
			        <td colspan='5'>&nbsp;<input type="text" name="agnt_email" value="<%= agnt_email %>" size="50" class=text></td>			    	
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
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>����ڵ�ϱ���</td>
		    <td width=20%>&nbsp;
		        <input type="radio" name="enp_reg_st" value="1" <%if(co_bean.getEnp_reg_st().equals("1")){%>checked<%}%>>����ڵ�ϻ����<br>&nbsp;
                    	<input type="radio" name="enp_reg_st" value="2" <%if(co_bean.getEnp_reg_st().equals("2")){%>checked<%}%>>����ڹ̵����
		    </td>			    	
		    <td width=12% class=title>�ŷ�����</td>
                    <td width=24%>&nbsp;
                    	<input type="radio" name="doc_st" value="1" <%if(co_bean.getDoc_st().equals("1")){%>checked<%}%>>��õ¡��&nbsp;
                    	<input type="radio" name="doc_st" value="2" <%if(co_bean.getDoc_st().equals("2")){%>checked<%}%>>���ݰ�꼭
                    </td>
                    <td class=title width=12%>����������</td>
                    <td width=20%>&nbsp;
                    	<input type="radio" name="est_day" value="C" <%if(co_bean.getEst_day().equals("")){%>checked<%}%>>����&nbsp;
                    	<input type="radio" name="est_day" value="D" <%if(!co_bean.getEst_day().equals("")){%>checked<%}%>>�ſ�
                    	<input type="text" name="est_day_sub" value="<%=co_bean.getEst_day()%>" size="2" class=text>��
                    	<input type="hidden" name="est_mon_st" value="<%=co_bean.getEst_mon_st()%>">
                    </td>
		</tr>                                            
                <tr>
               	    <td class=title>���ݰ�꼭<br>���뱸��</td>
               	    <td>&nbsp;
		        <input type="radio" name="req_st" value="1" <%if(co_bean.getReq_st().equals("1")){%>checked<%}%>>����&nbsp;
                    	<input type="radio" name="req_st" value="2" <%if(co_bean.getReq_st().equals("2")){%>checked<%}%>>����&nbsp;
                    	<input type="radio" name="req_st" value="3" <%if(co_bean.getReq_st().equals("3")){%>checked<%}%>>����
		    </td>			
               	    <td class=title>���ޱ���</td>
               	    <td colspan='3'>&nbsp;
		        <input type="radio" name="pay_st" value="1" <%if(co_bean.getPay_st().equals("1")){%>checked<%}%>>����&nbsp;
                    	<input type="radio" name="pay_st" value="2" <%if(co_bean.getPay_st().equals("2")){%>checked<%}%>>�����Ǻ�&nbsp;                    	
		    </td>			
                </tr>                     
            </table>
        </td>
    </tr>    
    
	<%if(!car_off_id.equals("")){%>
	<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{%>	
    <tr>
        <td colspan=2 align="right"><a href="javascript:BankAccMng()" onMouseOver="window.status=''; return true" title='�����Ұ��°���'><img src=/acar/images/center/button_acc_yus.gif  align="absmiddle" border="0"></a></td>
    </tr>
	<%	}%>	
	
	<%	if(!enp_no.equals("") && ven_code.equals("")){%>
	
	<%		if(nm_db.getWorkAuthUser("������",user_id) ){%>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td colspan=2 align="right">
          * �׿����ŷ�ó��ȸ�ؼ� <font color=red>������</font> ����ڵ�Ϲ�ȣ �Է��ϰ� 
            <a href="javascript:NeomTradReg()" onMouseOver="window.status=''; return true" title='�׿����ŷ�ó���'>[�׿����ŷ�ó���]</a>
            �� Ŭ���ϸ� �ŷ�ó����� �˴ϴ�.
          </td>
    </tr>
	<%		}%>	
	<%	}%>
	
	
    <tr>
    	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		<td width=20% class=title>����</td>
            		<td width=20% class=title>����</td>
            		<td width=30% class=title>�޴���</td>
            		<td width=30% class=title>�̸���</td>            		
            	</tr>
				<%	//�Ҽ� ������� ����Ʈ
					CarOffEmpBean coe_r [] = cod.getCarOffEmpAll(car_off_id);
					
    				for(int i=0; i<coe_r.length; i++){
        				coe_bean = coe_r[i];%>
            	<tr>
            		<td align=center><%= coe_bean.getEmp_nm() %></td>
            		<td align=center><%= coe_bean.getEmp_pos() %></td>
            		<td align=center><%= coe_bean.getEmp_m_tel() %></td>
            		<td align=center><%= coe_bean.getEmp_email() %></td>
            	</tr>
				<%	}%>
				<% if(coe_r.length == 0) { %>
            	<tr>
                	<td colspan=4 align=center height=25>��ϵ� ����Ÿ�� �����ϴ�.</td>
            	</tr>
				<%}%>
            </table>
        </td>
    </tr>
	<%}%>
</table>
</form>

</body>
</html>
