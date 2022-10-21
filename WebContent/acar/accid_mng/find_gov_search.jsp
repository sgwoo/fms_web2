<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	InsComBean[] banks = c_db.getInsComAll(t_wd);
	int bank_size = banks.length;
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//검색하기	
	function search(){
		var fm = document.form1;
		fm.action = "find_gov_search.jsp";		
		fm.submit();	
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	function search_ok(bank_id, bank_nm, zip, addr){
		var fm = opener.document.form1;
		<%if(mode.equals("8")){//대차료%>
		fm.ins_com_id.value = bank_id;
		fm.ins_com.value = bank_nm;
		<%}else{//운전자&보험사%>
		<%	if(idx.equals("")){%>
		fm.ot_ins.value = bank_nm;
		<%	}else{%>
		fm.ot_ins[<%=idx%>].value = bank_nm;
		<%	}%>
		<%}%>	
		window.close();
	}
	
	//우편번호 검색
	function search_zip(str){
		window.open("/fms2/lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}	
	
	//등록
	function InsComReg(){
		var fm = document.form1;
		fm.cmd.value = "i";		
		if(!CheckField()){	return;	}
		
		//중복체크
		<%	for(int i = 0 ; i < bank_size ; i++){
				InsComBean bank = banks[i]; %>		
				if('<%= bank.getIns_com_nm()%>'==fm.ins_com_nm.value || '<%= bank.getIns_com_f_nm()%>'==fm.ins_com_f_nm.value || '<%= bank.getAddr()%>'==fm.t_addr.value){
					alert('<%= bank.getIns_com_nm()%>' +  "" + fm.ins_com_nm.value);
					alert('<%= bank.getIns_com_f_nm()%>' +  "" + fm.ins_com_f_nm.value);
					alert('<%= bank.getAddr()%>' +  "" + fm.t_addr.value);
					alert('이미 등록된 보험사입니다.');
					return;
				}
		<%	}%>		
		
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.action = "/acar/con_ins/ins_com_sc_a.jsp"
		fm.target = "i_no"
		fm.submit();
	}	
	//입력값 null 체크
	function CheckField(){
		var fm = document.form1;
		if(fm.ins_com_nm.value==""){	alert("보험사명을 입력하십시요");	fm.ins_com_nm.focus();	return false;	}
		if(fm.ins_com_f_nm.value==""){	alert("보험사 풀네임을 입력하십시요");	fm.ins_com_f_nm.focus();	return false;	}
		if(fm.t_addr.value==""){	alert("주소를 입력하십시요");	fm.t_addr.focus();	return false;	}
		return true;
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="from_page" value="/acar/accid_mng/find_gov_search.jsp">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>보험사 조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>                   
                    <td width=270>보험사 : &nbsp;
                      <input type="text" name="t_wd" value='<%=t_wd%>' size="15" class="text">    
					  &nbsp;&nbsp;
					  <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>                  
                    </td>
                  
                </tr>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=5%>추가</td>
                    <td width=15% class='title'>보험사명</td>
                    <td width=20% class='title'>보험사 풀네임</td>					                    
                    <td width=60% class='title'>주소</td>         
                </tr>
                <tr> 
                    <td align="center">-</td>
                    <td align="center"><input type="text" name="ins_com_nm" size="15" style='IME-MODE: active' class=text></td>
                    <td align="center"><input type="text" name="ins_com_f_nm" size="30" style='IME-MODE: active' class=text></td>					
					
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>				
                    <td align="center">
					
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기">
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="45">
<!--					
					<input type='text' name="t_zip" value='' size="6" class='text' maxlength='7' readonly onClick="javascript:search_zip('')">
                        &nbsp;<input type='text' name="t_addr" value='' size="50" class='text' maxlength='100' style='IME-MODE: active'>
-->						
					</td>         
                </tr>				
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right"><a href="javascript:InsComReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a></td>
    </tr>
	<tr><td class=h></td></tr>	
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=5%>연번</td>
                    <td width=15% class='title'>보험사명</td>
                    <td width=20% class='title'>보험사 풀네임</td>		
                    <td width=10% class='title'>긴급출동번호</td>
                    <td width=10% class='title'>사고접수번호</td>			
                    <td width=40% class='title'>주소</td>         
                </tr>
          <%for(int i = 0 ; i < bank_size ; i++){
				InsComBean bank = banks[i]; %>				  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><a href="javascript:search_ok('<%= bank.getIns_com_id()%>','<%= bank.getIns_com_nm()%>','<%= bank.getZip()%>','<%= bank.getAddr()%>')" onMouseOver="window.status=''; return true"><%= bank.getIns_com_nm()%></a></td>
                    <td><%= bank.getIns_com_f_nm()%></td>					
                    <td><%= bank.getAgnt_imgn_tel()%></td>
                    <td><%= bank.getAcc_tel()%></td>
                    <td><%= bank.getAddr()%></td>
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
