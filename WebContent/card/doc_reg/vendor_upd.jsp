<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String ven_name 	= request.getParameter("ven_name")==null?"":request.getParameter("ven_name");
	String ven_nm_cd 	= request.getParameter("ven_nm_cd")==null?"":request.getParameter("ven_nm_cd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	Hashtable ven = neoe_db.getTradeCase(ven_code);//-> neoe_db ��ȯ
	
	Hashtable ven_his = neoe_db.getTradeHisCase(ven_code);  //-> neoe_db ��ȯ���� �״�� ��	
	
	String ven_st = String.valueOf(ven_his.get("VEN_ST"));
	
	if(ven_st.equals("null") || ven_st.equals("")){
		ven_st = c_db.getCardDocVenSt(ven_code);
	}
	
	Hashtable br = c_db.getBranch("S1");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//���ڿ� �������� �ڸ���
	function charRound(f, b_len){	
	
		var max_len = f.length;
		var ff = '';
		var len = 0;
		
		for(k=0;k<max_len;k++) {
		
			if(len >= b_len) break; //�������̺��� ��� ����
			
			t = f.charAt(k);			
			ff += t;
			
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}	
		return ff;			
	}
	//����
	function Save(){
		var fm = document.form1;
//		if(fm.cust_code.value == ''){		alert('�ŷ�ó�ڵ带 �Է��Ͻʽÿ�.'); 			return; }
		if(fm.cust_name.value == ''){		alert('�ŷ�ó���� �Է��Ͻʽÿ�.'); 				return; }
		if(fm.dname.value == ''){		alert('��ǥ�ڸ��� �Է��Ͻʽÿ�.'); 				return; }		
//		if(fm.s_idno.value == ''){		alert('����ڵ�Ϲ�ȣ�� �Է��Ͻʽÿ�.'); 		return; }
		if(fm.t_zip.value == ''){		alert('�����ȣ�� �Է��Ͻʽÿ�.'); 				return; }		
		if(fm.t_addr.value == ''){		alert('�ּҸ� �Է��Ͻʽÿ�.'); 					return; }
		
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false && fm.ven_st[2].checked == false && fm.ven_st[3].checked == false){ alert('���������� �����Ͻʽÿ�.'); return;}
		
		//if(fm.nts_yn.value== ''){		alert('����û ����� �������� ��ȸ�� �Ͻʽÿ�.'); return; }
		
		if((fm.ven_st[1].checked == true || fm.ven_st[2].checked == true || fm.ven_st[3].checked == true)&&fm.nts_yn.value== ''){		
		
			alert('����û ����� �������� ��ȸ�� �Ͻʽÿ�.'); return; 
		
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){					
		
			fm.cust_name.value 	= charRound(fm.cust_name.value 	,30);
			fm.dname.value 		= charRound(fm.dname.value	   	,30);
			fm.t_addr.value 	= charRound(fm.t_addr.value	   	,70);						
			fm.dc_rmk.value 	= charRound(fm.dc_rmk.value 	,80);			
			
			fm.action='vendor_upd_a.jsp';					
			fm.target='i_no';

			fm.submit();
		}
	}


	//�׿�����ȸ
	function Cust_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cust_code')	fm.t_wd.value = fm.cust_code.value;
		if(s_kd == 's_idno')	fm.t_wd.value = fm.s_idno.value;
		window.open("about:blank",'Cust_search','scrollbars=no,status=no,resizable=yes,width=350,height=200,left=400,top=400');		
		fm.action = "cust_search.jsp";
		fm.target = "Cust_search";
		fm.submit();		
	}
	function Cust_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Cust_search(s_kd);
	}	

	//����û����������ȸ
	function search_nts(){
		var fm = document.form1;
		fm.nts_yn.value='Y';
		window.open("https://teht.hometax.go.kr/websquare/websquare.html?w2xPath=/ui/ab/a/a/UTEABAAA13.xml", "NTS_SEARCH", "left=0, top=0, height=<%=s_height%>, width=<%=s_width%>, scrollbars=yes");
	}
