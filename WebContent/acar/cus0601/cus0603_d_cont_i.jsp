<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_office.*, acar.pay_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll();
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
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
function ServOffReg(){
	var fm = document.form1;
	if(fm.off_nm.value==""){ alert("상호를 입력해 주세요!"); fm.off_nm.focus(); return; }
	else if(fm.own_nm.value==""){ alert("대표자를 입력해 주세요!"); fm.own_nm.focus(); return; }
	else if(fm.ent_no.value==""){ alert("사업자번호를 입력해 주세요!"); fm.ent_no.focus(); return; }
	else if(!isTel(fm.ent_no.value)){ alert("사업자번호를 다시 확인해 주세요!"); fm.ent_no.focus(); return; }

	if(!confirm('해당납품업체를 등록하시겠습니까?')){ return; }
	fm.action = "cus0603_d_cont_in.jsp";
	fm.target = "i_no";
	fm.submit();
}
function search_zip()
{
	window.open("/acar/car_rent/zip_s.jsp", "우편번호검색", "left=200, top=100, height=500, width=400, scrollbars=yes");
}

//사업자등록번호 체크
function CheckBizNo(a) {

 	var strNumb = a.value;
    if (strNumb.length != 10) {
        alert("사업자등록번호가 잘못되었습니다.");
        return;
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
			alert("사업자등록번호가 잘못되었습니다.");
			return;
		}
			alert("올바른 사업자 등록번호 입니다.");
			return;
}
//-->
</script>
</head>
<body leftmargin="10">

<table border=0 cellspacing=0 cellpadding=0 width="100%">
<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="reg_id" value="<%=user_id%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>상호</td>
                    <td colspan="7" align=left>&nbsp;<input type="text" name="off_nm" value="" size="80" class=text></td>
                </tr>
                <tr> 
                    <td class=title width=12%>대표자</td>
                    <td width=13%>&nbsp;<input type="text" name="own_nm" value="" size="14" class=text></td>
                    <td class=title width=12%>사업자번호</td>
                    <td width=13%>&nbsp;<input type="text" name="ent_no" value="" size="14" class=text OnBlur="CheckBizNo(this);"></td>
                    <td class=title width=12%>업태</td>
                    <td width=13%>&nbsp;<input type="text" name="off_sta" value="" size="14" class=text></td>
                    <td class=title width=12%>종목</td>
                    <td width=13%>&nbsp;<input type="text" name="off_item" value="" size="14" class=text></td>
                </tr>
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
				<tr>
				  <td class=title>주소</td>
				  <td colspan=5> 
					<input type="text"  name="t_zip" id="t_zip" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text"  name="t_addr"  id="t_addr" size="71">
				  </td>
                    <td class=title>사무실전화</td>
                    <td>&nbsp;<input type="text" name="off_tel" value="" size="14" class=text></td>
                </tr>
                <tr> 
                    <td class=title>계좌개설은행</td>
                    <td>&nbsp;
                    	<input type='hidden' name="bank" 			value="">
                    	<select name='bank_cd'>
                <option value=''>선택</option>
                <%	for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank_ht = (Hashtable)bank_vt.elementAt(i);
											//신규인경우 미사용은행 제외
											if(String.valueOf(bank_ht.get("USE_YN")).equals("N"))	 continue;
								%>
                <option value='<%= bank_ht.get("CODE")%>' ><%= bank_ht.get("NM")%></option>
                <%	}%>
              </select></td>
                    <td class=title>계좌번호</td>
                    <td>&nbsp;<input type="text" name="acc_no" value="" size="14" class=text></td>
                    <td class=title>예금주</td>
                    <td >&nbsp;<input type="text" name="acc_nm" value="" size="14" class=text></td>
                    <td class=title>팩스</td>
                    <td>&nbsp;<input type="text" name="off_fax" value="" size="14" class=text></td>
                </tr>
                <tr> 
                    <td class=title>특이사항</td>
                    <td align=left colspan=7>&nbsp;<input type="text" name="note" value="" size="114" class=text></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr> 
        <td align="right"><a href='javascript:ServOffReg()' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
        <a href='javascript:self.close();window.close();' onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>