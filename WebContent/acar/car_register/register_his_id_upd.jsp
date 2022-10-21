<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String cha_seq 		= request.getParameter("cha_seq")==null?"":request.getParameter("cha_seq");
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	ch_bean = crd.getCarHis(car_mng_id, cha_seq);
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Upd(){
		fm = document.form1;
		if(fm.car_mng_id.value==''){	alert("상단을 먼저 등록해주세요!"); return; }
		
		//if(fm.filename2.value != ''){
		//	if(fm.filename2.value.indexOf('jpg') == -1 && fm.filename2.value.indexOf('JPG') == -1){		alert('JPG파일이 아닙니다.');						return;		}		
		//}
		
		
		if(!confirm("수정하시겠습니까?"))	return;
		fm.action = "register_his_id_upd_a.jsp";
//		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/car_register_register_his_id_upd_a.jsp";		
		fm.target = "i_no";
		fm.submit();
	}
//-->	
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="cha_seq" value="<%=cha_seq%>">
<input type="hidden" name="scanfile" value="<%= ch_bean.getScanfile() %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="right"><a href="javascript:Upd();"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a></div></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=7%>연번</td>
                    <td class=title width=12%>변경일자</td>
                    <td class=title width=15%>차량번호</td>
                    <td class=title width=27%>사유</td>
                    <td class=title width=39%>상세내용</td>
                    <!--<td class=title width=24%>등록증스캔</td>-->
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td align=center><input type="text" name="cha_dt" size="12" class=text value="<%= AddUtil.ChangeDate2(ch_bean.getCha_dt()) %>" maxlength="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align=center><input type="text" name="cha_car_no" size="10" class=text value="<%= ch_bean.getCha_car_no() %>" maxlength="15" style='IME-MODE: active'></td>
                    <td align=center> <select name="cha_cau" style="width:125px">
                          <option value="5" <% if(ch_bean.getCha_cau().equals("5")) out.print("selected"); %>>신규등록</option>
                          <option value="1" <% if(ch_bean.getCha_cau().equals("1")) out.print("selected"); %>>사용본거지 변경</option>
                          <option value="2" <% if(ch_bean.getCha_cau().equals("2")) out.print("selected"); %>>용도변경</option>
                          <option value="3" <% if(ch_bean.getCha_cau().equals("3")) out.print("selected"); %>>기타</option>
                          <option value="4" <% if(ch_bean.getCha_cau().equals("4")) out.print("selected"); %>>없음</option>
                        </select></td>
                    <td>&nbsp;<input type="text" name="cha_cau_sub" value="<%= ch_bean.getCha_cau_sub() %>" size="30" class=text></td>
                    <!--<td>&nbsp;<input type="file" name="filename2" size="15"></td>-->
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
</html>
