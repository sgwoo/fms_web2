<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String car_off_id = "";					//영업소ID
    String car_comp_id = "";					//회사명ID
    String car_comp_nm = "";					//회사명이름
    String car_off_nm = "";					//영업소명
    String car_off_st = "";					//영업소구분
    String owner_nm = "";					//지점장
    String car_off_tel = "";					//사무실전화
    String car_off_fax = "";					//팩스
    String car_off_post = "";				//우편번호
    String car_off_addr = "";				//주소
    String bank = "";						//계좌개설은행
    String acc_no = "";						//계좌번호
    String acc_nm = "";						//예금주
    String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert 구분
	}
	if(request.getParameter("car_off_id")!=null)
	{
		car_off_id = request.getParameter("car_off_id");
		
		co_bean = cod.getCarOffBean(car_off_id);
		
		car_off_id = co_bean.getCar_off_id();
		car_comp_id = co_bean.getCar_comp_id();
		car_comp_nm = co_bean.getCar_comp_nm();
		car_off_nm = co_bean.getCar_off_nm();
		car_off_st = co_bean.getCar_off_st();
		owner_nm = co_bean.getOwner_nm();
		car_off_tel = co_bean.getCar_off_tel();
		car_off_fax = co_bean.getCar_off_fax();
		car_off_post = co_bean.getCar_off_post();
		car_off_addr = co_bean.getCar_off_addr();
		bank = co_bean.getBank();
		acc_no = co_bean.getAcc_no();
		acc_nm = co_bean.getAcc_nm();
	}
	
	CarCompBean cc_r [] = cod.getCarCompAll();
	CodeBean cd_r [] = c_db.getCodeAll("0003");	//은행명을 가져온다.
	CarOffEmpBean coe_r [] = cod.getCarOffEmpAll(car_off_id);

	Vector mngs = c_db.getUserList("", "", "MNG_EMP"); //영업팀 리스트
	Vector buss = c_db.getUserList("", "", "BUS_EMP"); //고객지원팀 리스트
	Vector gens = c_db.getUserList("", "", "GEN_EMP"); //총무팀 리스트
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="javascript">
<!--
function search_zip(){
	window.open("./zip_s.jsp", "우편번호검색", "left=100, top=100, height=500, width=400, scrollbars=yes");
}
function CarOffReg(){
	var theForm = document.CarOffForm;
	if(!CheckField())	{		return;	}
	if(!confirm('등록하시겠습니까?')){		return;	}
	theForm.cmd.value = "i";
	theForm.target = "nodisplay"
	theForm.submit();
}
function CarOffUp(){
	var theForm = document.CarOffForm;
	if(!CheckField()){		return;	}
	if(!confirm('수정하시겠습니까?')){		return;	}
	theForm.cmd.value = "u";
	theForm.target = "nodisplay"
	theForm.submit();
}

function CheckField(){
	var theForm = document.CarOffForm;
	if(theForm.car_comp_id.value==""){		alert("제조사를 선택하십시요.");		theForm.car_comp_id.focus();		return false;	}
	if(theForm.car_off_nm.value==""){		alert("영업소명를 입력하십시요.");		theForm.car_off_nm.focus();		return false;	}
	if(theForm.owner_nm.value=="")	{		alert("지점장/소장님을 입력하십시요.");	theForm.owner_nm.focus();		return false;	}
	if(theForm.car_off_tel.value==""){		alert("사무실전화번호를 입력하십시요.");theForm.car_off_tel.focus();	return false;	}
	if(theForm.car_off_tel.value==""){		alert("팩스번호를입력하십시요.");		theForm.car_off_tel.focus();	return false;	}
	return true;
}

-->
</script>
<title>FMS</title>
</head>

