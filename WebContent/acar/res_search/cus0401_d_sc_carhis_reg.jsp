<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_service.*, acar.serv_off.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	//로그인 사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = c_db.getUserList("", "", "BUS_MNG_EMP"); //영업_고객지원팀 리스트
	int user_size = users.size();
	
	Hashtable rent_id = c_db.getRent_id(car_mng_id);	//계약관리번호,계약번호
 %>

<html>
<head>
<title>차량점검 등록</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//정비업체 선택
	function serv_off_open(){
		var fm = document.form1;
		fm.off_id.value = '';
		fm.off_nm.value = '';
		fm.ent_no.value =  '';
		fm.own_nm.value =  '';
		fm.off_st.value =  '';
		fm.off_addr.value =  '';
		fm.off_tel.value =  '';
		fm.off_fax.value =  '';
		window.open("./cus0401_d_sc_serv_off.jsp", "CLIENT", "left=100, top=120, width=600, height=400");
	}
	
	//등록
	function save(){
		var fm = document.form1;	
		fm.gubun.value = 'i';
		if(fm.car_mng_id.value == ''){ alert('차량이 선택되지 않았습니다. 확인하십시오.'); return; }
		if(!confirm('등록 하시겠습니까?')){ return; }
		fm.target = "i_no";
		fm.action = "./cus0401_d_sc_carhis_regService.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type='hidden' name='go_url' value='<%=go_url%>'>
<input type="hidden" name="rent_mng_id" value="<%= rent_id.get("RENT_MNG_ID") %>">
<input type="hidden" name="rent_l_cd" value="<%= rent_id.get("RENT_L_CD") %>">
<input type="hidden" name="seq_no" value="">
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type="hidden" name="off_id" value="">
<input type="hidden" name="gubun" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량점검 등록</span></td>
        <td align="right"> 
        <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
        <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <tR>
        <td colspan=2 class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class="line">
            <table border=0 cellspacing=1 cellpadding="0" width=100%>
                <tr> 
                    <td class=title>구분</td>
                    <td> 
                      &nbsp;<select name="serv_jc">
                        <option value="">미정</option>
                        <option value="1">정기</option>
                        <option value="2">고객요청</option>
                      </select>
                    </td>
                    <td class=title>정비구분</td>
                    <td> 
                      &nbsp;<select name="serv_st">
                        <option value="">미정</option>
                        <option value="1">순회점검</option>
                        <option value="2">일반정비</option>
                        <option value="3">보증정비</option>
                      </select>
                    </td>
                    <td class=title>점검담당자</td>
                    <td colspan="3"> 
                      &nbsp;<select name='checker'>
                        <%if(user_size > 0){
        				    for (int i = 0 ; i < user_size ; i++){
        					  Hashtable user = (Hashtable)users.elementAt(i);%>
                        <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>접수일자</td>
                    <td> 
                      &nbsp;<input name="cust_serv_dt" type="text" class="text" size="11" value="" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title>정비일자</td>
                    <td> 
                      &nbsp;<input name="serv_dt" type="text" class="text" value="" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td class=title>주행거리</td>
                    <td colspan="3"> 
                      &nbsp;<input name="tot_dist"  class="num" size="10" value="" onBlur='javascript:this.value=parseDecimal(this.value)'>
                      km</td>
                </tr>
                <tr> 
                    <td class=title>기타사항</td>
                    <td colspan="7">
                      &nbsp;<textarea name="rep_cont" cols="100" rows="2" class=default></textarea>
                    </td>
                </tr>
                <tr> 
                    <td width=11% class=title style='height:37'>정비업체 <a href="javascript:serv_off_open()" title="클릭하세요"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a></td>
                    <td width=16%> 
                      &nbsp;<input name="off_nm" class="white" size="26" value="">
                    </td>
                    <td width=11% class=title>사업자번호</td>
                    <td width=14%> 
                      &nbsp;<input name="ent_no" class="white" size="14" value="">
                    </td>
                    <td width=11% class=title>대표자</td>
                    <td width=14%> 
                      &nbsp;<input name="own_nm" class="white" size="14" value="">
                    </td>
                    <td class=title width=11%>급수</td>
                    <td width=12%> 
                      &nbsp;<input name="off_st"  class="white" size="14" value="">
                    </td>
                </tr>
                <tr> 
                    <td class=title>주소</td>
                    <td colspan="3"> 
                      &nbsp;<input name="off_post"  class="white" size="7" value="">
                      &nbsp; 
                      <input name="off_addr"  class="whitetext" size="40" value="">
                    </td>
                    <td class="title">전화번호</td>
                    <td> 
                      &nbsp;<input name="off_tel"  class="white" size="14" value="">
                    </td>
                    <td class="title">FAX</td>
                    <td> 
                      &nbsp;<input name="off_fax"  class="white" size="14" value="">
                    </td>
                </tr>		  
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
