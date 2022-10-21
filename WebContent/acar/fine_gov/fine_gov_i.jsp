<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "03", "06", "03");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");	
	FineGovBn = FineDocDb.getFineGov(gov_id);
	
	if(FineGovBn.getVen_name().equals("") && !FineGovBn.getGov_nm().equals("")) FineGovBn.setVen_name(FineGovBn.getGov_nm());
	
	CodeBean[] codes = c_db.getCodeAll2("0010", "Y");
	int codes_size = codes.length;	
	
	//�׿��� �ŷ�ó ����	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = FineGovBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//û����� ����
	function fine_gov_search(){
		var fm = document.form1;	
		window.open("fine_gov_search.jsp?t_wd="+fm.gov_nm.value, "SEARCH_FINE", "left=280, top=280, width=550, height=450, scrollbars=yes");
	}

	function search_zip(){
		window.open("../car_rent/zip_s.jsp", "�����ȣ�˻�", "left=100, height=200, height=500, width=400, scrollbars=yes");
	}
	
	//���||����
	function reg(){
		var fm = document.form1;
		if(fm.gov_st.value == '')	{ alert('��������� �����Ͻʽÿ�.'); return; }
		if(fm.gov_nm.value == '')	{ alert('������� �Է��Ͻʽÿ�.'); return; }
		if(fm.gov_id.value == '' && fm.chk.value == '')		
									{ alert('�ߺ�Ȯ���� �Ͻʽÿ�.'); return; }		
		if(!confirm('ó���Ͻðڽ��ϱ�?')){	return;	}		
		fm.target = "i_no";
//		fm.target ="REG_FINE_GOV";
		fm.action = "fine_gov_i_a.jsp";
		fm.submit();
	}
	
	//�׿��� ��ȸ�ϱ�
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}		
			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.gov_nm.focus();">
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='gov_id' value='<%=gov_id%>'>
<input type='hidden' name='chk' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������ > <span class=style5>���·�û�����</span></span></td>
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
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            	<colgroup>
            		<col width='20%'>
            		<col width='*'>
            	</colgroup>
                <tr> 
                    <td class='title'>�������</td>
                    <td> 
        			  &nbsp;<select name="gov_st">
        			     <option value=''>����</option>
                        <%  if(codes_size > 0){
        						for(int i = 0 ; i < codes_size ; i++){
        							CodeBean code = codes[i];%>
                         <option value='<%= code.getNm_cd()%>' <%if(FineGovBn.getGov_st().equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
                         <%		}
        					}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�����</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_nm" value="<%=FineGovBn.getGov_nm()%>" size="50" class="text" style='IME-MODE: active'>
        			  <%if(gov_id.equals("")){%>
        			  <a href="javascript:fine_gov_search();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_jb.gif" n align="absmiddle" border="0"></a>
        			  <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����24 �����</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_nm2" value="<%=FineGovBn.getGov_nm2()%>" size="60" class="text" >
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����μ��ڵ�</td>
                    <td> 
                      &nbsp;<input type="text" name="gov_dept_code" value="<%=FineGovBn.getGov_dept_code()%>" size="30" class="text" > (������)
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td> 
                      &nbsp;<input type="text" name="mng_dept" value="<%=FineGovBn.getMng_dept()%>" size="30" class="text">
                    </td>
                </tr>
                <tr>
                    <td class='title'>����ڸ�</td>
                    <td>&nbsp;<input type="text" name="mng_nm" value="<%=FineGovBn.getMng_nm()%>" size="30" class="text"></td>
                </tr>
                <tr>
                    <td class='title'>���������</td>
                    <td>&nbsp;<input type="text" name="mng_pos" value="<%=FineGovBn.getMng_pos()%>" size="30" class="text"></td>
                </tr>
                <tr> 
                    <td class='title'>����ó</td>
                    <td> 
                        &nbsp;<input type="text" name="tel" value="<%=FineGovBn.getTel()%>" size="30" class="text">
                    </td>
                </tr>
                <tr> 
                    <td class='title'>�ѽ�</td>
                    <td> 
                      &nbsp;<input type="text" name="fax" value="<%=FineGovBn.getFax()%>" size="30" class="text">
                    </td>
                </tr>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.

								// ���θ� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
								// �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
								var fullRoadAddr = data.roadAddress; // ���θ� �ּ� ����
								var extraRoadAddr = ''; // ���θ� ������ �ּ� ����

								// ���������� ���� ��� �߰��Ѵ�. (�������� ����)
								// �������� ��� ������ ���ڰ� "��/��/��"�� ������.
								if(data.bname !== '' && /[��|��|��]$/g.test(data.bname)){
									extraRoadAddr += data.bname;
								}
								// �ǹ����� �ְ�, ���������� ��� �߰��Ѵ�.
								if(data.buildingName !== '' && data.apartment === 'Y'){
								   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
								}
								// ���θ�, ���� ������ �ּҰ� ���� ���, ��ȣ���� �߰��� ���� ���ڿ��� �����.
								if(extraRoadAddr !== ''){
									extraRoadAddr = ' (' + extraRoadAddr + ')';
								}
								// ���θ�, ���� �ּ��� ������ ���� �ش� ������ �ּҸ� �߰��Ѵ�.
								if(fullRoadAddr !== ''){
									fullRoadAddr += extraRoadAddr;
								}
								
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = fullRoadAddr;
								
								// ����ڰ� '���� ����'�� Ŭ���� ���, ���� �ּҶ�� ǥ�ø� ���ش�.
								if(data.autoRoadAddress) {
									//����Ǵ� ���θ� �ּҿ� ������ �ּҸ� �߰��Ѵ�.
									var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
									document.getElementById('t_addr').innerHTML = '(���� ���θ� �ּ� : ' + expRoadAddr + ')';

								} else if(data.autoJibunAddress) {
									var expJibunAddr = data.autoJibunAddress;
									document.getElementById('t_addr').innerHTML = '(���� ���� �ּ� : ' + expJibunAddr + ')';

								} else {
									document.getElementById('t_addr').innerHTML = '';
								}
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>�ּ�</td>
				  <td>&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=FineGovBn.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="<%=FineGovBn.getAddr()%>">
				  </td>
				</tr>
				<tr> 
                    <td class=title>�׿����ŷ�ó</td>
                    <td>
					  &nbsp;<input type='text' name='ven_name' size='30' value='<%=ven.get("VEN_NAME")==null?FineGovBn.getVen_name():ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <input type='text' name='ven_code' size='6' value='<%=ven_code%>' class='text'>
					</td>					
                </tr>
				<tr> 
                    <td class='title'>�������</td>
                    <td> 
       			  &nbsp;<select name="use_yn">
						<option value='Y' <%if(FineGovBn.getUse_yn().equals("Y")){%>selected<%}%>>���</option>
						<option value='N' <%if(FineGovBn.getUse_yn().equals("N")){%>selected<%}%>>������</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
          <td align='right'>
    	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    	  <a href="javascript:reg();"><img src="/acar/images/center/<%if(gov_id.equals("")) {%>button_reg<%}else{%>button_modify<%}%>.gif"  align="absmiddle" border="0"></a>
    	  <%}%>
    	  &nbsp;<a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif" n align="absmiddle" border="0"></a>
    	  </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>