<body>
<form action="./car_off_null_ui.jsp" name="CarOffForm" method="POST" > 
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<table width="800" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><font color="navy">영업지원 -> <a href="./car_office_frame.jsp">자동차영업소관리</a></font> -> <font color="red">영업소등록</font></td>
  </tr>
  <tr>
    <td><div align="right">
	<% if(car_off_id.equals("")){ %>
	 <a href="javascript:CarOffReg()" onMouseOver="window.status=''; return true"> <img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	<% }else{ %>
	 <a href="javascript:CarOffUp()" onMouseOver="window.status=''; return true"> <img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	<% } %>
	 <a href="javascript:history.go(-1);" onMouseOver="window.status=''; return true"> <img src="/images/calcel.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
	 <a href="javascript:go_list();" onMouseOver="window.status=''; return true"> <img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></div></td>
  </tr>
  <tr>
    <td><table width="800" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="2">1. 영업소기초사항관리</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td><table width="780" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                    <tr>
                      <td class="title">제조사</td>
                      <td colspan="3">&nbsp;
   			    		<select name="car_comp_id">
			    			<option value="">선택</option>
							<% for(int i=0; i<cc_r.length; i++){
									cc_bean = cc_r[i];
									if(cc_bean.getNm().equals("에이전트")) continue;
							%>
            				<option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
							<%}%>
						</select>
						<script>
						document.CarOffForm.car_comp_id.value = '<%= car_comp_id %>';
						</script>

                    </tr>
                    <tr>
                      <td class="title">영업소구분</td>
                      <td colspan="3">&nbsp;
                          <input type="radio" name="cust_st" value="2">
                        지점&nbsp;
                        <input type="radio" name="cust_st" value="3">
                        대리점</td>
                    </tr>
                    <tr>
                      <td width="150" class="title">영업소명</td>
                      <td width="240">&nbsp;
                        <input type="text" name="car_off_nm" value="<%= car_off_nm %>" size="20" class=text>
                        </td>
                        <td width="150" class="title">지점장/소장</td>
                      <td width="240">&nbsp;
                        <input type="text" name="owner_nm" value="<%= owner_nm %>" size="15" class="text" style='IME-MODE: active'></td>
                    </tr>
                    <tr>
                      <td class="title">전화번호</td>
                      <td>&nbsp;
                        <input type="text" name="car_off_tel" value="<%= car_off_tel %>" size="12" class=text style='IME-MODE: active'> </td>
                      <td class="title">팩스번호</td>
                      <td>&nbsp;
                        <input type="text" name="car_off_fax" value="<%= car_off_fax %>" size="12" class=text style='IME-MODE: active'></td>
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
                    <td class=title>주소</td>
               		<td colspan=5>&nbsp;
					<input type="text" name='car_off_post' id="car_off_post" value="<%= car_off_post %>" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='car_off_addr' id="car_off_addr" value="<%= car_off_addr %>" size="100">

                </tr>            
                </table></td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2">2. 예금계좌관리</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td><table width="780" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                    <tr>
                      <td width="150" class="title">은행명</td>
                      <td width="240">&nbsp;
                          <select name="emp_bank" style="width:135">
                            <option value="">==선택==</option>
                            <%
					for(int i=0; i<cd_r.length; i++){
						cd_bean = cd_r[i];
				%>
                            <option value="<%= cd_bean.getNm() %>"><%= cd_bean.getNm() %></option>
                            <%}%>
                        </select></td>
                      <td width="150" class="title">예금주명</td>
                      <td width="240">&nbsp;
                          <input type="text" name="emp_acc_nm" value="" size="23" class=text></td>
                    </tr>
                    <tr>
                      <td class="title">계좌번호</td>
                      <td colspan="3">&nbsp;
                          <input type="text" name="emp_acc_no" value="" size="23" class=text></td>
                    </tr>
                </table></td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>				
        <tr>
          <td colspan="2">3. 등록일자</td>
        </tr>
        <tr>
          <td width="20">&nbsp;</td>
          <td width="780"><table width="780" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="line"><table width="780" border="0" cellspacing="1" cellpadding="0">
                    <tr>
                      <td width="150" class="title"> 최초등록일자</td>
                      <td width="240">&nbsp;
                          <input name="reg_dt" type="text" class="whitetext" value="<%= AddUtil.getDate() %>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'>
                      </td>
                      <td width="150" class="title"> 최초등록담당자</td>
                      <td width="240">&nbsp;
                          <select name='reg_id'>
                            <option value="">==선택==</option>
                            <option value="">=영업팀=</option>
                            <%for (int i = 0 ; i < buss.size() ; i++){%>
                            <% Hashtable user = (Hashtable)buss.elementAt(i);%>
                            <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                            <%}%>
                            <option value="">=고객지원팀=</option>
                            <%for (int i = 0 ; i < mngs.size() ; i++){%>
                            <% Hashtable user = (Hashtable)mngs.elementAt(i);%>
                            <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                            <%}%>
                            <option value="">=총무팀=</option>
                            <%for (int i = 0 ; i < gens.size() ; i++){%>
                            <% Hashtable user = (Hashtable)gens.elementAt(i);%>
                            <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                            <%}%>
                          </select>
                      </td>
                    </tr>
                </table></td>
              </tr>
          </table></td>
        </tr>

		
    </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
</body>
</html>
