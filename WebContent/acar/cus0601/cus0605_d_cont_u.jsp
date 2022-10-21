<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.cus0601.*, acar.bill_mng.*, acar.pay_mng.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//네오엠 거래처 정보	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String ven_code = c61_soBn.getVen_code();
	
	Hashtable ven = new Hashtable();
	if(!ven_code.equals("")){
		ven = neoe_db.getVendorCase(ven_code);
	}
	
	//금융사리스트
	Vector bank_vt =  ps_db.getCodeList("0003");
	int bank_size = bank_vt.size();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function ServOffUp(){
	var fm = document.form1;
	if(fm.off_nm.value==""){ alert("상호를 입력해 주세요!"); fm.off_nm.focus(); return; }
	else if(fm.own_nm.value==""){ alert("대표자를 입력해 주세요!"); fm.own_nm.focus(); return; }
	else if(fm.est_st.value != "개인"){
		if(fm.ent_no.value==""){
			alert("사업자번호를 입력해 주세요!"); 
			//fm.ent_no.focus(); 
			return; 
		}
	}	
	else if(!isTel(fm.ent_no.value)){ alert("사업자번호를 다시 확인해 주세요!"); fm.ent_no.focus(); return; }

	if(!confirm('해당세차업체를 수정하시겠습니까?')){ return; }
	fm.action = "cus0605_d_cont_up.jsp";
	fm.target = "nodisplay";
	fm.submit();
}
	//네오엠 조회하기
	function ven_search(idx){
		var fm = document.form1;	
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+fm.ven_name.value, "VENDOR_LIST", "left=300, top=300, width=430, height=250, scrollbars=yes");		
	}		

//-->
</script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	function openDaumPostcode() {
		new daum.Postcode({
			oncomplete: function(data) {
				document.getElementById('t_zip').value = data.zonecode;
				document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
				
			}
		}).open();
	}
</script>		
</head>
<body leftmargin="10">

<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<input type="hidden" name="off_id" value="<%=off_id%>">
<input type="hidden" name="upd_id" value="<%=user_id%>">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="7" align=left>&nbsp;&nbsp;<input type="text" name="off_nm" value="<%=c61_soBn.getOff_nm()%>" size="67" class=text></td>
                </tr>
                <tr>
                	<td class=title>구분</td>
                	<td colspan="7">
                		&nbsp;<input type="radio" name="est_st" id="gubun-enterprise" value="법인사업자"<%if(c61_soBn.getEst_st().equals("법인사업자")){%>checked<%}%>><label for="gubun-enterprise">법인사업자</label>
                		&nbsp;<input type="radio" name="est_st" id="gubun-business" value="개인사업자"<%if(c61_soBn.getEst_st().equals("개인사업자")){%>checked<%}%>><label for="gubun-business">개인사업자</label>
                		&nbsp;<input type="radio" name="est_st" id="gubun-personal" value="개인"<%if(c61_soBn.getEst_st().equals("개인")){%>checked<%}%>><label for="gubun-personal">개인</label>
                	</td>
                </tr>
                <tr> 
                    <td class=title>대표자</td>
                    <td>&nbsp;&nbsp;<input type="text" name="own_nm" value="<%=c61_soBn.getOwn_nm()%>" size="22" class=text></td>
                  
                   <% if (c61_soBn.getEst_st().equals("개인")) { %>   
                	<td class=title>주민번호</td>
                    <td>&nbsp;&nbsp;<input type="text" name="ssn" value="<%=c61_soBn.getSsn()%>" readonly size="22" class=text></td>
                <% } else { %>          
                    <td class=title>사업자번호</td>
                    <td>&nbsp;&nbsp;<input type="text" name="ent_no" value="<%=c61_soBn.getEnt_no()%>" readonly size="22" class=text></td>
                <% }  %> 
                
                    <td class=title>업태</td>
                    <td>&nbsp;&nbsp;<input type="text" name="off_sta" value="<%=c61_soBn.getOff_sta()%>" size="22" class=text></td>
                    <td class=title>종목</td>
                    <td>&nbsp;&nbsp;<input type="text" name="off_item" value="<%=c61_soBn.getOff_item()%>" size="22" class=text></td>
                </tr>					
				<tr>
				  <td class=title>주소</td>
				  <td colspan=5> 
					&nbsp;&nbsp;<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=c61_soBn.getOff_post()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text"  name="t_addr" id="t_addr" size="71" value="<%=c61_soBn.getOff_addr()%>">
				  </td>
                    <td class=title>사무실전화</td>
                    <td>&nbsp;&nbsp;<input type="text" name="off_tel" value="<%=c61_soBn.getOff_tel()%>" size="22" class=text></td>
                </tr>
                <tr> 
                    <td class=title width=10%>계좌개설은행</td>
                    <td width=15%>&nbsp;&nbsp;
                    	<input type='hidden' name="bank" value="<%=c61_soBn.getBank_cd()%>">
                    	<select name='bank_cd'>
			                <option value=''>선택</option>
			                <%	for(int i = 0 ; i < bank_size ; i++){
														Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
														//신규인경우 미사용은행 제외
														if(String.valueOf(bank_ht.get("USE_YN")).equals("N"))	 continue;
											%>
			                <option value='<%= bank_ht.get("CODE")%>' <%if(String.valueOf(bank_ht.get("NM")).equals(c61_soBn.getBank())||String.valueOf(bank_ht.get("CODE")).equals(c61_soBn.getBank_cd()))	%>selected<%%>><%= bank_ht.get("NM")%></option>
			                <%	}%>
		                </select>
					</td>
                    <td class=title width=10%>계좌번호</td>
                    <td width=15%>&nbsp;&nbsp;<input type="text" name="acc_no" value="<%=c61_soBn.getAcc_no()%>" size="22" class=text></td>
                    <td class=title width=10%>예금주</td>
                    <td width=15%>&nbsp;&nbsp;<input type="text" name="acc_nm" value="<%=c61_soBn.getAcc_nm()%>" size="22" class=text></td>
                    <td class=title width=10%>팩스</td>
                    <td width=15%>&nbsp;&nbsp;<input type="text" name="off_fax" value="<%=c61_soBn.getOff_fax()%>" size="22" class=text></td>
                </tr>
                <tr> 
                    <td class=title>특이사항</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<input type="text" name="note" value="<%=c61_soBn.getNote()%>" size="157" class=text></td>
                </tr>
                <tr> 
                    <td class=title>네오엠거래처</td>
                    <td align=left colspan=7>&nbsp;&nbsp;<input type='text' name='ven_name' size='20' value='<%=ven.get("VEN_NAME")==null?c61_soBn.getOff_nm():ven.get("VEN_NAME")%>' class='text' style='IME-MODE: active'>
					  <a href="javascript:ven_search('')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a> 	
			  		  &nbsp;<img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <input type='text' name='ven_code' size='6' value='<%=ven_code%>' class='text'>
					</td>					
                </tr>				
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right">
	        <a href='javascript:ServOffUp()' onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
	        <a href='javascript:history.back()' onMouseOver="window.status=''; return true"><img src=../images/center/button_cancel.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
</table>
</form>
</body>
</html>