//-->
</script>
<script language="JavaScript">
<!--  //����������ȸ ��ư ���̰�/�����
function div_OnOff(v,id){
 // ���� ��ư value �� ���� ��
 if(v == "1"){
  document.getElementById(id).style.display = "none"; // ����
 }else{
  document.getElementById(id).style.display = ""; // ������
 }
}
    -->
</script>
</head>
<body topmargin="10" onLoad="javascript:document.form1.cust_name.focus();">
<form action="./" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='nts_yn' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>�ŷ�ó ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='15%' class='title'>�ŷ�ó�ڵ�</td>
              <td>&nbsp;
                  <%=ven_code%>
				  <input type='hidden' name='cust_code' value='<%=ven_code%>'>
              </td>
            </tr>
          <tr>
            <td class='title'>�ŷ�ó��</td>
            <td>&nbsp; 
			<input name="cust_name" type="text" class="text" value="<%=ven.get("CUST_NAME")%>" size="59" style='IME-MODE: active'>(�ѱ�15���̳�)</td>
          </tr>			
          <tr>
            <td class='title'>��ǥ�ڸ�</td>
            <td>&nbsp;
			<input name="dname" type="text" class="text" value="<%=ven.get("DNAME")%>" size="15"></td>
          </tr>
          <tr>
            <td class='title'>����ڹ�ȣ</td>
            <td>&nbsp;
			<%=ven.get("S_IDNO")%>
			<input type='hidden' name='s_idno' value='<%=ven.get("S_IDNO")%>'>
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
			  <td colspan=7>&nbsp;
				<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=ven.get("NO_POST1")%>">
				<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
				&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="95" value="<%=ven.get("S_ADDRESS")%>">
			  </td>
			</tr>		  
          
          <tr>
            <td class='title'>��������</td>
            <td>&nbsp;
			<input type="radio" name="ven_st" value="1" <%if(ven_st.equals("1"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">�Ϲݰ���
					&nbsp;<input type="radio" name="ven_st" value="2" <%if(ven_st.equals("2"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">���̰���
					&nbsp;<input type="radio" name="ven_st" value="3" <%if(ven_st.equals("3"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">�鼼
					&nbsp;<input type="radio" name="ven_st" value="4" <%if(ven_st.equals("4"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">�񿵸�����(�������/��ü)
					&nbsp;<input type="radio" name="ven_st" value="0" <%if(ven_st.equals("0"))%>checked<%%>  onclick="div_OnOff(this.value,'btn');">����
					&nbsp;
					<a href="javascript:search_nts();">
			  		  <img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0 id="btn" style="display: visibility:hidden;">
					</a>											
					</td>
          </tr>		  		  		    		  
          <tr>
            <td class='title'>���Ῡ��</td>
            <td>&nbsp;
			  <input type="checkbox" name="md_gubun" value="N" <%if(String.valueOf(ven.get("MD_GUBUN")).equals("N"))%>checked<%%>> ����
			</td>
          </tr>		  		  
          <tr>
            <td class='title'>���</td>
            <td>&nbsp;
			<input type="text" name="dc_rmk" class=text value="<%=ven.get("DC_RMK")%>" size="50" maxlength='100'>
			</td>
          </tr>				    		  
          </table></td>
  </tr>
     
    <tr> 
      <td align="right">
        <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
      	<a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a> 
      	&nbsp;
      	<%//}%>
	  <a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> </td>
    </tr>  
    <tr> 
      <td>
      	* ����û ����� �������� ��ȸ�� �� �ϼž� �մϴ�. ������ ������ �̷����� �����˴ϴ�.
      </td>
    </tr>          
    <tr> 
      <td>
      	* ��� ����ڵ������ȣ : <%=AddUtil.ChangeEnt_no(String.valueOf(br.get("BR_ENT_NO")))%>
      </td>
    </tr>          
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
