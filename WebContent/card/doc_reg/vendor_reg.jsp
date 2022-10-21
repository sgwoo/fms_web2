<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
			
	CommonDataBase c_db = CommonDataBase.getInstance();

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String cust_code = neoe_db.getCustCodeNext(); //-> neoe_db ��ȯ	
	
	Hashtable br = c_db.getBranch("S1");
	
	t_wd = AddUtil.replace(t_wd, "-" , "");		
	
	if ( !Util.CheckNumber(t_wd) ) t_wd="";		 //�˻�� ������ ��츸 �ش� 
		
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
	
	//���
	function Save(){
		var fm = document.form1;
		
//		if(fm.cust_code.value == ''){		alert('�ŷ�ó�ڵ带 �Է��Ͻʽÿ�.'); 			return; }
//		if(fm.cust_code_yn.value == 'N'){	alert('�ŷ�ó�ڵ� �ߺ�üũ�� �Ͻʽÿ�.'); 		return; }
		if(fm.cust_name.value == ''){		alert('�ŷ�ó���� �Է��Ͻʽÿ�.'); 				return; }
		if(fm.dname.value == ''){			alert('��ǥ�ڸ��� �Է��Ͻʽÿ�.'); 				return; }		
		
		if(!chk_vend(fm.s_idno)){ 	alert('����ڹ�ȣ�� Ȯ���Ͻʽÿ�.'); 			return; }		
						
		if(fm.s_idno.value != '' && fm.s_idno_yn.value == 'N'){		alert('����ڵ�Ϲ�ȣ �ߺ�üũ�� �Ͻʽÿ�.'); 	return; }

		if(fm.t_zip.value == ''){			alert('�����ȣ�� �Է��Ͻʽÿ�.'); 				return; }		
		if(fm.t_addr.value == ''){			alert('�ּҸ� �Է��Ͻʽÿ�.'); 					return; }
		
		if(fm.ven_st[0].checked == false && fm.ven_st[1].checked == false && fm.ven_st[2].checked == false && fm.ven_st[3].checked == false){ alert('���������� �����Ͻʽÿ�.'); return;}
		//alert(fm.ven_st[0].value);
		
		if((fm.ven_st[1].checked == true || fm.ven_st[2].checked == true || fm.ven_st[3].checked == true)&&fm.nts_yn.value== ''){		
		
		//if(fm.nts_yn.value== ''){		
		
		alert('����û ����� �������� ��ȸ�� �Ͻʽÿ�.'); return; 
		
		}
		
			
		if(confirm('����Ͻðڽ��ϱ�?')){			
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");					
			
			fm.cust_name.value 	= charRound(fm.cust_name.value ,30);
			fm.dname.value 		= charRound(fm.dname.value	   ,30);
			fm.t_addr.value 	= charRound(fm.t_addr.value	   ,70);			
			
			fm.action='vendor_reg_a.jsp';		
			fm.target='i_no';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}
	}

	//�����ȣ �˻�
	function search_zip(str){
		window.open("/acar/car_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=400, width=400, scrollbars=yes");
	}
	
	//�׿�����ȸ
	function Cust_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		//if(s_kd == 'cust_code')	fm.t_wd.value = fm.cust_code.value;
		//if(s_kd == 's_idno')	
		fm.t_wd.value = fm.s_idno.value.replace(/-/g,"");
		window.open("about:blank",'Cust_search','scrollbars=yes,status=yes,resizable=yes,width=650,height=400,left=400,top=400');		
		fm.action = "cust_sidno_search.jsp";
		fm.target = "Cust_search";
		fm.submit();		
	}
	function Cust_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Cust_search(s_kd);
	}	
	
	// ����ڵ�Ϲ�ȣ üũ
	function check_busino() {
		var fm = document.form1;
		var vencod = fm.s_idno.value;
        var sum = 0;
        var getlist =new Array(10);
        var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
        for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
        for(var i=0; i<9; i++) 	{ sum += getlist[i]*chkvalue[i]; }
        sum = sum + parseInt((getlist[8]*5)/10);
        sidliy = sum % 10;
        sidchk = 0;
        if(sidliy != 0) { sidchk = 10 - sidliy; }
        else { sidchk = 0; }
        if(sidchk != getlist[9]) { return false; }
        return true;
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
<!--  
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

<script language="Javascript">
<!-- 
	// ����ڵ�Ϲ�ȣ �̻�üũ
	function chk_vend(a) {
    	var strNumb = a.value.replace(/-/g,"");
		//alert(strNumb);
    	if (strNumb.length != 10) {
        	alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
        	return false;
    	}
    
        sumMod  =   0;
        sumMod  +=  parseInt(strNumb.substring(0,1));
        sumMod  +=  parseInt(strNumb.substring(1,2)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(2,3)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(3,4)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(4,5)) * 3 % 10;
        sumMod  +=  parseInt(strNumb.substring(5,6)) * 7 % 10;
        sumMod  +=  parseInt(strNumb.substring(6,7)) * 1 % 10;
        sumMod  +=  parseInt(strNumb.substring(7,8)) * 3 % 10;
        sumMod  +=  Math.floor(parseInt(strNumb.substring(8,9)) * 5 / 10);
        sumMod  +=  parseInt(strNumb.substring(8,9)) * 5 % 10;
        sumMod  +=  parseInt(strNumb.substring(9,10));
    
    	if (sumMod % 10  !=  0) {
        	alert("����ڵ�Ϲ�ȣ�� �߸��Ǿ����ϴ�.");
			document.form1.s_idno.value='';
        	return false;
    	}
		
//        alert("��ȿ�� ����� ��Ϲ�ȣ �Դϴ�. �ߺ�üũ�� ���ּ���.");
    	return true;
	}
//-->
</script>
<script> 
<!--
function OnCheckBiz_no(oTa) { 
	var oForm = oTa.form ; 
	var sMsg = oTa.value ; 
	var onlynum = "" ; 
		onlynum = RemoveDash2(sMsg); 
	if(event.keyCode != 8 ) { 
	if (GetMsgLen(onlynum) <= 2) oTa.value = onlynum ; 
	if (GetMsgLen(onlynum) == 3) oTa.value = onlynum + "-"; 
	if (GetMsgLen(onlynum) == 5) oTa.value = onlynum.substring(0,3) + "-" + onlynum.substring(3,5) + "-" + onlynum.substring(6,7); 
	} 
} 

function RemoveDash2(sNo) { 
	var reNo = "" 
		for(var i=0; i<sNo.length; i++) { 
		if ( sNo.charAt(i) != "-" ) { 
			reNo += sNo.charAt(i) 
		} 
	} 
	return reNo 
} 

function GetMsgLen(sMsg) { // 0-127 1byte, 128~ 2byte 
	var count = 0 
		for(var i=0; i<sMsg.length; i++) { 
		if ( sMsg.charCodeAt(i) > 127 ) { 
			count += 2 
		} 
	else { 
	count++ 
	} 
	} 
	return count 
} 
//-->
</script> 
</head>
<body topmargin="10" onLoad="javascript:document.form1.cust_name.focus();">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<!--<input type='hidden' name='cust_code_yn' <%if(cust_code.equals("")){%>value='N'<%}else{%>value='Y'<%}%>>-->
<input type='hidden' name='s_idno_yn' value='N'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<input type='hidden' name='nts_yn' value=''>

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>�ŷ�ó ���</span></span></td>
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
		  <!--
            <tr>
              <td width='15%' class='title'>�ŷ�ó�ڵ�</td>
              <td>&nbsp;
                  <input name="cust_code" type="text" class="text" value="<%=cust_code%>" size="15" onKeyDown="javasript:Cust_enter('cust_code')"> 
				  
			<a href="javascript:Cust_search('cust_code');"><img src=/acar/images/center/button_in_check_jb.gif border=0 align=absmiddle></a> 
				  (6�ڸ�, 100000)
              </td>
            </tr>
			-->
          <tr>
            <td class='title'>�ŷ�ó��</td>
            <td>&nbsp; 
			<input name="cust_name" type="text" class="text" value="" size="59" style='IME-MODE: active'>(�ѱ�15���̳�)</td>
          </tr>			
          <tr>
            <td class='title'>��ǥ�ڸ�</td>
            <td>&nbsp;
			<input name="dname" type="text" class="text" value="" size="20"></td>
          </tr>
          <tr>
            <td class='title'>����ڹ�ȣ</td>
            <td>&nbsp;
			<input name="s_idno" type="text" class="text" value="<%=t_wd%>" size="20" maxlength="12" onKeyDown="javasript:Cust_enter('s_idno');" onfocus="OnCheckBiz_no(this)" onKeyup="OnCheckBiz_no(this)" ><!-- OnBlur="chk_vend(this);"-->
			<a href="javascript:Cust_search('s_idno');"><img src=/acar/images/center/button_in_check_jb.gif border=0 align=absmiddle></a> 
			('-' �� �ڵ����� �Էµ˴ϴ�.)
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
				<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
				<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
				&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="95" value="">
			  </td>
			</tr>		  		  		  
          <tr>
            <td class='title'>��������</td>
            <td>&nbsp;
				<input type="radio" name="ven_st" value="1" onclick="div_OnOff(this.value,'btn');">�Ϲݰ���
			&nbsp;<input type="radio" name="ven_st" value="2" onclick="div_OnOff(this.value,'btn');">���̰���
			&nbsp;<input type="radio" name="ven_st" value="3" onclick="div_OnOff(this.value,'btn');">�鼼
			&nbsp;<input type="radio" name="ven_st" value="4" onclick="div_OnOff(this.value,'btn');">�񿵸�����(�������/��ü)
			&nbsp;
			<a href="javascript:search_nts();">  <img src=/acar/images/center/button_in_search_gsc.gif align=absmiddle border=0 id="btn" style="display: visibility:hidden;"> 			</a>
	    </td>
          </tr>		  		  
          </table></td>
  </tr>
     
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")||ck_acar_id.equals("000223")||ck_acar_id.equals("000263")) {%>
      	<a id="submitLink" href="javascript:Save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> 
      	&nbsp;
      	<%}%>
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
